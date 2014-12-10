//
//  WRHUserManager.h
//  WeAreHere
//
//  Created by James Kizer on 12/9/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRHUser.h"

@interface WRHUserManager : NSObject

+ (id)sharedManager;

@property (strong, nonatomic, readonly) WRHUser *currentUser;
@property (strong, nonatomic, readonly) NSArray *users;

-(void) updateUserArrayOnCompletion:(void (^)())completionBlock;

-(void)logInWithUsername:(NSString *)username
                password:(NSString *)password
            onCompletion:(void (^)(WRHUser *user))completionBlock;

//-(void)getCurrentUserOnCompletion:(void (^)(id))completionBlock;

//-(void)loggedIn:(void (^)(BOOL loggedIn))completionBlock;

-(void)logout;

@end
