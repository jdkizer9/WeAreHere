//
//  WRHOccupancyManager.m
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "WRHOccupancyManager.h"
#import "WRHCommunicationManager.h"
#import "WRHRoomManager.h"

@interface WRHOccupancyManager()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) WRHOccupancy *occupancy;


@end

@implementation WRHOccupancyManager


+ (id)sharedManager {
    static WRHOccupancyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)setMyName:(NSString *)name
{
    self.name = name;
}

- (void)getOccupancyOnCompletion:(void (^)(NSArray *occupancyArray))completionBlock
{
    [[WRHCommunicationManager sharedManager] getOccupancyOnCompletion:^(NSArray *occupancyArray) {
      
        
        //translate dictionaries to occupancy objects
        [[WRHRoomManager sharedManager] getRoomsOnCompletion:^(NSArray *roomArray) {
            
            __block NSMutableArray *occupancyMutableArray = [[NSMutableArray alloc]init];
            [occupancyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                WRHOccupancy *occupancy = [[WRHOccupancy alloc]init];
                NSDictionary *dictionary = (NSDictionary *)obj;
                occupancy.name = dictionary[@"name"];
                occupancy.room = [[WRHRoomManager sharedManager] getRoomForRoomId:dictionary[@"room_id"]];
                [occupancyMutableArray addObject:occupancy];

            }];
            
            if(completionBlock)
                completionBlock([NSArray arrayWithArray:occupancyMutableArray]);
            
        }];
        
    }];
    
    
}

@end
