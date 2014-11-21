//
//  LocationsTableViewController.m
//  WeAreHere
//
//  Created by Tara Wilson on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "LocationsTableViewController.h"
#import "MapViewController.h"
#import "WRHOccupancyManager.h"
#import "WRHCommunicationManager.h"

@interface LocationsTableViewController (){
    NSIndexPath *lastIndexPath;
}

@property (strong, nonatomic) NSArray *occupancyArray;
@property (strong, nonatomic) WRHOccupancy *selectedOccupancy;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation LocationsTableViewController

-(NSArray *)occupancyArray
{
    if(!_occupancyArray) _occupancyArray = [[NSArray alloc]init];
    return _occupancyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _currentuser;
    
    
    self.users= [[NSArray alloc] initWithObjects: @"Tara", @"Neil", @"James",
                  @"Deborah", @"Visitor", nil];
    self.locations= [[NSArray alloc] initWithObjects: @"Entrance", @"Studio", @"Big Red",
                 @"Fozzie", @"Unknown", nil];
    
    //[self loadData];
    
    NSLog(@"Current user is %@", _currentuser);
    
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.backgroundColor = [UIColor purpleColor];
//    self.refreshControl.tintColor = [UIColor whiteColor];
//    [self.refreshControl addTarget:self
//                            action:@selector(loadData)
//                  forControlEvents:UIControlEventValueChanged];

    
}

-(void)loadData
{
    
    [[WRHOccupancyManager sharedManager] getOccupancyOnCompletion:^(NSArray *occupancyArray) {
        
        self.occupancyArray = [NSArray arrayWithArray:occupancyArray];
        [self.tableView reloadData];
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
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

    //return [self.users count];
    return [self.occupancyArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    WRHOccupancy *occupancy = [self.occupancyArray objectAtIndex:indexPath.row];
    
    //cell.textLabel.text=[self.users objectAtIndex:indexPath.row];
    cell.textLabel.text = occupancy.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", occupancy.room.name, occupancy.room.roomNumber];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@", [self.users objectAtIndex:indexPath.row], @"\n", [self.locations objectAtIndex:indexPath.row]];
    
 

    
    

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
    //_finduser = [self.users objectAtIndex:indexPath.row];
    //_findlocation = [self.locations objectAtIndex:indexPath.row];
    
    self.selectedOccupancy = [self.occupancyArray objectAtIndex:indexPath.row];
    
    [tableView reloadData];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *vc = [segue destinationViewController];

    vc.user = self.selectedOccupancy.name;
    vc.location = self.selectedOccupancy.room.center;
    
}


@end
