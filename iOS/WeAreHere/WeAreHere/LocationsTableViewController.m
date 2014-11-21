//
//  LocationsTableViewController.m
//  WeAreHere
//
//  Created by Tara Wilson on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "LocationsTableViewController.h"
#import "MapViewController.h"

@interface LocationsTableViewController (){
    NSIndexPath *lastIndexPath;
}


@end

@implementation LocationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _currentuser;
    
    
    self.users= [[NSArray alloc] initWithObjects: @"Tara", @"Neil", @"James",
                  @"Deborah", @"Visitor", nil];
    self.locations= [[NSArray alloc] initWithObjects: @"Entrance", @"Studio", @"Big Red",
                 @"Fozzie", @"Unknown", nil];
    
    NSLog(@"Current user is %@", _currentuser);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.users count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.text=[self.users objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@", [self.users objectAtIndex:indexPath.row], @"\n", [self.locations objectAtIndex:indexPath.row]];
    
 

    
    

    if ([indexPath compare:lastIndexPath] == NSOrderedSame)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (IBAction)unwindToTable:(UIStoryboardSegue *)unwindSegue
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lastIndexPath = indexPath;
    _finduser = [self.users objectAtIndex:indexPath.row];
    _findlocation = [self.locations objectAtIndex:indexPath.row];
    
    
    [tableView reloadData];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *vc = [segue destinationViewController];

    vc.user = _finduser;
    vc.location = _findlocation;
    
    
}


@end
