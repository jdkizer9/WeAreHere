//
//  WRHRoom.m
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "WRHRoom.h"

@implementation WRHRoom

-(instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        self.objectId = [dictionary[@"id"] copy];
        self.name = [dictionary[@"name"] copy];
        self.roomNumber = [dictionary[@"room_number"] copy];
        self.center = [[CLLocation alloc] initWithLatitude:[[dictionary objectForKey:@"y_coord"] floatValue] longitude:[[dictionary objectForKey:@"x_coord"] floatValue]];
    }
    return self;
}

@end
