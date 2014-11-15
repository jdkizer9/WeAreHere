//
//  WRHSampler.m
//  WeAreHere
//
//  Created by James Kizer on 11/14/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "WRHSampler.h"

@interface WRHSampler()

@property (strong, nonatomic) NSNumber *remainingSamples;
@property (nonatomic) NSTimeInterval samplingInterval;
@property (strong, nonatomic) SamplingBlockType samplingBlock;
@property (strong, nonatomic) CompletionBlockType completionBlock;
@property (strong, nonatomic) CancelBlockType cancelBlock;
@property (strong, nonatomic) NSTimer *samplingTimer;
@property (strong, nonatomic) NSMutableArray *samplingArray;

@end

@implementation WRHSampler

-(NSMutableArray *)samplingArray
{
    if(!_samplingArray) _samplingArray = [[NSMutableArray alloc]init];
    return _samplingArray;
}

-(id)initWithNumberOfSample:(NSNumber*)numberOfSamples
           samplingInterval:(NSTimeInterval)samplingInterval
              samplingBlock:(SamplingBlockType)samplingBlock
            completionBlock:(CompletionBlockType)completionBlock
                cancelBlock:(CancelBlockType)cancelBlock
{
    self = [super init];
    if (self)
    {
        if(!samplingBlock)
            return nil;
        _remainingSamples = numberOfSamples;
        _samplingInterval = samplingInterval;
        _samplingBlock = samplingBlock;
        _completionBlock = completionBlock;
        _cancelBlock = cancelBlock;
    }
    return self;
}

-(void)decrementeRemainingSamples
{
    self.remainingSamples = [NSNumber numberWithInteger:[self.remainingSamples integerValue]-1];
}

-(void)startSampling
{
    self.status = WRHSamplerStatusInProgress;
    self.samplingTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(timerExpiration:) userInfo:nil repeats:NO];
}

-(void)cancelSampling:(NSString *)reason
{
    [self.samplingTimer invalidate];
    self.status = WRHSamplerStatusCanceled;
    if(self.cancelBlock)
        self.cancelBlock(reason);
}

-(void)timerExpiration:(NSTimer *)timer
{
    if(self.samplingTimer.isValid)
    {
        //execute sampling block passed by user
        //note that callback is being passed.
        //User must invoke callback with sample
        self.samplingBlock(^(id sample){
            //this block is executed after the sample has been taken
            
            [self.samplingArray addObject:sample];
            
            if(self.status == WRHSamplerStatusInProgress)
            {
                
                if([self.remainingSamples isEqualToValue:@0])
                {
                    //complete timer
                    self.status = WRHSamplerStatusCompleted;
                    if(self.completionBlock)
                        self.completionBlock([NSArray arrayWithArray:self.samplingArray]);
                }
                else
                {
                    //program another timer
                    [self decrementeRemainingSamples];
                    self.samplingTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.samplingInterval];
                }
            }
        });
    }
    else
        assert(0);
}

@end
