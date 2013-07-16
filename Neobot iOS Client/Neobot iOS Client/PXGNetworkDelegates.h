//
//  PXGNetworkDelegates.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PXGConnectionStatus)
{
    Lookup,
    Disconnected,
    Connected,
    Controled
};

@protocol PXGConnectedControllerProtocol <NSObject>

@optional
- (void) connectionStatusChanged:(PXGConnectionStatus)status;

@end

@protocol PXGProtocolDelegate <NSObject>

@optional
- (BOOL) messageReceived:(int)instruction withData:(NSData*)data;

@end