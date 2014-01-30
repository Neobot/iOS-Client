//
//  PXGOdometryViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 19/01/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"

@class PXGSimpleScatterPlotViewController;


@interface PXGOdometryViewController : UIViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate>

@property (nonatomic, weak) PXGSimpleScatterPlotViewController* xGraphController;
@property (nonatomic, weak) PXGSimpleScatterPlotViewController* yGraphController;
@property (nonatomic, weak) PXGSimpleScatterPlotViewController* thetaGraphController;

@end
