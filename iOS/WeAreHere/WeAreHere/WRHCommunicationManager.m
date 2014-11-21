//
//  WRHCommunicationManager.m
//  WeAreHere
//
//  Created by James Kizer on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "WRHCommunicationManager.h"
//#import <AFNetworking.h>
#import <AFNetworkActivityLogger.h>
#import "WRHOccupancy.h"
#import "WRHRoomManager.h"

static NSString *baseURLStringKey = @"BaseURL";


@interface WRHCommunicationManager()

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;

@end

@implementation WRHCommunicationManager

+ (id)sharedManager {
    static WRHCommunicationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        
        
    });
    return sharedManager;
}

-(id)init{
    self = [super init];
    if (self) {
        
        NSString *baseURLString = [[[NSBundle mainBundle] objectForInfoDictionaryKey:baseURLStringKey] copy];
        
        self.operationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:baseURLString]];
        
        self.operationManager.requestSerializer.HTTPShouldHandleCookies = YES;
    }
    
    return self;
}

//-(void)testLog:(NSString *)testLog
//       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//{
//    
//    [self.operationManager GET:@"/testLog" parameters: @{@"testLog" : testLog} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@", responseObject);
//        
//        if(success)
//            success(operation, responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if(failure)
//            failure(operation, error);
//        
//    }];
//}

-(void)createOccupancy:(NSDictionary *)occupancyDictionary
          onCompletion:(void (^)(id))completionBlock
{
    [self.operationManager POST:@"/occupancy/" parameters:occupancyDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(completionBlock)
            completionBlock(responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(completionBlock)
            completionBlock(nil);
    }];
}

-(void)getOccupancyOnCompletion:(void (^)(NSArray *occupancyArray))completionBlock
{
    [self.operationManager GET:@"/occupancy" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *responseArray = (NSArray *)responseObject;
        if(completionBlock)
            completionBlock(responseArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(completionBlock)
            completionBlock(nil);
        
    }];
    
//    [[WRHRoomManager sharedManager]getRoomsOnCompletion:^(NSArray *roomArray) {
//        
//        if(completionBlock)
//        {
//            WRHOccupancy *occupancy = [[WRHOccupancy alloc]init];
//            occupancy.name = @"James";
//            occupancy.room = [[WRHRoomManager sharedManager] getRoomForRoomId:@"17"];
//            completionBlock(@[occupancy]);
//        }
//    }];
//    
//    if(completionBlock)
//        completionBlock(@[@{@"name":@"James" , @"roomId" : @"17"}]);
    
}


@end
