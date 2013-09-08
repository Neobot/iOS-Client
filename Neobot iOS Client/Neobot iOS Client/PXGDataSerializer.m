//
//  PXGDataParser.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGDataSerializer.h"

@implementation PXGDataSerializer
{
    NSMutableData* _data;
    int _pos;
}

static CFByteOrder _defaultEndianness = CFByteOrderBigEndian;
+ (void)setDefaultEndianness:(CFByteOrder)endianness
{
    _defaultEndianness = endianness;
}

- (id)initWithData:(NSMutableData*)data
{
    if ((self = [super init]))
	{
        _data = data;
        _pos = 0;
        self.endianness = _defaultEndianness;
    }
    
    return self;
}

- (BOOL)atEnd
{
    return _pos >= [_data length] - 1;
}

- (BOOL) checkDataLength:(int)length atPos:(int)position
{
    return [_data length] - position >= length;
}

#pragma mark Int8

- (void) addInt8:(uint8_t)value
{
    [_data appendBytes:&value length:1];
}

- (uint8_t) readInt8At:(int)position
{
    if (![self checkDataLength:1 atPos:position])
        return 0;
    
    uint8_t value = 0;
    const void* bytes = _data.bytes;
    
    value = *((uint8_t*)(bytes + position));
    
    return value;
}

- (uint8_t) takeInt8
{
    _pos += 1;
    return [self readInt8At:_pos - 1];
}

#pragma mark Int16

- (void) addInt16:(uint16_t) value
{
    switch(self.endianness)
    {
        case CFByteOrderLittleEndian:
            value = CFSwapInt16HostToLittle(value);
            break;
        case CFByteOrderBigEndian:
            value = CFSwapInt16HostToBig(value);
            break;
    }
    
    [_data appendBytes:&value length:2];
}
- (uint16_t) takeInt16
{
    _pos += 2;
    return [self readInt16At:_pos - 2];

}

- (uint16_t) readInt16At: (int) position
{
    if (![self checkDataLength:2 atPos:position])
        return 0;
    
    uint16_t value = 0;
    const void* bytes = _data.bytes;
    
    value = *((uint16_t*)(bytes + position));
    
    switch(self.endianness)
    {
        case CFByteOrderLittleEndian:
            value = CFSwapInt16LittleToHost(value);
            break;
        case CFByteOrderBigEndian:
            value = CFSwapInt16BigToHost(value);
            break;
    }

    return value;
}

#pragma mark Int32

- (void) addInt32:(uint32_t)value
{
    switch(self.endianness)
    {
        case CFByteOrderLittleEndian:
            value = CFSwapInt32HostToLittle(value);
            break;
        case CFByteOrderBigEndian:
            value = CFSwapInt32HostToBig(value);
            break;
    }

    
    [_data appendBytes:&value length:4];
}

- (uint32_t) takeInt32
{
    _pos += 4;
    return [self readInt32At:_pos - 4];
    
}

- (uint32_t) readInt32At: (int) position
{
    if (![self checkDataLength:4 atPos:position])
        return 0;
    
    uint32_t value = 0;
   const void* bytes = _data.bytes;
    
    value = *((uint32_t*)(bytes + position));
    
    switch(self.endianness)
    {
        case CFByteOrderLittleEndian:
            value = CFSwapInt32LittleToHost(value);
            break;
        case CFByteOrderBigEndian:
            value = CFSwapInt32BigToHost(value);
            break;
    }
    
    return value;
}

#pragma mark NSData
- (void) addData:(NSData*) data
{
    [_data appendData:data];
}

- (NSData*) readDataAt:(int)position withLength:(int)length
{
    if (![self checkDataLength:length atPos:position])
        return nil;
    
    const void* bytes = _data.bytes + position;
    
    NSData* result = [NSData dataWithBytes:bytes length:length];
    return result;
}

- (NSData*) takeDataWithLength:(int)length
{
    _pos += length;
    return [self readDataAt:(_pos - length) withLength:length];
}

#pragma mark BOOL
- (void) addBool:(BOOL)b
{
    [self addBool:b and:YES and:YES];
}

- (void) addBool:(BOOL)b1 and:(BOOL)b2
{
    [self addBool:b1 and:b2 and:YES];
}

- (void) addBool:(BOOL)b1 and:(BOOL)b2 and:(BOOL)b3
{
    uint8_t value = 0;
    if (b1)
        value = 1;
    if (b2)
        value += 2;
    if (b3)
        value += 2 * 2;
    
    [self addInt8:value];
}

- (void) readBool:(BOOL*)b1 and:(BOOL*)b2 and:(BOOL*)b3 at:(int)position
{
    uint8_t value = [self readInt8At:position];
    
    *b1 = (value & 1) == 1;
    *b2 = (value & 2) == 2;
    *b3 = (value & 4) == 4;
}

- (void) takeBool:(BOOL*)b
{
    BOOL fake = YES;
    [self takeBool:b and:&fake and:&fake];
}

- (void) takeBool:(BOOL*)b1 and:(BOOL*)b2
{
    BOOL fake = YES;
    [self takeBool:b1 and:b2 and:&fake];
}

- (void) takeBool:(BOOL*)b1 and:(BOOL*)b2 and:(BOOL*)b3
{
    [self readBool:b1 and:b2 and:b3 at:_pos];
    ++_pos;
}

#pragma mark Strings
- (void) addString:(NSString*)string
{
    uint8_t size = [string length];
    [self addInt8:size];
    [self addData:[string dataUsingEncoding:NSASCIIStringEncoding]];
}

- (NSString*) readStringAt:(int)position
{
    uint8_t size = [self readInt8At:position];
    NSData* strData = [self readDataAt:position + 1 withLength:size];
    
    return [[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding];
}

- (NSString*)takeString
{
    NSString* result = [self readStringAt:_pos];
    _pos += [result length] + 1;
    
    return result;
}


@end
