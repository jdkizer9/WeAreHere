//
//  WRHIndoorLocationManager.h
//  WeAreHere
//
//  Created by James Kizer on 11/15/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LogBlock)(NSString *logString);

@interface WRHIndoorLocationManager : NSObject


+ (id)sharedManager;

-(void)startMonitoringIndoorLocation;
-(void)stopMonitoringIndoorLocation;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) NSInteger numberOfBeaconSamples;
@property (nonatomic) NSTimeInterval beaconSamplingInterval;
@property (strong, nonatomic) NSString *classifierName;
@property (strong, nonatomic) LogBlock logBlock;
@property (strong, nonatomic) NSString *userName;


@end
