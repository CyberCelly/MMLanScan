//
//  PortScanner.h
//  MMLanScanDemo
//
//  Created by Kulchytskyi Oleg on 1/11/18.
//  Copyright © 2018 Miksoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PortInfo.h"

@interface PortScanner : NSObject

+ (PortScanner *_Nullable)scanPortsWithHostAddress:(NSString * _Nonnull)hostAddress
    andPortHandler:(nullable void (^)(NSError  * _Nullable error, PortInfo * _Nonnull portInfo))handler;

- (void)start;
- (void)stop;

@property (nonatomic, copy, readonly) NSString * _Nonnull hostAddress;
@property (nonatomic, copy, readonly) void (^ _Nullable handler)(NSError * _Nullable error, PortInfo * _Nonnull portInfo);

@end
