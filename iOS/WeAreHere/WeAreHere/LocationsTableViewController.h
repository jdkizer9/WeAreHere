//
//  LocationsTableViewController.h
//  WeAreHere
//
//  Created by Tara Wilson on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSString *currentuser;
@property NSString *finduser;
@property NSString *findlocation;


@end
