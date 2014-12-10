//
//  WRHCommunicationManager.h
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface WRHCommunicationManager : NSObject

+ (id)sharedManager;

//-(void)testLog:(NSString *)testLog
//       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getOccupancyOnCompletion:(void (^)(NSArray *occupancyArray))completionBlock;

-(void)createOccupancy:(NSDictionary *)occupancyDictionary
          onCompletion:(void (^)(id))completionBlock;

-(void)getRoomForBeaconSamples:(NSArray *)beaconSampleArray
          onCompletion:(void (^)(NSNumber *roomId))completionBlock;


-(void)getAllUsersOnCompletion:(void (^)(NSArray *userArray))completionBlock;

-(void)loggedIn:(void (^)(BOOL loggedIn))completionBlock;
-(void)logout;

-(void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
             onCompletion:(void (^)(id))completionBlock;

-(void)getCurrentUserOnCompletion:(void (^)(id))completionBlock;



@end
