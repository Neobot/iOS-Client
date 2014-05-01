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
    Controlled
};

typedef NS_ENUM(NSInteger, PXGAsservType)
{
    TURN_THEN_MOVE = 0,
    TURN_AND_MOVE = 1,
    TURN_ONLY = 2,
    MOVE_ONLY = 3
};

typedef NS_ENUM(NSInteger, PXGTrajectoryType)
{
    NONE = 0,
    AVANT_XY = 1,
    ARRIERE_XY = 2,
    TOURNE_VERS_XY = 3,
    TOURNE_VERS_XY_AR = 4,
    TOURNE_RADIAN = 5,
    AVANCE_MM = 6,  //X
    ROTATE_TO_ABSOLUTE_ANGLE = 7,
    CIRC_AVANT = 8,
    CIRC_AR = 9,
    BEZIER_AV = 10,
    BEZIER_AR = 11,
    RECALAGE = 12,
    AUTO = 13
};

typedef NS_ENUM(NSInteger, PXGRobotEventType)
{
    EventIsArrived = 0,
    EventIsBlocked = 1
};

typedef NS_ENUM(NSInteger, PXGSensorType)
{
    SharpSensor = 0,
    MicroswitchSensor = 1,
    ColorSensor = 2
};

typedef NS_ENUM(NSInteger, PXGSharpState)
{
    SharpNothingDetected,
    SharpObjectDetected,
    SharpObjectVeryClose,
};

typedef NS_ENUM(NSInteger, PXGMicroswicthState)
{
    MicroswicthOn,
    MicroswicthOff
};

typedef NS_ENUM(NSInteger, PXGColorState)
{
    ColorUnknown,
    ColorRed,
    ColorGreen,
    ColorBlue,
    ColorYellow,
    ColorWhite,
    ColorBlack
};

struct Ax12Info
{
    uint8_t id;
    float angle;
    float speed;
    float torque;
};

#pragma mark Robot delegate
@protocol PXGRobotInterfaceDelegate <NSObject>
@optional
- (void)didReceiveRobotPositionX:(int16_t)x  Y:(int16_t)y angle:(double)theta direction:(uint8_t)direction;
- (void)didReceiveRobotObjectiveX:(int16_t)x Y:(int16_t)y angle:(double)theta;
- (void)didReceiveAvoidingSensorsValues:(NSArray*)values;
- (void)didReceiveRobotEvent:(PXGRobotEventType)event;
- (void)didReceiveSensorEventForType:(PXGSensorType)sensorType withId:(int)sensorId andValue:(int)sensorValue;
- (BOOL)didReceiveInitDone;
- (BOOL)didReceiveStartSignalInMirrorMode:(BOOL)mirrored;
- (BOOL)didReceivePing;
- (void)didReceiveNoticeOfReceiptForInstruction:(uint8_t)instruction withResult:(BOOL)result;
- (void)didReceiveOpponentPositionX:(int16_t)x  Y:(int16_t)y;
- (BOOL)shouldRestartStrategy;
- (void)shouldQuit;
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
- (void)didReceivePositions:(NSArray*)positions withLoads:(NSArray*)loads forAx12:(NSArray*)ax12Ids;
- (void)didReceiveAx12MovementsFileData:(NSData*)data;
@end

#pragma mark Connected view delegate
@protocol PXGConnectedViewDelegate <NSObject>
@optional
- (void) connectionStatusChangedTo:(PXGConnectionStatus)status;
@end


@interface PXGCommInterface : NSObject <PXGProtocolDelegate>

- (id) init;
+ (PXGCommInterface*)sharedInstance;

#pragma mark Properties
@property (strong, nonatomic) PXGCommProtocol* protocol;
@property PXGConnectionStatus connectionStatus;

#pragma mark Delegate registration
- (void)registerConnectedViewDelegate:(id<PXGConnectedViewDelegate>)connectedViewDelegate;
- (void)unregisterConnectedViewDelegate:(id<PXGConnectedViewDelegate>)connectedViewDelegate;

- (void)registerRobotInterfaceDelegate:(id<PXGRobotInterfaceDelegate>)robotInterfaceDelegate;
- (void)unregisterRobotInterfaceDelegate:(id<PXGRobotInterfaceDelegate>)robotInterfaceDelegate;

- (void)registerServerInterfaceDelegate:(id<PXGServerInterfaceDelegate>)serverInterfaceDelegate;
- (void)unregisterServerInterfaceDelegate:(id<PXGServerInterfaceDelegate>)serverInterfaceDelegate;

#pragma mark Connection management
- (void)changeConnectionStatusTo:(PXGConnectionStatus)status;

- (BOOL)connectToServer:(NSString *)host onPort:(UInt16)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;
- (void)disconnectFromServer;

#pragma mark Send to robot instructions
- (void)sendPingToRobot;
- (void)sendTeleportRobotInX:(int16_t)x  Y:(int16_t)y angle:(double)theta;
- (void)sendFlush;
- (void)sendRobotInX:(int16_t)x  Y:(int16_t)y angle:(double)theta withTrajectoryType:(PXGTrajectoryType)type withAsservType:(PXGAsservType)type withSpeed:(uint8_t)speed isStopPoint:(BOOL)isStopPoint;

#pragma mark Send to server instructions
- (void)sendPingToServer;
- (void)connectToRobotOnPort:(NSString*)robotPort withAx12port:(NSString*)ax12Port inSimulationMode:(BOOL)simulation;
- (void)disconnectFromRobot;
- (void)startStrategy:(int)startegyNum withMirrorMode:(BOOL)mirrorMode;
- (void)stopStrategy;

- (void)askStrategyStatus;
- (void)askSerialPorts;
- (void)askStrategies;

- (void)moveAX12:(int)nbOfAX12 of:(struct Ax12Info*)ax12InfoArray atSmoothedMaxSpeed:(float)maxSpeed;
- (void)moveAX12:(int)nbOfAX12 of:(struct Ax12Info*)ax12InfoArray;
- (void)askPositionsForAX12Ids:(NSArray*)ax12IDList recursively:(BOOL)recursively;
- (void)setAX12Ids:(NSArray*)ax12IDList lockedInfo:(NSArray*)lockedInfo;

- (void)askAX12Movements;
- (void)setAX12MovementFile:(NSData*)data;
- (void)runAX12Movement:(NSString*)movementName fromGroup:(NSString*)groupName withSpeedLimit:(float)speedLimit;
- (void)runAX12Movement:(NSString*)movementName fromGroup:(NSString*)groupName withSpeedLimit:(float)speedLimit toPositionIndex:(int)lastPositionIndex;

- (void)askAutoStrategyInfo;
- (void)setAutoStrategyWithStrategy:(int)strategyNum withRobotPort:(NSString*)robotPort withAx12Port:(NSString*)ax12port inSimulationMode:(BOOL)simulation inMirrorMode:(BOOL)mirrorMode isEnabled:(BOOL)enabled;

- (void)askParameters;
- (void)sendParameters:(NSArray*)parameters;

@end
