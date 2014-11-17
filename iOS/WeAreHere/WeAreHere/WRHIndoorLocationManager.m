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

@interface WRHIndoorLocationManager() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CMPedometer *pedometerManager;
@property (strong, nonatomic) CMPedometerData *lastPedometerReading;
@property (strong, atomic) WRHSampleContainer *sampleContainer;

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
    //begin pedometer monitoring
    [self testLog:[NSString stringWithFormat:@"Began Monitoring Pedometer Events"]];
    [self.pedometerManager startPedometerUpdatesFromDate:[NSDate date]
                                             withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                                 //a unique pedometer event has occurred. start sampling beacons
                                                 if( !([[pedometerData startDate] isEqualToDate:[self.lastPedometerReading startDate]] && [[pedometerData endDate] isEqualToDate:[self.lastPedometerReading endDate]]))
                                                 {
                                                     self.lastPedometerReading = pedometerData;
                                                     
                                                     [self testLog:[NSString stringWithFormat:@"Just received pedometer event.\n%@", pedometerData]];
                                                     
                                                     //note that once the sample container is filled, it will call the completion block
                                                     self.sampleContainer = [[WRHSampleContainer alloc]initWithNumberOfSamples:self.numberOfBeaconSamples
                                                                                                               completionBlock:^(NSArray *sampleArray) {
                                                                                                                   [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
                                                                                                                   [self processBeaconSamples:sampleArray];
                                                                                                               }];
                                                     [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
                                                 }
                                             }];
    
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
        [self testLog:[NSString stringWithFormat:@"Just entered %@", self.beaconRegion.identifier]];
        //begin pedometer monitoring
        [self startMonitoringPedometer];
    }
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    [self testLog:[NSString stringWithFormat:@"Determined state for %@: %li", region, state]];
    if([region.identifier isEqualToString:self.beaconRegion.identifier] && (state == CLRegionStateInside))
    {
        [self testLog:[NSString stringWithFormat:@"You are in %@", self.beaconRegion.identifier]];
        //begin pedometer monitoring
        [self startMonitoringPedometer];
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
        [self testLog:[NSString stringWithFormat:@"Just exited %@", self.beaconRegion.identifier]];
        //stop pedometer monitoring
        [self stopMonitoringPedometer];
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
    [self testLog:[NSString stringWithFormat:@"Just entered got a bunch of samples"]];
    NSLog(@"%@", sampleArray);
    //reduce the beacon samples
    
    //send to server classifier to get room id
    
    //if not the current room (and within 30 mins) post room id to the server
        //save the room id
}








@end
