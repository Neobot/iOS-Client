//
//  PXGCommInterface.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 18/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGCommInterface.h"
#import "PXGDataSerializer.h"
#import "PXGInstructions.h"

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

+ (PXGCommInterface*)sharedInstance
{
    static PXGCommInterface *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PXGCommInterface alloc] init];
    });
    return sharedInstance;
}


#pragma mark Delegate registration

- (void)registerConnectedViewDelegate:(id<PXGConnectedViewDelegate>)connectedViewDelegate
{
    [_connectedViewDelegates addObject:connectedViewDelegate];
    for (id<PXGConnectedViewDelegate> viewDelegate in _connectedViewDelegates)
        if ([viewDelegate respondsToSelector:@selector(connectionStatusChangedTo:)])
            [viewDelegate connectionStatusChangedTo:self.connectionStatus];
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
        if ([viewDelegate respondsToSelector:@selector(connectionStatusChangedTo:)])
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
    [[PXGCommInterface sharedInstance] askStrategies];
    [[PXGCommInterface sharedInstance] askSerialPorts];
    [[PXGCommInterface sharedInstance] askAutoStrategyInfo];
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
            int16_t x = [serializer takeInt16];
            int16_t y = [serializer takeInt16];
            int16_t theta = [serializer takeInt16];
            uint8_t dir = [serializer takeInt8];
            double angle = (double)theta/ANGLE_FACTOR;
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                 if ([robotDelegate respondsToSelector:@selector(didReceiveRobotPositionX:Y:angle:direction:)])
                     [robotDelegate didReceiveRobotPositionX:x Y:y angle:angle direction:dir];
            
            break;
        }
        case OBJECTIVE:
        {
            int16_t x = [serializer takeInt16];
            int16_t y = [serializer takeInt16];
            int16_t theta = [serializer takeInt16];
            double angle = (double)theta/ANGLE_FACTOR;
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                if ([robotDelegate respondsToSelector:@selector(didReceiveRobotPositionX:Y:angle:direction:)])
                    [robotDelegate didReceiveRobotObjectiveX:x Y:y angle:angle];
            
            break;
        }
        case AVOIDING_SENSORS:
        {
            NSMutableArray* values = [NSMutableArray array];
            while (![serializer atEnd])
            {
                uint8_t value = [serializer takeInt8];
                [values addObject:[NSNumber numberWithInt:value]];
            }
            
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                if ([robotDelegate respondsToSelector:@selector(didReceiveAvoidingSensorsValues:)])
                    [robotDelegate didReceiveAvoidingSensorsValues:values];
            
            break;
        }
        case OTHER_SENSORS:
        {
            NSMutableArray* values = [NSMutableArray array];
            while (![serializer atEnd])
            {
                uint8_t value = [serializer takeInt8];
                [values addObject:[NSNumber numberWithInt:value]];
            }
            
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                if ([robotDelegate respondsToSelector:@selector(didReceiveOtherSensorsValues:)])
                    [robotDelegate didReceiveOtherSensorsValues:values];
            
            break;
        }
        case OPPONENT:
        {
            uint16_t x = [serializer takeInt16];
            uint16_t y = [serializer takeInt16];
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                 if ([robotDelegate respondsToSelector:@selector(didReceiveOpponentPositionX:Y:)])
                     [robotDelegate didReceiveOpponentPositionX:x Y:y];
            
            break;
        }
        case IS_ARRIVED:
        {
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                 if ([robotDelegate respondsToSelector:@selector(didReceiveArrivedToObjectiveStatus)])
                     [robotDelegate didReceiveArrivedToObjectiveStatus];
            break;
        }
        case IS_BLOCKED:
        {
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                 if ([robotDelegate respondsToSelector:@selector(didReceiveBlockedStatus)])
                     [robotDelegate didReceiveBlockedStatus];
            break;
        }
        case LOG:
        {
            NSString* logText = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                if ([robotDelegate respondsToSelector:@selector(didReceiveLog:)])
                    [robotDelegate didReceiveLog:logText];
            break;
        }
        case PARAMETERS:
        {
            NSMutableArray* values = [NSMutableArray array];
            uint8_t nbValues = [serializer takeInt8];
            for(int i = 0; i < nbValues && ![serializer atEnd]; ++i)
            {
                float value = [serializer takeFloat];
                [values addObject:[NSNumber numberWithFloat:value]];
            }
            
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                if ([robotDelegate respondsToSelector:@selector(didReceiveParametersValues:)])
                    [robotDelegate didReceiveParametersValues:values];
            break;
        }
        case PARAMETER_NAMES:
        {
            NSString* completeStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSArray* parameterNamesArray = [completeStr componentsSeparatedByString:@";;"];
            for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
            {
                if ([robotDelegate respondsToSelector:@selector(didReceiveParameterNames:)])
                {
                    [robotDelegate didReceiveParameterNames:parameterNamesArray];
                }
            }
            break;
        }
            
            
        //SERVER
        case ANNOUNCEMENT:
        {
            NSString* message = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                if ([serverDelegate respondsToSelector:@selector(didReceiveServerAnnouncement:)])
                    [serverDelegate didReceiveServerAnnouncement:message];
            break;

        }
        case SERIAL_PORTS:
        {
            NSMutableArray* array = [NSMutableArray array];
            while (![serializer atEnd])
            {
                NSString* port = [serializer takeString];
                [array addObject:port];
            }
            for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                if ([serverDelegate respondsToSelector:@selector(didReceiveSerialPortsInfo:)])
                    [serverDelegate didReceiveSerialPortsInfo:array];

            break;
        }
        case STRATEGY_STATUS:
        {
            uint8_t stratNum = [serializer takeInt8];
            BOOL isRunning = NO;
            [serializer takeBool:&isRunning];
            for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                if ([serverDelegate respondsToSelector:@selector(didReceiveStatus:forStrategy:)])
                    [serverDelegate didReceiveStatus:isRunning forStrategy:stratNum];
            break;
        }
        case SEND_STRATEGIES:
        {
            NSString* completeStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSArray* strategiesArray = [completeStr componentsSeparatedByString:@";;"];
            for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                if ([serverDelegate respondsToSelector:@selector(didReceiveStrategyNames:)])
                    [serverDelegate didReceiveStrategyNames:strategiesArray];
            break;
        }
            
        case AX12_POSITIONS:
        {
            int nbAX12 = [serializer takeInt8];
            
            NSMutableArray* positions = [NSMutableArray array];
            NSMutableArray* ids = [NSMutableArray array];
            
            for(int i = 0; i < nbAX12 && ![serializer atEnd]; ++i)
            {
                int ax12ID = [serializer takeInt8];
                float position = [serializer takeFloat];
                
                [ids addObject:[NSNumber numberWithInt:ax12ID]];
                [positions addObject:[NSNumber numberWithFloat:position]];
            }
            
            for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                if ([serverDelegate respondsToSelector:@selector(didReceivePositions:forAx12:)])
                    [serverDelegate didReceivePositions:positions forAx12:ids];
            break;
        }
        case AX12_MVT_FILE:
        {
            for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                if ([serverDelegate respondsToSelector:@selector(didReceiveAx12MovementsFileData:)])
                    [serverDelegate didReceiveAx12MovementsFileData:data];
            break;

        }
        case AUTO_STRATEGY_INFO:
        {
            int stratNum = [serializer takeInt8];
            NSString* robotPort = [serializer takeString];
            NSString* ax12Port = [serializer takeString];
            
            BOOL enabled, simu, mirror;
            
            [serializer takeBool:&enabled and:&simu and:&mirror];
            
            for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                if ([serverDelegate respondsToSelector:@selector(didReceiveAutoStrategyInfoForStrategy:withRobotPort:withax12Port:inSimulationMode:inMirrorMode:isEnabled:)])
                    [serverDelegate didReceiveAutoStrategyInfoForStrategy:stratNum withRobotPort:robotPort withax12Port:ax12Port inSimulationMode:simu inMirrorMode:mirror isEnabled:enabled];
            
            break;
        }
            
        //BOTH
        case AR:
        {
            uint8_t inst = [serializer takeInt8];
            BOOL result = YES;
            [serializer takeBool:&result];
            
            if (inst == CONNECT && result)
            {
                [self changeConnectionStatusTo:Controlled];
                [self askStrategyStatus];
                [self askParameters];
            }
            else if (inst == DISCONNECT && result)
                [self changeConnectionStatusTo:Connected];

            
            if (inst < 180 || inst > 250)
            {
                for (id<PXGRobotInterfaceDelegate> robotDelegate in _robotInterfaceDelegates)
                    if ([robotDelegate respondsToSelector:@selector(didReceiveNoticeOfReceiptForInstruction:withResult:)])
                        [robotDelegate didReceiveNoticeOfReceiptForInstruction:inst withResult:result];
            }
            else
            {
                for (id<PXGServerInterfaceDelegate> serverDelegate in _serverInterfaceDelegates)
                    if ([serverDelegate respondsToSelector:@selector(didReceiveNetworkNoticeOfReceiptForInstruction:withResult:)])
                        [serverDelegate didReceiveNetworkNoticeOfReceiptForInstruction:inst withResult:result];
            }
            break;
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
    [serializer addInt16:(uint16_t)(theta * ANGLE_FACTOR)];
    
    [_protocol writeMessage:messageData forInstruction:SET_POS];
}

- (void)sendFlush
{
    [_protocol writeMessage:nil forInstruction:FLUSH];
}

- (void)sendRobotInX:(int16_t)x  Y:(int16_t)y angle:(double)theta withTrajectoryType:(PXGTrajectoryType)type withAsservType:(PXGAsservType)asservType withSpeed:(uint8_t)speed isStopPoint:(BOOL)isStopPoint
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addInt16:x];
    [serializer addInt16:y];
    [serializer addInt16:(uint16_t)(theta * ANGLE_FACTOR)];
    [serializer addInt8:type];
    [serializer addInt8:asservType];
    [serializer addInt8:speed];
    [serializer addBool:isStopPoint];
    
    [_protocol writeMessage:messageData forInstruction:DEST_ADD];
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

- (void)askSerialPorts
{
    [_protocol writeMessage:nil forInstruction:ASK_SERIAL_PORTS];
}

- (void)askStrategies
{
    [_protocol writeMessage:nil forInstruction:ASK_STRATEGIES];
}

- (void)askStrategyStatus;
{
    [_protocol writeMessage:nil forInstruction:ASK_STRATEGY_STATUS];
}

- (void)startStrategy:(int)startegyNum withMirrorMode:(BOOL)mirrorMode
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addInt8:startegyNum];
    [serializer addBool:mirrorMode];
    
    [_protocol writeMessage:messageData forInstruction:START_STRATEGY];
}

- (void)stopStrategy
{
    [_protocol writeMessage:nil forInstruction:STOP_STRATEGY];
}

- (void)moveAX12:(int)nbOfAX12 of:(struct Ax12Info*)ax12InfoArray atSmoothedMaxSpeed:(float)maxSpeed
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addFloat:maxSpeed];
    [serializer addInt8:nbOfAX12];
    for(int i = 0; i < nbOfAX12; ++i)
    {
        struct Ax12Info info = ax12InfoArray[i];
        [serializer addInt8:info.id];
        [serializer addFloat:info.angle];
        [serializer addFloat:info.speed];
        [serializer addFloat:info.torque];
    }
    
    [_protocol writeMessage:messageData forInstruction:MOVE_AX12];
}

- (void)moveAX12:(int)nbOfAX12 of:(struct Ax12Info*)ax12InfoArray
{
    [self moveAX12:nbOfAX12 of:ax12InfoArray atSmoothedMaxSpeed:-1];
}

- (void)askPositionsForAX12Ids:(NSArray*)ax12IDList  recursively:(BOOL)recursively
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addInt8:[ax12IDList count]];
    for (NSNumber* num in ax12IDList)
    {
        [serializer addInt8:[num intValue]];
    }
    
    [serializer addBool:recursively];

    [_protocol writeMessage:messageData forInstruction:ASK_AX12_POSITIONS];
}

- (void)setAX12Ids:(NSArray*)ax12IDList lockedInfo:(NSArray*)lockedInfo
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addInt8:[ax12IDList count]];
    
    int i = 0;
    for (NSNumber* num in ax12IDList)
    {
        BOOL locked = [[lockedInfo objectAtIndex:i] boolValue];
        
        [serializer addInt8:[num intValue]];
        [serializer addBool:locked];
        
        ++i;
    }
    
    [_protocol writeMessage:messageData forInstruction:LOCK_AX12];
}

- (void)askAX12Movements
{
    [_protocol writeMessage:nil forInstruction:ASK_AX12_MVT_FILE];
}

- (void)setAX12MovementFile:(NSData*)data
{
    [_protocol writeMessage:data forInstruction:SET_AX12_MVT_FILE];
}

- (void)runAX12Movement:(NSString*)movementName fromGroup:(NSString*)groupName withSpeedLimit:(float)speedLimit
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addString:groupName];
    [serializer addString:movementName];
    [serializer addFloat:speedLimit];
    
    [_protocol writeMessage:messageData forInstruction:RUN_AX12_MVT];
}

- (void)runAX12Movement:(NSString*)movementName fromGroup:(NSString*)groupName withSpeedLimit:(float)speedLimit toPositionIndex:(int)lastPositionIndex
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addString:groupName];
    [serializer addString:movementName];
    [serializer addFloat:speedLimit];
    [serializer addInt8:(int8_t)lastPositionIndex];
    
    [_protocol writeMessage:messageData forInstruction:RUN_AX12_MVT];
}

- (void)askAutoStrategyInfo
{
    [_protocol writeMessage:nil forInstruction:ASK_AUTO_STRATEGY_INFO];
}

- (void)setAutoStrategyWithStrategy:(int)strategyNum withRobotPort:(NSString*)robotPort withAx12Port:(NSString*)ax12port inSimulationMode:(BOOL)simulation inMirrorMode:(BOOL)mirrorMode isEnabled:(BOOL)enabled
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addInt8:strategyNum];
    [serializer addString:robotPort];
    [serializer addString:ax12port];
    [serializer addBool:enabled and:simulation and:mirrorMode];
    
    [_protocol writeMessage:messageData forInstruction:SET_AUTO_STRATEGY];
}

- (void)askParameters
{
    [_protocol writeMessage:nil forInstruction:ASK_PARAMETERS];
}

- (void)sendParameters:(NSArray*)parameters
{
    NSMutableData* messageData = [NSMutableData data];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:messageData];
    
    [serializer addInt8:parameters.count];
    for (NSNumber* num in parameters)
    {
        float value = [num floatValue];
        [serializer addFloat:value];
    }
    
    [_protocol writeMessage:messageData forInstruction:SET_PARAMETERS];
}

@end
