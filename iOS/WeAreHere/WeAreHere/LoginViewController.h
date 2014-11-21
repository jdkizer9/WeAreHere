//
//  LoginViewController.h
//  WeAreHere
//
//  Created by Tara Wilson on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;

@property (nonatomic, strong) NSString *loginuser;
@end
