//
//  PortScanOperation.m
//  MMLanScanDemo
//
//  Created by Kulchytskyi Oleg on 1/11/18.
//  Copyright © 2018 Miksoft. All rights reserved.
//

#import "PortScanOperation.h"

@interface PortScanOperation ()
@property (nonatomic,strong) NSString *ipStr;
@property (nonatomic, copy) void (^result)(NSError  * _Nullable error, NSArray  * _Nonnull scanResults);
@property(nonatomic,strong)NSMutableArray *scanResults;
@end

@interface PortScanOperation()
- (void)finish;
@end

@implementation PortScanOperation {

    NSError *errorMessage;
}

-(instancetype)initWithIPToScan:(NSString*)ip andCompletionHandler:(nullable void (^)(NSError  * _Nullable error, NSArray  * _Nonnull scanResults))result;{
    
    self = [super init];
    
    if (self) {
        _ipStr = ip;
        _result = result;
        _isExecuting = NO;
        _isFinished = NO;
        _scanResults = [[NSMutableArray alloc] init];
    }
    
    return self;
};

-(void)start {
    
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self startScan];
}

-(void)finishScan {
    
    if (self.isCancelled) {
        [self finish];
        return;
    }
    
    if (self.result) {
        self.result(errorMessage, self.scanResults);
    }
    
    [self finish];
}

-(void)finish {
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
}

- (BOOL)isExecuting {
    return _isExecuting;
}

- (BOOL)isFinished {
    return _isFinished;
}

-(void)startScan {
    
    
    [self finishScan];
}

@end
