//
//  PXGAX12Data.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 30/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXGAX12Data : NSObject

- (id)initWithId:(int)ax12ID;
- (id)initWithDictionary:(NSDictionary*)dictionnary;

+ (PXGAX12Data*)ax12WithId:(int)ax12ID;

- (NSDictionary*)encodeToDictionary;

@property (nonatomic) int ax12ID;
@property (nonatomic) double position;
@property (nonatomic) double command;

@end
