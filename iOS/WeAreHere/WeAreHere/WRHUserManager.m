//
//  WRHUserManager.m
//  WeAreHere
//
//  Created by James Kizer on 12/9/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "WRHUserManager.h"
#import "WRHCommunicationManager.h"

@interface WRHUserManager()

@property (strong, nonatomic) WRHUser *currentUser;
@property (strong, nonatomic) NSArray *users;

@end

@implementation WRHUserManager

+ (id)sharedManager {
    static WRHUserManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    
    });
    return sharedManager;
}

-(NSArray *)users
{
    if(!_users) _users = [[NSArray alloc]init];
    return _users;
    
}

-(void) updateUserArrayOnCompletion:(void (^)())completionBlock
{
    self.users = nil;
    [[WRHCommunicationManager sharedManager] getAllUsersOnCompletion:^(NSArray *userArray) {
       
        if([userArray isKindOfClass:[NSArray class]])
        {
            __block NSMutableArray *tmpUserArray = [[NSMutableArray alloc]init];
            
            [userArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                WRHUser *user = [[WRHUser alloc]init];
                user.userId = [obj objectForKey:@"id"];
                user.username = [obj objectForKey:@"username"];
                [tmpUserArray addObject:user];
            }];
            self.users = [NSArray arrayWithArray:tmpUserArray];
        }
        else
            if(completionBlock)
                completionBlock();
        
    }];
    
    
}

-(void)logInWithUsername:(NSString *)username
                password:(NSString *)password
            onCompletion:(void (^)(id))completionBlock
{
    
    [[WRHCommunicationManager sharedManager]logInWithUsername:username password:password onCompletion:^(id obj) {
        
        if(obj)
        {
            
        }
        
    }];
    
}

//-(void)getCurrentUserOnCompletion:(void (^)(id))completionBlock
//{
//    
//}

//-(void)loggedIn:(void (^)(BOOL loggedIn))completionBlock
//{
//    
//}

-(void)logout
{
    [[WRHCommunicationManager sharedManager]logout];
}




@end
