//
//  PXGCommInterface.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 18/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXGCommProtocol.h"

typedef NS_ENUM(NSInteger, PXGConnectionStatus)
{
    Lookup,
    Disconnected,
    Connected,
    Controled
};

@protocol PXGRobotInterfaceDelegate <NSObject>

@optional

@end


@protocol PXGServerInterfaceDelegate <NSObject>

@optional

@end


@protocol PXGConnectedViewDelegate <NSObject>

@optional
- (void) connectionStatusChangedTo:(PXGConnectionStatus)status;

@end


@interface PXGCommInterface : NSObject <PXGProtocolDelegate>

- (id) init;

- (void)registerConnectedViewDelegate:(id<PXGConnectedViewDelegate>)connectedViewDelegate;
- (void)unregisterConnectedViewDelegate:(id<PXGConnectedViewDelegate>)connectedViewDelegate;

- (void)registerRobotInterfaceDelegate:(id<PXGRobotInterfaceDelegate>)robotInterfaceDelegate;
- (void)unregisterRobotInterfaceDelegate:(id<PXGRobotInterfaceDelegate>)robotInterfaceDelegate;

- (void)registerServerInterfaceDelegate:(id<PXGServerInterfaceDelegate>)serverInterfaceDelegate;
- (void)unregisterServerInterfaceDelegate:(id<PXGServerInterfaceDelegate>)serverInterfaceDelegate;

- (void) changeConnectionStatusTo:(PXGConnectionStatus)status;

- (BOOL) connectToServer:(NSString *)host onPort:(UInt16)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;
- (void) disconnectFromServer;


@property (strong, nonatomic) PXGCommProtocol* protocol;
@property PXGConnectionStatus connectionStatus;

@end
