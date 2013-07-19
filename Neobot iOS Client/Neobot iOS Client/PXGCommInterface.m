//
//  PXGCommInterface.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 18/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGCommInterface.h"
#import "PXGInstructions.h"
#import "PXGDataSerializer.h"

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
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:[NSMutableData dataWithData:data]];
    switch (instruction)
    {
        //ROBOT
        case COORD:
        {
            uint16_t x = [serializer takeInt16];
            uint16_t y = [serializer takeInt16];
            uint16_t theta = [serializer takeInt16];
            uint8_t dir = [serializer takeInt8];
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                [robotDelegate didReceiveRobotPositionX:x Y:y angle:(double)theta/ANGLE_FACTOR direction:dir];
            
            break;
        }
        case OPPONENT:
        {
            uint16_t x = [serializer takeInt16];
            uint16_t y = [serializer takeInt16];
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                [robotDelegate didReceiveOpponentPositionX:x Y:y];
            
            break;
        }
        case IS_ARRIVED:
        {
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                [robotDelegate didReceiveArrivedToObjectiveStatus];
        }
        case IS_BLOCKED:
        {
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                [robotDelegate didReceiveBlockedStatus];
        }
        case LOG:
        {
            NSString* logText = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                [robotDelegate didReceiveLog:logText];
        }
            
            
        //SERVER
        case ANNOUNCEMENT:
        {
            NSString* message = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                [serverDelegate didReceiveServerAnnouncement:message];

        }
            
        //BOTH
        case AR:
        {
            uint8_t inst = [serializer takeInt8];
            BOOL result = YES;
            [serializer takeBool:&result];
            if (inst < 180)
            {
                for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                    [robotDelegate didReceiveNoticeOfReceiptForInstrction:inst withResult:result];
            }
            else
            {
                for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                    [serverDelegate didReceiveNetworkNoticeOfReceiptForInstruction:inst withResult:result];
            }
        }
        default:
            break;
    }
}

#pragma mark Send methods
- (void)sendPingToRobot
{
    [_protocol writeMessage:nil forInstruction:PING];
}

- (void)sendTeleportRobotInX:(int16_t)x  Y:(int16_t)y angle:(double)theta
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addInt16:x];
    [serializer addInt16:y];
    [serializer addInt16:(uint16_t)theta * ANGLE_FACTOR];
    
    [_protocol writeMessage:messageData forInstruction:SET_POS];
}

- (void)sendPingToServer
{
    [_protocol writeMessage:nil forInstruction:PING_SERVER];
}

- (void)connectToRobotOnPort:(NSString*)robotPort withAx12port:(NSString*)ax12Port inSimulationMode:(BOOL)simulation
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addBool:simulation];
    [serializer addString:robotPort];
    [serializer addString:ax12Port];
    
    [_protocol writeMessage:messageData forInstruction:CONNECT];
}

- (void)disconnectFromRobot
{
    [_protocol writeMessage:nil forInstruction:DISCONNECT];
}


@end
