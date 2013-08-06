//
//  PXGTools.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#ifndef Neobot_Client_PXGTools_h
#define Neobot_Client_PXGTools_h

#import <UIKit/UIKit.h>


NSDictionary* pxgEncodePointData(int x, int y, double theta);
void pxgDecodePointData(NSDictionary* dictionnary, int* x, int* y, double* theta);

NSDictionary* pxgEncodeTrajectoryData(NSString* name, NSArray* pointsData);
void pxgDecodeTrajectoryData(NSDictionary* dictionnary, NSString** name, NSArray** pointsData);

double pxgRadiansToDegrees(double radian);
double pxgDegreesToRadians(double degrees);

#endif
