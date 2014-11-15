//
//  WRHSampleContainer.h
//  WeAreHere
//
//  Created by James Kizer on 11/15/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WRHSampleContainerStatus) {
    WRHSampleContainerStatusInProgress,
    WRHSampleContainerStatusCompleted
};

typedef void (^CompletionBlockType)(NSArray *sampleArray);

@interface WRHSampleContainer : NSObject

-(id)initWithNumberOfSamples:(NSInteger)numberOfSamples
            completionBlock:(CompletionBlockType)completionBlock;

-(void)addSample:(id)sample;
-(void)clearSamples;

@property (nonatomic) WRHSampleContainerStatus status;

@end
