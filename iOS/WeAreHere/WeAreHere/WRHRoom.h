//
//  WRHRoom.h
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WRHRoom : NSObject

-(instancetype) initWithDictionary:(NSDictionary *)dictionary;

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *roomNumber;
@property (strong, nonatomic) CLLocation *center;

@end
