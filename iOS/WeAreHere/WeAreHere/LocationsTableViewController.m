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
//    NSIndexPath *lastIndexPath;
}

@property (strong, nonatomic) NSArray *indexarray;
@property (strong, nonatomic) NSArray *occupancyArray;
@property (strong, nonatomic) WRHOccupancy *selectedOccupancy;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *cellsSelected;
@property (strong, nonatomic) NSMutableArray *sendusers;
@property (strong, nonatomic) NSMutableArray *sendlocations;
@property (strong, nonatomic) NSMutableArray *userintable;

@end

@implementation LocationsTableViewController

-(NSArray *)occupancyArray
{
    if(!_occupancyArray) _occupancyArray = [[NSArray alloc]init];
    return _occupancyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellsSelected = [NSMutableArray array];
    self.userintable = [NSMutableArray array];
    self.sendusers = [NSMutableArray array];
    self.sendlocations = [NSMutableArray array];
    self.title = self.currentuser;
    
    
    
    NSLog(@"Current user is %@", self.currentuser);
    
    


    
}

-(void)loadData
{
    
    [[WRHOccupancyManager sharedManager] getOccupancyOnCompletion:^(NSArray *occupancyArray) {
        
        self.occupancyArray = [NSArray arrayWithArray:occupancyArray];

        for (WRHOccupancy *myocc in occupancyArray){
            if([myocc.user isEqualToString:self.currentuser]){
                NSLog(@"it's my user!");
                NSLog(@"%@", [myocc.room description]);
                self.currentlocation = myocc.room.center;
                break;
            }
        }
        
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return [self.users count];
    return [self.occupancyArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    WRHOccupancy *occupancy = [self.occupancyArray objectAtIndex:indexPath.row];
    

    cell.textLabel.text = occupancy.user;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", occupancy.room.name, occupancy.room.roomNumber];
    [self.userintable addObject:occupancy.user];

 

    
    if ([self.cellsSelected containsObject:indexPath])
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
    [self.sendlocations removeAllObjects];
    [self.sendusers removeAllObjects];
    [self.cellsSelected removeAllObjects];
//  MapViewController *vc = [unwindSegue ];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WRHOccupancy *curroccupancy = [self.occupancyArray objectAtIndex:indexPath.row];
    
    if ([self.cellsSelected containsObject:indexPath])
    {
        [self.cellsSelected removeObject:indexPath];
        [self.sendusers removeObject:curroccupancy.user];
        [self.sendlocations removeObject:curroccupancy.room.center];
 
    }
    else
    {
        [self.cellsSelected addObject:indexPath];
        [self.sendusers addObject:curroccupancy.user];
        [self.sendlocations addObject:curroccupancy.room.center];
        

    }
    
    
//    self.selectedOccupancy = [self.occupancyArray objectAtIndex:indexPath.row];
    [tableView reloadData];
    
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *vc = [segue destinationViewController];

   
    
    
    vc.user = self.currentuser;
    vc.location = self.currentlocation;
    vc.receiveusers = self.sendusers;
    vc.receivelocations = self.sendlocations;

    
    
}


@end
