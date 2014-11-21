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


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.delegate = self;
    NSLog(@"view did load");
    [self addImageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    _loginuser = textField.text;
    return true;

}

-(void)addImageView{
    UIImageView *imgview = [[UIImageView alloc]
                            initWithFrame:CGRectMake(38, 10, 300, 400)];
    [imgview setImage:[UIImage imageNamed:@"Cornell_NYC_Tech_logo.png"]];
    [imgview setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgview];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    [[WRHCommunicationManager sharedManager] createOccupancy:@{@"name": @"James", @"room_id": @"17"} onCompletion:^(id responseObject) {
        LocationsTableViewController *vc = [segue destinationViewController];
        NSLog(@"%@",_loginuser);
        vc.currentuser = _loginuser;
        _username.text = nil;
        [_username resignFirstResponder];
    }];
   
    

}




@end
