//
//  PXGSimpleScatterPlotViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/01/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CPTGraphHostingView.h"
#import "CPTPlot.h"

@interface PXGSimpleScatterPlotViewController : UIViewController<CPTPlotDataSource>

@property (weak, nonatomic) CPTGraphHostingView *graphHostingView;
@property (strong, nonatomic) NSString *name;

- (void)addPlot:(NSString*)name;
- (void)addValue:(double)value toPlotIndex:(int)plotIndex;
- (void)reloadData;

@end
