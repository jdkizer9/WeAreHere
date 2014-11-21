//
//  WRHOccupancyObject.h
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRHRoom.h"

@interface WRHOccupancy : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) WRHRoom *room;

+(void)occupancyObjectFromDictionary:(NSDictionary *)dictionary
                        onCompletion:(void (^)(WRHOccupancy *))completionBlock;

@end
