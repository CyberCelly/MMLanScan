//
//  PortInfo.h
//  MMLanScanDemo
//
//  Created by Kulchytskyi Oleg on 1/11/18.
//  Copyright © 2018 Miksoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _TransportProtocol {
    ProtoTCP = 0x0001,
    ProtoUDP = 0x0002
} TransportProtocol;

@interface PortInfo : NSObject {
    NSNumber *portNumber;
    NSString *serviceName;
    TransportProtocol  protocol;
    BOOL isOpen;
}

@property (retain) NSNumber *portNumber;
@property (retain) NSString *serviceName;
@property (assign) TransportProtocol protocol;
@property (assign) BOOL isOpen;

@end
