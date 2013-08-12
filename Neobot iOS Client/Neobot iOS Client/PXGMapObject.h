//
//  PXGMapObject.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 12/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXGRPoint.h"

@interface PXGMapObject : NSObject

- (id)initWithPosition:(PXGRPoint*)position radius:(double)radius andImage:(NSString*)imageName;

@property (strong, nonatomic) PXGRPoint* position;
@property (nonatomic)         double     radius;

@property (strong, nonatomic) NSString* imageName;

@end
