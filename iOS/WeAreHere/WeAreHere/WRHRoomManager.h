//
//  WRHRoomManager.h
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRHRoom.h"

@interface WRHRoomManager : NSObject

+ (instancetype)sharedManager;

-(void)getRoomsOnCompletion:(void (^)(NSArray *roomArray))completionBlock;

-(void)getRoomForRoomId:(NSString *)roomId
           onCompletion:(void (^)(WRHRoom *))completionBlock;

-(WRHRoom *)getRoomForRoomId:(NSString *)roomId;


@end
