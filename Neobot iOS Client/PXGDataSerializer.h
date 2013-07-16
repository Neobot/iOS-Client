//
//  PXGDataParser.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXGDataSerializer : NSObject

- (id)initWithData:(NSMutableData*) data;

- (void) addInt8:(int8_t) value;
- (int8_t) takeInt8;
- (int8_t) readInt8At: (int) position;

@end
