//
//  WRHOccupancyManager.h
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRHOccupancy.h"

@interface WRHOccupancyManager : NSObject

+ (id)sharedManager;
- (void)getOccupancyOnCompletion:(void (^)(NSArray *occupancyArray))completionBlock;

@end
