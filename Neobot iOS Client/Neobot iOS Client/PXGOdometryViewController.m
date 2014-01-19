//
//  PXGOdometryViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 19/01/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGOdometryViewController.h"

#import "CPTXYGraph.h"
#import "CPTTheme.h"
#import "CPTScatterPlot.h"
#import "CPTMutableLineStyle.h"
#import "CPTColor.h"
#import "CPTXYPlotSpace.h"
#import "CPTMutablePlotRange.h"
#import "CPTUtilities.h"
#import "CPTMutableTextStyle.h"
#import "CPTPlotAreaFrame.h"
#import "CPTXYAxisSet.h"
#import "CPTXYAxis.h"
#import "CPTLegend.h"

@interface PXGOdometryViewController ()

@property (strong, nonatomic) CPTScatterPlot* xtRobotPlot;

@end

@implementation PXGOdometryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    self.xtHostingGraph.allowPinchScaling = YES;
    CPTXYGraph* xGraph = [[CPTXYGraph alloc] initWithFrame:self.xtHostingGraph.bounds];
    self.xtHostingGraph.hostedGraph = xGraph;
    
    NSString *title = @"X(t)";
    xGraph.title = title;

    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    xGraph.titleTextStyle = titleStyle;
    xGraph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    //xGraph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    xGraph.paddingLeft   = 0.0;
    xGraph.paddingTop    = 0.0;
    xGraph.paddingRight  = 0.0;
    xGraph.paddingBottom = 0.0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)xGraph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    

    [xGraph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    
    //robot plot
    self.xtRobotPlot = [[CPTScatterPlot alloc] init];
    self.xtRobotPlot.identifier = @"Robot";
    
    CPTMutableLineStyle *lineStyle = [self.xtRobotPlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 3.f;
    lineStyle.lineColor              = [CPTColor redColor];
    self.xtRobotPlot.dataLineStyle = lineStyle;
    
    self.xtRobotPlot.dataSource = self;
    
    [xGraph addPlot:self.xtRobotPlot];
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:self.xtRobotPlot, nil]];
    
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.32f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    
    plotSpace.globalXRange = xRange;
    plotSpace.globalYRange = yRange;
    plotSpace.elasticGlobalXRange = YES;
    plotSpace.elasticGlobalYRange = YES;
    
    //axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) xGraph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    
    
    //legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:xGraph];
 
    theLegend.numberOfColumns = 1;
    //theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    // 4 - Add legend to graph
    xGraph.legend = theLegend;
    xGraph.legendAnchor = CPTRectAnchorBottomRight;
    //CGFloat legendPadding = -(self.view.bounds.size.width / 8);
    xGraph.legendDisplacement = CGPointMake(-10.0, 50.0);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 5;
}

-(double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if (plot == self.xtRobotPlot)
        return index * 100;
    
    return 0;
}

@end
