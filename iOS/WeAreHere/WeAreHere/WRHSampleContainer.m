//
//  WRHSampleContainer.m
//  WeAreHere
//
//  Created by James Kizer on 11/15/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "WRHSampleContainer.h"
@interface WRHSampleContainer()

@property (nonatomic) NSInteger numberOfSamples;
@property (strong, nonatomic) CompletionBlockType completionBlock;
@property (strong, nonatomic) NSMutableArray *samplingArray;

@end

@implementation WRHSampleContainer

-(NSMutableArray *)samplingArray
{
    if(!_samplingArray) _samplingArray = [[NSMutableArray alloc]init];
    return _samplingArray;
}

-(id)initWithNumberOfSamples:(NSInteger) numberOfSamples
            completionBlock:(CompletionBlockType)completionBlock
{
    self = [super init];
    if (self)
    {
        if(numberOfSamples == 0)
            _status = WRHSampleContainerStatusCompleted;
        else
        {
            if(!completionBlock)
                return nil;
            _numberOfSamples = numberOfSamples;
            _completionBlock = completionBlock;
            _status = WRHSampleContainerStatusInProgress;
        }
    }
    return self;
    
}

-(void)addSample:(id)sample
{
    if(self.status == WRHSampleContainerStatusInProgress)
    {
        [self.samplingArray addObject:sample];
        if([self.samplingArray count] == self.numberOfSamples)
        {
            self.status = WRHSampleContainerStatusCompleted;
            self.completionBlock([NSArray arrayWithArray:self.samplingArray]);
        }
    }
    
}

-(void)clearSamples
{
    self.samplingArray = nil;
}
  
  
@end
