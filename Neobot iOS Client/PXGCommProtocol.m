//
//  PXGCommProtocol.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGCommProtocol.h"

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
    NSMutableArray* _delegates;
    int _currentMessageLength;
}

- (id) init
{
    if ((self = [super init]))
	{
		self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _delegates = [[NSMutableArray alloc] init];
        _currentMessageLength = 0;
        
        [self readDataWithTag:HEADER];
	}
    
    return self;
}

- (void) addDelegate: (id<PXGProtocolDelegate>)delegate
{
    [_delegates addObject:delegate];
}

- (void) removeDelegate: (id<PXGProtocolDelegate>)delegate
{
    [_delegates removeObject:delegate];
}

- (void) readDataWithTag:(PXGMessageTag)tag
{
    switch (tag)
    {
        case HEADER:
            _currentMessageLength = 0;
            char headerData[2] = {255, 255};
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
    switch (tag)
    {
        case HEADER:
            [self readDataWithTag:SIZE];
            break;
            
        case SIZE:
            [self readDataWithTag:INSTRUCTION];
            break;
            
        case INSTRUCTION:
            [self readDataWithTag:DATA];
            break;
            
        case DATA:
            [self readDataWithTag:CHECKSUM];
            break;
            
        case CHECKSUM:
            [self readDataWithTag:HEADER];
            break;
            
        default:
            break;
    }

}

@end
