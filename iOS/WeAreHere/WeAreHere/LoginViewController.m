//
//  LoginViewController.m
//  WeAreHere
//
//  Created by Tara Wilson on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "LoginViewController.h"
#import "LocationsTableViewController.h"
#import "WRHCommunicationManager.h"
#import "WRHIndoorLocationManager.h"
#import "WRHUserManager.h"

static NSString *baseURLStringKey = @"BaseURL";

@interface LoginViewController ()

@end

@implementation LoginViewController{
    NSMutableData *_responseData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.delegate = self;
    NSLog(@"view did load");
    [self addImageView];
    self.password.secureTextEntry = true;
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
//    
//
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"Neil", @"hello"];
//    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
//    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedDataWithOptions:LINE_MAX]];
//    
//    
//    
//    [conn setValue:authValue forHTTPHeaderField:@"Authorization"];
//    
//    
    
    // Do any additional setup after loading the view.
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    self.loginuser = self.username.text;
    self.loginpassword = self.password.text;
    [textField resignFirstResponder];
    return true;

}

-(void)addImageView{
    UIImageView *imgview = [[UIImageView alloc]
                            initWithFrame:CGRectMake(38, 0, 300, 400)];
    [imgview setImage:[UIImage imageNamed:@"Cornell_NYC_Tech_logo.png"]];
    [imgview setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgview];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    
//    [[WRHCommunicationManager sharedManager] createOccupancy:@{@"name": @"James", @"room_id": @"17"} onCompletion:^(id responseObject) {
//        LocationsTableViewController *vc = [segue destinationViewController];
//        NSLog(@"%@",_loginuser);
//        vc.currentuser = _loginuser;
//        _username.text = nil;
//        [_username resignFirstResponder];
//    }];
    
    LocationsTableViewController *vc = [segue destinationViewController];
    NSLog(@"%@",_loginuser);
    vc.currentuser = _loginuser;
    WRHIndoorLocationManager *indoorLocationManger = [WRHIndoorLocationManager sharedManager];
    indoorLocationManger.userName = [NSString stringWithString:self.loginuser];
    indoorLocationManger.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"] identifier:@"Cornell Tech Beacon Region"];
    indoorLocationManger.numberOfBeaconSamples = 10;
    indoorLocationManger.classifierName = @"default classifier";
    
    [indoorLocationManger startMonitoringIndoorLocation];
    
    _username.text = nil;
    [_username resignFirstResponder];
   
    

}

- (IBAction)pressedGoButton:(id)sender {
    
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    
    [[WRHUserManager sharedManager] logInWithUsername:self.loginuser password:self.loginpassword  onCompletion:^(WRHUser *user) {
        
        self.view.userInteractionEnabled = YES;
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        [activityIndicator removeFromSuperview];
        
        if(user)
            [self performSegueWithIdentifier:@"Show Occupancy" sender:nil];
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials" message:@"Please enter a valid username and password to continue." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
        
        
            
    }];
    
}


- (IBAction)registerButtonPress:(id)sender {
    
    NSString *URLString = [NSString stringWithFormat:@"%@/register", [[[NSBundle mainBundle] objectForInfoDictionaryKey:baseURLStringKey] copy]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    
}


@end
