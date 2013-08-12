//
//  PXGMapObject.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 12/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMapObject.h"

@implementation PXGMapObject

- (id)initWithPosition:(PXGRPoint*)position radius:(double)radius andImage:(NSString*)imageName
{
    if ((self = [super init]))
	{
		self.position = position;
        self.radius = radius;
        self.imageName = imageName;
	}
    
    return self;
}

@end
