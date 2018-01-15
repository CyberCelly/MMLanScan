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

@interface StateObject : NSObject {
    NSNumber *portNumber;
    TransportProtocol  protocol;
    NSString *serviceName;
}

@property (retain) NSNumber *portNumber;
@property (assign) TransportProtocol protocol;
@property (retain) NSString *serviceName;

@end
