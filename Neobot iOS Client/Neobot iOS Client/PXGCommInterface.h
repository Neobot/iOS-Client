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

#pragma mark Robot delegate
@protocol PXGRobotInterfaceDelegate <NSObject>
@optional
- (void)didReceiveRobotPositionX:(int16_t)x  Y:(int16_t)y angle:(double)theta direction:(uint8_t)direction;
- (void)didReceiveRobotObjectiveX:(int16_t)x Y:(int16_t)y angle:(double)theta;
- (void)didReceiveAvoidingSensorsValues:(NSArray*)values;
- (void)didReceiveMicroswitchsValues:(NSArray*)values;
- (void)didReceiveOtherSensorsValues:(NSArray*)values;
- (BOOL)didReceiveInitDone;
- (BOOL)didReceiveStartSignalInMirrorMode:(BOOL)mirrored;
- (BOOL)didReceivePing;
- (void)didReceiveNoticeOfReceiptForInstrction:(uint8_t)instruction withResult:(BOOL)result;
- (void)didReceiveOpponentPositionX:(int16_t)x  Y:(int16_t)y;
- (BOOL)shouldRestartStrategy;
- (void)shouldQuit;
- (void)didReceiveArrivedToObjectiveStatus;
- (void)didReceiveBlockedStatus;
- (void)didReceiveLog:(NSString*) text;
- (void)didReceiveParametersValues:(NSArray*)values;
- (void)didReceiveParameterNames:(NSArray*)names;
@end

#pragma mark Server delegate
@protocol PXGServerInterfaceDelegate <NSObject>
@optional
- (void)didReceiveServerAnnouncement:(NSString*) message;
- (void)didReceiveNetworkNoticeOfReceiptForInstruction:(uint8_t)instruction withResult:(BOOL)result;
- (void)didReceiveStrategyNames:(NSArray*)names;
- (void)didReceiveFileNames:(NSArray*)filenames forStrategy:(int)strategyNum;
- (void)didReceiveFileData:(NSData*)fileData forFile:(NSString*)filename forStrategy:(int)strategyNum;
- (void)didReceiveStatus:(BOOL)isRunning forStrategy:(int)strategyNum;
- (void)didReceiveAutoStrategyInfoForStrategy:(int)strategyNum withRobotPort:(NSString*)robotPort withax12Port:(NSString*)ax12port inSimulationMode:(BOOL)simulation inMirrorMode:(BOOL)mirrorMode isEnabled:(BOOL)enabled;
- (void)didReceiveSerialPortsInfo:(NSArray*)serialports;
- (void)didReceivePositions:(NSArray*)positions forAx12:(NSArray*)ax12Ids;
- (void)didReceiveAx12MovementsFileData:(NSData*)data;
@end

#pragma mark Connected view delegate
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

- (void)changeConnectionStatusTo:(PXGConnectionStatus)status;

- (BOOL)connectToServer:(NSString *)host onPort:(UInt16)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;
- (void)disconnectFromServer;

- (void)sendPingToRobot;
- (void)sendTeleportRobotInX:(int16_t)x  Y:(int16_t)y angle:(double)theta;

- (void)sendPingToServer;


@property (strong, nonatomic) PXGCommProtocol* protocol;
@property PXGConnectionStatus connectionStatus;

@end
