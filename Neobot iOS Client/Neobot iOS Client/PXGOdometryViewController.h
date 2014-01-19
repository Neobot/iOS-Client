//
//  PXGOdometryViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 19/01/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTGraphHostingView.h"
#import "CPTPlot.h"

@interface PXGOdometryViewController : UIViewController <CPTPlotDataSource>

@property (weak, nonatomic) IBOutlet CPTGraphHostingView *xtHostingGraph;

@end
