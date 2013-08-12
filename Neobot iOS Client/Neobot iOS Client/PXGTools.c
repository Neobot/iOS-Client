//
//  PXGTools.c
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#include "PXGTools.h"

NSDictionary* pxgEncodePointData(double x, double y, double theta)
{
    return @{@"x": [NSNumber numberWithDouble:x], @"y" : [NSNumber numberWithDouble:x], @"theta" : [NSNumber numberWithDouble:theta]};
}

void pxgDecodePointData(NSDictionary* dictionnary, double* x, double* y, double* theta)
{
    *x = [[dictionnary objectForKey:@"x"] doubleValue];
    *y = [[dictionnary objectForKey:@"y"] doubleValue];
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