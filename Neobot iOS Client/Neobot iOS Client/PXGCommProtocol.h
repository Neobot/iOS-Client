//
//  PXGCommProtocol.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"


#pragma mark Protocol
@protocol PXGProtocolDelegate <NSObject>

@optional
- (void) messageReceived:(int)instruction withData:(NSData*)data;
- (void) protocolConnected;
- (void) protocolDisconnectedWithError:(NSError *)error;

@end

#pragma mark Interface
@interface PXGCommProtocol : NSObject

- (id)init;

- (void) setDelegate:(id<PXGProtocolDelegate>)delegate;
- (void) writeMessage:(NSData*)data forInstruction:(uint8_t) instruction;

- (BOOL) connect:(NSString *)host onPort:(UInt16)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;
- (void) disconnect;

@property (strong, nonatomic) GCDAsyncSocket *socket;

@end