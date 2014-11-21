//
//  WRHRoomManager.m
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "WRHRoomManager.h"
#import "WRHRoom.h"
#import <CoreLocation/CoreLocation.h>

@interface WRHRoomManager()

@property (strong, nonatomic) NSArray *roomArray;

@end

@implementation WRHRoomManager


+ (id)sharedManager {
    static WRHRoomManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.roomArray = @[
                           
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"1",
                                                                @"name":@"Entrance",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"-11",
                                                                @"x_coord" : @"-103"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"2",
                                                                @"name":@"Touchdown",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"-21",
                                                                @"x_coord" : @"-142"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"3",
                                                                @"name":@"Ursa",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"3",
                                                                @"x_coord" : @"-142"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"4",
                                                                @"name":@"Dubi",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"18",
                                                                @"x_coord" : @"-142"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"5",
                                                                @"name":@"Koala",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"14",
                                                                @"x_coord" : @"-114"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"6",
                                                                @"name":@"Panda",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"2",
                                                                @"x_coord" : @"-113"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"7",
                                                                @"name":@"Berenstein",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"13",
                                                                @"x_coord" : @"-71"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"8",
                                                                @"name":@"Bear Necessities",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"13",
                                                                @"x_coord" : @"-56"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"9",
                                                                @"name":@"Bear Hug",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"15",
                                                                @"x_coord" : @"-15"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"10",
                                                                @"name":@"Baron",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"31",
                                                                @"x_coord" : @"-13"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"11",
                                                                @"name":@"Fozzie",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"4.8",
                                                                @"x_coord" : @"90.664"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"12",
                                                                @"name":@"Paddington",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"25",
                                                                @"x_coord" : @"40"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"13",
                                                                @"name":@"Mum",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"20",
                                                                @"x_coord" : @"40"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"14",
                                                                @"name":@"Studio",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"35",
                                                                @"x_coord" : @"100"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"15",
                                                                @"name":@"Kitchen",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"15",
                                                                @"x_coord" : @"10"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"16",
                                                                @"name":@"Sun Bear",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"56",
                                                                @"x_coord" : @"133"}],
                           [[WRHRoom alloc]initWithDictionary:@{@"id" : @"17",
                                                                @"name":@"Big Red",
                                                                @"room_number" : @"",
                                                                @"y_coord" : @"40",
                                                                @"x_coord" : @"133"}],
                           
                           
                           ];
        
    }
    return self;
}

-(void)getRoomsOnCompletion:(void (^)(NSArray *roomArray))completionBlock
{
    //if (self.roomArray.count == 0)
    
    if(completionBlock)
        completionBlock(self.roomArray);
    
}

-(void)getRoomForRoomId:(NSString *)roomId
           onCompletion:(void (^)(WRHRoom *))completionBlock
{
    
    //if (self.roomArray.count == 0)
    
    [self.roomArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        WRHRoom *room = (WRHRoom *)obj;
        if([room.objectId isEqualToString:roomId])
        {
            *stop = YES;
            if(completionBlock)
                completionBlock(room);
        }
        
    }];
}

-(WRHRoom *)getRoomForRoomId:(NSString *)roomId
{
    __block WRHRoom *returnRoom = nil;
    
    [self.roomArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        WRHRoom *room = (WRHRoom *)obj;
        if([room.objectId isEqualToString:roomId])
        {
            *stop = YES;
            returnRoom = room;
        }
        
    }];
    
    return returnRoom;
}



@end
