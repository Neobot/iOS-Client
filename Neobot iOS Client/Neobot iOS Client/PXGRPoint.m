//
//  PXGRPoint.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 12/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGRPoint.h"
#import "PXGTools.h"

@implementation PXGRPoint

- (id) initWithX:(double)x y:(double)y theta:(double)theta
{
    if ((self = [super init]))
	{
		self.x = x;
        self.y = y;
        self.theta = theta;
	}
    
    return self;
}

- (id) initWithDictionary:(NSDictionary*)dictionnary
{
    double x, y, theta;
    pxgDecodePointData(dictionnary, &x, &y, &theta);
    
    return [self initWithX:x y:y theta:theta];
}

+ (PXGRPoint*)rpointAtUnknownPosition
{
    return [[PXGRPoint alloc] initWithX:-1000 y:-1000 theta:0];
}

+ (PXGRPoint*)rpointFromRPoint:(PXGRPoint*)point
{
    return [[PXGRPoint alloc] initWithX:point.x y:point.y theta:point.theta];
}

- (NSDictionary*)encodeToDictionary
{
    return pxgEncodePointData(self.x, self.y, self.theta);
}

@end
