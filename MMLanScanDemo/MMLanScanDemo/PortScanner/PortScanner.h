//
//  PortScanner.h
//  MMLanScanDemo
//
//  Created by Kulchytskyi Oleg on 1/11/18.
//  Copyright © 2018 Miksoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PortScanner : NSObject

+ (PortScanner *)scanPortsWithHostAddress:(NSString *)hostAddress;    // contains (struct sockaddr)

- (void)start;

@property (nonatomic, copy,   readonly ) NSString *hostAddress;

@end
