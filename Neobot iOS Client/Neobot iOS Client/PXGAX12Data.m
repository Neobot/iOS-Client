//
//  PXGAX12Data.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 30/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12Data.h"

@implementation PXGAX12Data

- (id)initWithId:(int)ax12ID
{
    if ((self = [super init]))
	{
		self.ax12ID = ax12ID;
        self.locked = NO;
        self.position = 0.0;
	}
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionnary
{
    int ax12ID = [[dictionnary objectForKey:@"id"] intValue];
    double position = [[dictionnary objectForKey:@"position"] doubleValue];
    BOOL locked = [[dictionnary objectForKey:@"locked"] boolValue];
    
    PXGAX12Data* ax12 = [self initWithId:ax12ID];
    ax12.position = position;
    ax12.locked = locked;
    
    return ax12;
}

+ (PXGAX12Data*)ax12WithId:(int)ax12ID
{
    return [[PXGAX12Data alloc] initWithId:ax12ID];
}

- (NSDictionary*)encodeToDictionary
{
    return @{@"id": [NSNumber numberWithInt:self.ax12ID],
             @"position": [NSNumber numberWithDouble:self.position],
             @"locked": [NSNumber numberWithBool:self.locked]};
}

@end
