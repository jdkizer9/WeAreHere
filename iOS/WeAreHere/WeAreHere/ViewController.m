//
//  ViewController.m
//  WeAreHere
//
//  Created by James Kizer on 11/14/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "ViewController.h"
#import "WRHIndoorLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *statusUpdates;

@property (weak, nonatomic) IBOutlet UISwitch *steathModeSwitch;

@property (strong, nonatomic) WRHIndoorLocationManager *indoorLocationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@end

@implementation ViewController

- (id)init {
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    _indoorLocationManager = [WRHIndoorLocationManager sharedManager];
    _indoorLocationManager.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"] identifier:@"Cornell Tech Beacon Region"];
    _indoorLocationManager.numberOfBeaconSamples = 10;
    _indoorLocationManager.classifierName = @"default classifier";
    _indoorLocationManager.logBlock = ^(NSString *logString) {
        [self addToTestLog:logString];
    };
    
    _statusUpdates = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(!self.steathModeSwitch.isOn)
        [self.indoorLocationManager startMonitoringIndoorLocation];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testLog:(NSString *)message
{
    NSLog(@"%@", message);
    self.statusUpdates = [self.statusUpdates stringByAppendingString:[NSString stringWithFormat:@"[%@]: %@\n", [NSDate date], message]];
    
    [self updateUI];
}

-(void) addToTestLog:(NSString *)message
{
    NSLog(@"%@", message);
    self.statusUpdates = [self.statusUpdates stringByAppendingString:[NSString stringWithFormat:@"[%@]: %@\n", [NSDate date], message]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI];
    });
}

-(void)updateUI
{
    self.textView.text = self.statusUpdates;
    if([self.statusUpdates length] > 0)
        [self.textView scrollRangeToVisible:NSMakeRange([self.statusUpdates length]-1, 1)];
}

- (IBAction)switchValueChanged:(id)sender {
    
    UISwitch *motionSwitch = (UISwitch *)sender;
    
    if(motionSwitch.isOn)
    {
        if(motionSwitch == self.steathModeSwitch)
        {
            [self testLog:@"Entering Stealth Mode. Disabling Indoor Location Manager"];
            [self.indoorLocationManager stopMonitoringIndoorLocation];
            
        }
        
    }
    else
    {
        if(motionSwitch == self.steathModeSwitch)
        {
            [self testLog:@"Exiting Stealth Mode. Enabling Indoor Location Manager"];
            [self.indoorLocationManager startMonitoringIndoorLocation];
            
        }
    }
    
}
- (IBAction)clear:(id)sender {
    self.statusUpdates = @"";
    [self updateUI];
}

@end

