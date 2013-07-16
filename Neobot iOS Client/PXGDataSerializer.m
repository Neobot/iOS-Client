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

- (id)initWithData:(NSMutableData*)data
{
    if ((self = [super init]))
	{
        _data = data;
        _pos = 0;
    }
    
    return self;
}

- (void) addInt8:(int8_t)value
{
    [_data appendBytes:&value length:1];
}

- (int8_t) readInt8At:(int)position
{
    int8_t value = 0;
    
    void* bytes = 0;
    [_data getBytes:bytes length:1];
    
    value = *((int8_t*)(bytes + position));
    
    return value;
}

- (int8_t) takeInt8
{
    _pos += 1;
    return [self readInt8At:_pos - 1];
}

@end
