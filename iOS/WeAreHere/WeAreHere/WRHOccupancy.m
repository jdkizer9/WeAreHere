//
//  WRHOccupancyObject.m
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "WRHOccupancy.h"
#import "WRHRoomManager.h"
@implementation WRHOccupancy

+(void)occupancyObjectFromDictionary:(NSDictionary *)dictionary
                        onCompletion:(void (^)(WRHOccupancy *))completionBlock
{
    WRHOccupancy *returnObject = [[WRHOccupancy alloc]init];
    returnObject.name = dictionary[@"name"];
    
    [[WRHRoomManager sharedManager] getRoomForRoomId:dictionary[@"roomId"] onCompletion:^(WRHRoom *room) {
        returnObject.room = room;
        if(completionBlock)
            completionBlock(returnObject);
    }];
}

@end
