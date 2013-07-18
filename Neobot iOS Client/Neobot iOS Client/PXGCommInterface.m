//
//  PXGCommInterface.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 18/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGCommInterface.h"

@implementation PXGCommInterface
{
    NSMutableArray* _connectedViewDelegates;
    NSMutableArray* _robotInterfaceDelegates;
    NSMutableArray* _serverInterfaceDelegates;
}

- (id) init
{
    if ((self = [super init]))
	{
		self.protocol = [[PXGCommProtocol alloc] init];
        [self.protocol setDelegate:self];
        
        _connectedViewDelegates = [[NSMutableArray alloc] init];
        _robotInterfaceDelegates = [[NSMutableArray alloc] init];
        _serverInterfaceDelegates = [[NSMutableArray alloc] init];
        
        self.connectionStatus = Disconnected;
	}
    
    return self;
}


#pragma mark Delegate registration

- (void)registerConnectedViewDelegate:(id<PXGConnectedViewDelegate>)connectedViewDelegate
{
    [_connectedViewDelegates addObject:connectedViewDelegate];
}

- (void)unregisterConnectedViewDelegate:(id<PXGConnectedViewDelegate>)connectedViewDelegate
{
    [_connectedViewDelegates removeObject:connectedViewDelegate];
}

- (void)registerRobotInterfaceDelegate:(id<PXGRobotInterfaceDelegate>)robotInterfaceDelegate
{
    [_robotInterfaceDelegates addObject:robotInterfaceDelegate];
}

- (void)unregisterRobotInterfaceDelegate:(id<PXGRobotInterfaceDelegate>)robotInterfaceDelegate
{
    [_robotInterfaceDelegates removeObject:robotInterfaceDelegate];
}

- (void)registerServerInterfaceDelegate:(id<PXGServerInterfaceDelegate>)serverInterfaceDelegate
{
    [_serverInterfaceDelegates addObject:serverInterfaceDelegate];
}

- (void)unregisterServerInterfaceDelegate:(id<PXGServerInterfaceDelegate>)serverInterfaceDelegate
{
    [_serverInterfaceDelegates removeObject:serverInterfaceDelegate];
}

#pragma mark Connection management

- (void) changeConnectionStatusTo:(PXGConnectionStatus)status
{
    self.connectionStatus = status;
    for (id<PXGConnectedViewDelegate> viewDelegate in _connectedViewDelegates)
        [viewDelegate connectionStatusChangedTo:status];
}

- (BOOL) connectToServer:(NSString *)host onPort:(UInt16)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr
{
    [self changeConnectionStatusTo:Lookup];
    return [self.protocol connect:host onPort:port withTimeout:timeout error:errPtr];
}

- (void) disconnectFromServer
{
    [self.protocol disconnect];
}

#pragma mark Protocol delegate methods

- (void) protocolConnected
{
    [self changeConnectionStatusTo:Connected];
}

- (void) protocolDisconnectedWithError:(NSError *)error
{
    [self changeConnectionStatusTo:Disconnected];
}

- (void) messageReceived:(int)instruction withData:(NSData*)data
{
    
}



@end
