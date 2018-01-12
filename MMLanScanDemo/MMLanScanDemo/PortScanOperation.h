//
//  PortScanOperation.h
//  MMLanScanDemo
//
//  Created by Kulchytskyi Oleg on 1/11/18.
//  Copyright © 2018 Miksoft. All rights reserved.
//

#import "SimplePing.h"

@interface PortScanOperation : NSOperation {
    BOOL _isFinished;
    BOOL _isExecuting;
}

-(nullable instancetype)initWithIPToScan:(nonnull NSString*)ip andCompletionHandler:(nullable void (^)(NSError  * _Nullable error, NSArray  * _Nonnull scanResults))result;

@end
