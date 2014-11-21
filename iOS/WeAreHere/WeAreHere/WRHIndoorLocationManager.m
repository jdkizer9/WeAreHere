//
//  WRHIndoorLocationManager.m
//  WeAreHere
//
//  Created by James Kizer on 11/15/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "WRHIndoorLocationManager.h"
#import <CoreMotion/CoreMotion.h>
#import "WRHSampleContainer.h"

#import "WRHCommunicationManager.h"

@interface WRHIndoorLocationManager() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CMPedometer *pedometerManager;
@property (strong, nonatomic) CMPedometerData *lastPedometerReading;
@property (strong, atomic) WRHSampleContainer *sampleContainer;

@property (strong, nonatomic) WRHCommunicationManager *commManager;
@property (nonatomic) NSTimeInterval checkoutDelay;

@property (atomic) CLRegionState regionState;



@end


@implementation WRHIndoorLocationManager

+ (id)sharedManager {
    static WRHIndoorLocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        assert([CLLocationManager isRangingAvailable]);
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.locationManager startUpdatingLocation];
        
        self.pedometerManager = [[CMPedometer alloc]init];
        
        self.commManager = [WRHCommunicationManager sharedManager];
        
        self.checkoutDelay = 10.0;
        self.regionState = CLRegionStateUnknown;
        
    }
    return self;
}

-(void)testLog:(NSString *)message
{
    if(self.logBlock)
        
        self.logBlock(message);
}

-(void)startMonitoringIndoorLocation
{
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self testLog:[NSString stringWithFormat:@"Began Monitoring %@", self.beaconRegion]];
    
    
    
    [self.locationManager requestStateForRegion:self.beaconRegion];
    [self testLog:[NSString stringWithFormat:@"Requested state for %@", self.beaconRegion]];
}

-(void)stopMonitoringIndoorLocation
{
    [self stopMonitoringPedometer];
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self testLog:[NSString stringWithFormat:@"Stopped Monitoring %@", self.beaconRegion]];
    
    //post leave notification to server
}

-(BOOL)isRangingBeaconRegion
{
    NSSet *regions = [self.locationManager rangedRegions];
    return [regions containsObject:self.beaconRegion];
}


-(void)startMonitoringPedometer
{
    //get beacon samples for the first time
    [self getBeaconSamples];
    
    //begin pedometer monitoring
    [self testLog:[NSString stringWithFormat:@"Began Monitoring Pedometer Events"]];
    [self.pedometerManager startPedometerUpdatesFromDate:[NSDate date]
                                             withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                                 //a unique pedometer event has occurred. start sampling beacons
                                                 if( !([[pedometerData startDate] isEqualToDate:[self.lastPedometerReading startDate]] && [[pedometerData endDate] isEqualToDate:[self.lastPedometerReading endDate]]))
                                                 {
                                                     self.lastPedometerReading = pedometerData;
                                                     
                                                     [self testLog:[NSString stringWithFormat:@"Just received pedometer event.\n%@", pedometerData]];
                                                     
                                                     [self getBeaconSamples];
                                                     
                                                 }
                                             }];
    
}

-(void)getBeaconSamples
{
    //note that once the sample container is filled, it will call the completion block
    self.sampleContainer = [[WRHSampleContainer alloc]initWithNumberOfSamples:self.numberOfBeaconSamples
                                                              completionBlock:^(NSArray *sampleArray) {
                                                                  [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
                                                                  [self processBeaconSamples:sampleArray];
                                                              }];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)stopMonitoringPedometer
{
    //cancel any sampling thats going on
    [self testLog:[NSString stringWithFormat:@"Stopped Monitoring Pedometer Events"]];
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self.pedometerManager stopPedometerUpdates];
}

#pragma mark - CLLocationManagerDelegate methods
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if([region.identifier isEqualToString:self.beaconRegion.identifier])
    {
        if(self.regionState != CLRegionStateInside)
            [self enterRegionHandler];
        else
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(exitRegionHandler) object:nil];
    }
}

-(void)enterRegionHandler
{
    if(self.regionState == CLRegionStateInside)
        [self.commManager testLog:[NSString stringWithFormat:@"State messed up for region"] success:nil failure:nil];
    self.regionState = CLRegionStateInside;
    [self testLog:[NSString stringWithFormat:@"Just entered %@", self.beaconRegion.identifier]];
    [self.commManager testLog:[NSString stringWithFormat:@"Just entered %@", self.beaconRegion.identifier] success:nil failure:nil];
    //begin pedometer monitoring
    [self startMonitoringPedometer];
    //hack for background processing
    //[self.locationManager startUpdatingLocation];
}

-(void)exitRegionHandler
{
    self.regionState = CLRegionStateOutside;
    [self testLog:[NSString stringWithFormat:@"Just exited %@", self.beaconRegion.identifier]];
    [self.commManager testLog:[NSString stringWithFormat:@"Just exited %@", self.beaconRegion.identifier] success:nil failure:nil];
    //stop pedometer monitoring
    [self stopMonitoringPedometer];
    
    //hack for background processing
    //[self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    [self testLog:[NSString stringWithFormat:@"Determined state for %@: %li", region, state]];
    if([region.identifier isEqualToString:self.beaconRegion.identifier] && (state == CLRegionStateInside))
    {
        if(self.regionState != CLRegionStateInside)
            [self enterRegionHandler];
        else
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(exitRegionHandler) object:nil];
    }
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    [self testLog:[NSString stringWithFormat:@"Monitoring failed for region %@: %@", region, error]];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if([region.identifier isEqualToString:self.beaconRegion.identifier])
    {
        assert(self.regionState == CLRegionStateInside);
        
        [self performSelector:@selector(exitRegionHandler) withObject:nil afterDelay:self.checkoutDelay];
    }
}



-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if([region.identifier isEqualToString:self.beaconRegion.identifier])
    {
        [self testLog:[NSString stringWithFormat:@"Just ranged %@", self.beaconRegion.identifier]];
        //note that once the sample container is filled, it will call the completion block above.
        [self.sampleContainer addSample:beacons];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //Do nothing here, but enjoy ranging callbacks in background :-)
}

-(void)processBeaconSamples:(NSArray *)sampleArray
{
    [self testLog:[NSString stringWithFormat:@"Just got a bunch of samples"]];
    //NSLog(@"%@", sampleArray);
    
    [self.commManager testLog:[NSString stringWithFormat:@"Just got a bunch of samples"] success:nil failure:nil];
    
    //reduce the beacon samples
    
    //send to server classifier to get room id
    
    //if not the current room (and within 30 mins) post room id to the server
        //save the room id
}








@end
