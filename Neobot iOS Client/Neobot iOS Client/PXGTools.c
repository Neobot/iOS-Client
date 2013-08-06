//
//  PXGTools.c
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#include "PXGTools.h"

NSDictionary* pxgEncodePointData(int x, int y, double theta)
{
    return @{@"x": [NSNumber numberWithInt:x], @"y" : [NSNumber numberWithInt:y], @"theta" : [NSNumber numberWithDouble:theta]};
}

void pxgDecodePointData(NSDictionary* dictionnary, int* x, int* y, double* theta)
{
    *x = [[dictionnary objectForKey:@"x"] intValue];
    *y = [[dictionnary objectForKey:@"y"] intValue];
    *theta = [[dictionnary objectForKey:@"theta"] doubleValue];
}

NSDictionary* pxgEncodeTrajectoryData(NSString* name, NSArray* pointsData)
{
    return @{@"name": name, @"points" : pointsData};

}

void pxgDecodeTrajectoryData(NSDictionary* dictionnary, NSString** name, NSArray** pointsData)
{
    *name = [dictionnary objectForKey:@"name"];
    *pointsData = [dictionnary objectForKey:@"points"];
}

double pxgRadiansToDegrees(double radian)
{
    return radian * 180.0 / M_PI;
}

double pxgDegreesToRadians(double degrees)
{
    return degrees * M_PI / 180.0;
}