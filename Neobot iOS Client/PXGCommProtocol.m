//
//  PXGCommProtocol.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGCommProtocol.h"
#import "PXGDataSerializer.h"

typedef NS_ENUM(NSInteger, PXGMessageTag)
{
    HEADER,
    SIZE,
    INSTRUCTION,
    DATA,
    CHECKSUM
};

@implementation PXGCommProtocol
{
    id<PXGProtocolDelegate> _delegate;
    uint32_t _currentMessageLength;
    int _currentMessageInstruction;
    uint8_t _currentChecksum;
    NSData* _currentMessageData;
}

- (id) init
{
    if ((self = [super init]))
	{
		self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _currentMessageLength = 0;
        _currentMessageInstruction = 0;
        
        [self readDataWithTag:HEADER];
	}
    
    return self;
}

- (void) setDelegate: (id<PXGProtocolDelegate>)delegate
{
    _delegate = delegate;
}

- (BOOL) connect:(NSString *)host onPort:(UInt16)port withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr
{
    return [self.socket connectToHost:host onPort:port error:errPtr];
}

- (void) disconnect
{
    [self.socket disconnect];
}

- (uint8_t) calculateChecksum:(NSData*) data
{
    int checksum = 0;
    
    int dataSize = [data length];
    void* bytes = nil;
    [data getBytes:bytes];
    
    for(int i = 0; i < dataSize; ++i)
    {
        uint8_t byte = *((uint8_t*)(bytes + i));
        checksum += byte;
    }
    
    uint8_t trucatedChecksum = checksum;
    return 255 - trucatedChecksum;
}

- (void) writeMessage:(NSData*)data forInstruction:(uint8_t) instruction
{
    NSMutableData* message = [[NSMutableData alloc] init];
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:message];

    //header
    [serializer addInt8:255];
    [serializer addInt8:255];
    
    //length
    int messageLength = [data length] + 1;
    [serializer addInt32:messageLength];
    
    //instruction
    [serializer addInt8:instruction];
    
    //data
    [serializer addData:data];
    
    //checksum
    NSMutableData* checksumData = [[NSMutableData alloc] initWithBytes:&messageLength length:1];
    [checksumData appendBytes:&instruction length:1];
    [checksumData appendData:data];
    uint8_t calculatedChecksum = [self calculateChecksum:checksumData];
    [serializer addInt8:calculatedChecksum];
    
    [self.socket writeData:message  withTimeout:-1 tag:0];
}

- (void) readDataWithTag:(PXGMessageTag)tag
{
    switch (tag)
    {
        case HEADER:
            _currentMessageLength = 0;
            int8_t headerData[2] = {255, 255};
            [self.socket readDataToData: [NSData dataWithBytes:headerData length:2] withTimeout:-1 tag:HEADER];
            break;
            
        case SIZE:
            [self.socket readDataToLength:1 withTimeout:-1 tag:SIZE];
            break;
            
        case INSTRUCTION:
            [self.socket readDataToLength:1 withTimeout:-1 tag:INSTRUCTION];
            break;
            
        case DATA:
            [self.socket readDataToLength:(_currentMessageLength - 1) withTimeout:-1 tag:DATA];
            break;
            
        case CHECKSUM:
            [self.socket readDataToLength:1 withTimeout:-1 tag:CHECKSUM];
            break;
            
        default:
            break;
    }
}

#pragma mark socket delegate
- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    PXGDataSerializer* serializer = [[PXGDataSerializer alloc] initWithData:[NSMutableData dataWithData:data]];
    switch (tag)
    {
        case HEADER:
            [self readDataWithTag:SIZE];
            break;
            
        case SIZE:
        {
            _currentMessageLength = [serializer takeInt32];
            [self readDataWithTag:INSTRUCTION];
            break;
        }
        case INSTRUCTION:
        {
            _currentMessageInstruction = [serializer takeInt8];
            [self readDataWithTag:DATA];
            break;
        }
        case DATA:
            _currentMessageData = data;
            [self readDataWithTag:CHECKSUM];
            break;
            
        case CHECKSUM:
        {
            uint8_t receivedChecksum = [serializer takeInt8];
            
            NSMutableData* checksumData = [[NSMutableData alloc] initWithBytes:&_currentMessageLength length:1];
            [checksumData appendBytes:&_currentMessageInstruction length:1];
            [checksumData appendData:_currentMessageData];
            uint8_t calculatedChecksum = [self calculateChecksum:checksumData];
            
            [self readDataWithTag:HEADER];
            if (receivedChecksum == calculatedChecksum)
            {
                [_delegate messageReceived: _currentMessageInstruction withData:_currentMessageData];
            }
            
            break;
        }
        default:
            break;
    }

}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [_delegate protocolConnected];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error
{
    [_delegate protocolDisconnectedWithError:error];
}

@end
