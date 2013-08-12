//
//  PXGRPoint.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 12/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXGRPoint : NSObject

- (id)initWithX:(double)x y:(double)y theta:(double)theta;
- (id)initWithDictionary:(NSDictionary*)dictionnary;

+ (PXGRPoint*)rpointAtUnknownPosition;

- (NSDictionary*)encodeToDictionary;

@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) double theta;

@end
