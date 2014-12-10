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

@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) WRHRoom *room;
@property (strong, nonatomic) NSDate *when;

+(NSDateFormatter *)longDateFormatter;

//+(void)occupancyObjectFromDictionary:(NSDictionary *)dictionary
//                        onCompletion:(void (^)(WRHOccupancy *))completionBlock;

@end
