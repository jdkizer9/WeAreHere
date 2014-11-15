//
//  WRHSampler.h
//  WeAreHere
//
//  Created by James Kizer on 11/14/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WRHSamplerStatus) {
    WRHSamplerStatusInitialized,
    WRHSamplerStatusInProgress,
    WRHSamplerStatusCompleted,
    WRHSamplerStatusCanceled
};

@interface WRHSampler : NSObject

typedef void (^SamplingBlockCallbackType)(id sample);
typedef void (^SamplingBlockType)(SamplingBlockCallbackType callback);
typedef void (^CompletionBlockType)(NSArray *sampleArray);
typedef void (^CancelBlockType)(NSString *reason);

-(id)initWithNumberOfSample:(NSNumber*)numberOfSamples
             samplingInterval:(NSTimeInterval)samplingInterval
           samplingBlock:(SamplingBlockType)samplingBlock
            completionBlock:(CompletionBlockType)completionBlock
                cancelBlock:(CancelBlockType)cancelBlock;

-(void)startSampling;
-(void)cancelSampling:(NSString *)reason;

@property (nonatomic) WRHSamplerStatus status;

@end
