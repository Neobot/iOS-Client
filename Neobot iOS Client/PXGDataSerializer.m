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
     __weak NSMutableData* _data;
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

#pragma mark Int8

- (void) addInt8:(uint8_t)value
{
    [_data appendBytes:&value length:1];
}

- (uint8_t) readInt8At:(int)position
{
    uint8_t value = 0;
    
    void* bytes = 0;
    [_data getBytes:bytes length:1];
    
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
            value = CFSwapInt32HostToLittle(value);
            break;
        case CFByteOrderBigEndian:
            value = CFSwapInt32HostToBig(value);
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
    uint16_t value = 0;
    
    void* bytes = 0;
    [_data getBytes:bytes length:2];
    
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
    return [self readInt16At:_pos - 4];
    
}

- (uint32_t) readInt32At: (int) position
{
    uint32_t value = 0;
    
    void* bytes = 0;
    [_data getBytes:bytes length:4];
    
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


@end
