//
//  PortScanner.m
//  MMLanScanDemo
//
//  Created by Kulchytskyi Oleg on 1/11/18.
//  Copyright © 2018 Miksoft. All rights reserved.
//

#import "PortScanner.h"
#import "PortInfo.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/time.h>

@implementation PortScanner {
    NSMutableDictionary *_services;
}

@synthesize hostAddress = _hostAddress;

- (id)initWithHostAddress:(NSString *) hostAddress {
    self = [super init];
    if (self != nil) {
        self->_hostAddress = [hostAddress copy];
        
        _services = [[NSMutableDictionary alloc] init];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        NSString *servicesPath = [[NSBundle mainBundle] pathForResource:@"services" ofType:@"list"];
        NSString *servicesContent = [NSString stringWithContentsOfFile:servicesPath encoding:NSUTF8StringEncoding error:nil];

        NSArray *servicesInfo = [servicesContent componentsSeparatedByString:@"\n"];
        NSEnumerator *serviceEnum = [servicesInfo objectEnumerator];

        NSString *service;
        while ((service = [serviceEnum nextObject]) && [service length] != 0) {
            NSArray *info = [service componentsSeparatedByString:@","];

            NSString *protocol = [info objectAtIndex:0];
            NSString *port = [info objectAtIndex:1];
            NSString *serviceName = [info objectAtIndex:2];

            if ([protocol compare:@"tcp"] == NSOrderedSame) {
                [_services setObject:serviceName forKey:[formatter numberFromString:port]];
            }
        }
    }
    return self;
}

+ (PortScanner *)scanPortsWithHostAddress:(NSString *)hostAddress {
    return [[PortScanner alloc] initWithHostAddress:hostAddress];
}

static BOOL ConnectSocketPort(const char *addr, int protocol, int port) {
    int err = 0;
    int sockfd = -1;
    fd_set fdset;
    struct timeval tv;
    int so_error = -1;
    socklen_t len = sizeof(so_error);
    
    sockfd = socket(AF_INET, protocol, IPPROTO_IP);
    if (sockfd < 0) {
        return NO;
    }
    
    fcntl(sockfd, F_SETFL, O_NONBLOCK);
    
    struct sockaddr_in addr_dest;
    
    memset(&addr_dest, 0, sizeof(struct sockaddr_in));
    
    addr_dest.sin_family = AF_INET;
    addr_dest.sin_addr.s_addr = inet_addr(addr);
    addr_dest.sin_port = htons(port);
    
    err = connect(sockfd, (const struct sockaddr *)&addr_dest, sizeof(struct sockaddr_in));

    FD_ZERO(&fdset);
    FD_SET(sockfd, &fdset);
    tv.tv_sec = 0;
    tv.tv_usec = 250 * 1000;
    
    if (select(sockfd + 1, NULL, &fdset, NULL, &tv) == 1) {
        getsockopt(sockfd, SOL_SOCKET, SO_ERROR, &so_error, &len);
    }
    
    close(sockfd);
    
    return !so_error;
}

//
// TODO:
//   1. Add callback for scanned port
//   2. Add ability to break port scan loop
//
- (void)start {
    assert(self.hostAddress != nil);
    
    NSArray *portOrder =  [[_services allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSEnumerator *servicesEnum = [portOrder objectEnumerator];

    NSNumber *port;

    while (port = [servicesEnum nextObject]) {
        if (ConnectSocketPort([self.hostAddress UTF8String], SOCK_STREAM, [port intValue])) {
            NSLog(@"%@", [_services objectForKey:port]);
        }
    }
}

@end
