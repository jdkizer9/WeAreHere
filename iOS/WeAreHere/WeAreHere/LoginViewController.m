//
//  LoginViewController.m
//  WeAreHere
//
//  Created by Tara Wilson on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "LoginViewController.h"
#import "LocationsTableViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.delegate = self;
    NSLog(@"view did load");
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





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    LocationsTableViewController *vc = [segue destinationViewController];
    NSLog(@"%@",_loginuser);
    vc.currentuser = _loginuser;
    
    

}




@end
