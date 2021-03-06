//
//  PXGDataParser.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXGDataSerializer : NSObject

@property CFByteOrder endianness;

- (id)initWithData:(NSMutableData*) data;
+ (void)setDefaultEndianness:(CFByteOrder)endianness;
- (BOOL)atEnd;

- (void)addInt8:(uint8_t)value;
- (uint8_t)takeInt8;
- (uint8_t)readInt8At:(int)position;

- (void)addInt16:(uint16_t)value;
- (uint16_t)takeInt16;
- (uint16_t)readInt16At:(int)position;

- (void)addInt32:(uint32_t)value;
- (uint32_t)takeInt32;
- (uint32_t)readInt32At:(int)position;

- (void)addFloat:(float)value;
- (float)takeFloat;
- (float)readFloatAt:(int)position;

- (void)addData:(NSData*) data;
- (NSData*)readDataAt:(int)position withLength:(int)length;
- (NSData*)takeDataWithLength:(int)length;

- (void)addBool:(BOOL)b;
- (void)addBool:(BOOL)b1 and:(BOOL)b2;
- (void)addBool:(BOOL)b1 and:(BOOL)b2 and:(BOOL)b3;
- (void)readBool:(BOOL*)b1 and:(BOOL*)b2 and:(BOOL*)b3 at:(int)position;
- (void)takeBool:(BOOL*)b;
- (void)takeBool:(BOOL*)b1 and:(BOOL*)b2;
- (void)takeBool:(BOOL*)b1 and:(BOOL*)b2 and:(BOOL*)b3;

- (void)addString:(NSString*)string;
- (NSString*)readStringAt:(int)position;
- (NSString*)takeString;

@end
