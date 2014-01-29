//
//  PXGSimpleScatterPlotViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/01/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGSimpleScatterPlotViewController.h"

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
#import "CPTLineCap.h"
#import "CPTFill.h"

@interface PXGSimpleScatterPlotViewController ()

@property (strong, nonatomic) CPTLegend *legend;
@property (strong, nonatomic) CPTXYGraph *graph;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation PXGSimpleScatterPlotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.data = [NSMutableArray array];
    
    self.graphHostingView = (CPTGraphHostingView*)self.view;
    self.graphHostingView.allowPinchScaling = YES;
    
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.graphHostingView.bounds];
    self.graphHostingView.hostedGraph = self.graph;

    self.name = @"aaa";
    self.graph.title = self.name;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    self.graph.titleTextStyle = titleStyle;
    self.graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    //xGraph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    self.graph.paddingLeft   = 0.0;
    self.graph.paddingTop    = 0.0;
    self.graph.paddingRight  = 0.0;
    self.graph.paddingBottom = 0.0;
    
    [self.graph.plotAreaFrame setPaddingLeft:10.0f];
    [self.graph.plotAreaFrame setPaddingBottom:10.0f];
    [self.graph.plotAreaFrame setPaddingTop:10.0f];
    [self.graph.plotAreaFrame setPaddingRight:10.0f];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    
    
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    
    //legend
    self.legend = [[CPTLegend alloc] init];
    
    self.legend.numberOfColumns = 1;
    //theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    self.legend.borderLineStyle = [CPTLineStyle lineStyle];
    self.legend.cornerRadius = 5.0;

    self.graph.legend = self.legend;
    self.graph.legendAnchor = CPTRectAnchorBottomRight;
    //CGFloat legendPadding = -(self.view.bounds.size.width / 8);
    self.graph.legendDisplacement = CGPointMake(-10.0, 50.0);
    
    
    [self addPlot:@"Robot"];
    [self addPlotValue:1 toPlotIndex:0];
    [self addPlotValue:5 toPlotIndex:0];
    [self addPlotValue:4 toPlotIndex:0];
    [self addPlotValue:9 toPlotIndex:0];
    [self addPlotValue:7 toPlotIndex:0];
    
    [self reloadData];
    [self refreshPlotSpace];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addPlot:(NSString*)name
{
    //robot plot
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] init];
    plot.identifier = name;
    
    CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 3.f;
    lineStyle.lineColor              = [CPTColor redColor];
    plot.dataLineStyle = lineStyle;
    
    plot.dataSource = self;
    
    [self.graph addPlot:plot];
    [self.legend addPlot:plot];
    [self.data addObject:[NSMutableArray array]];
    
    [self refreshPlotSpace];
}

- (void) refreshPlotSpace
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    [plotSpace scaleToFitPlots:self.graph.allPlots];

    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    NSDecimal xRangeEnd = CPTDecimalAdd(xRange.location, xRange.length);
    xRange.location = CPTDecimalFromFloat(0.f);
    xRange.length = xRangeEnd;
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    NSDecimal yRangeEnd = CPTDecimalAdd(yRange.location, yRange.length);
    yRange.location = CPTDecimalFromFloat(0.f);
    yRange.length = yRangeEnd;
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    
    plotSpace.globalXRange = xRange;
    plotSpace.globalYRange = yRange;
    plotSpace.elasticGlobalXRange = YES;
    plotSpace.elasticGlobalYRange = YES;
    
    //axis
    CPTLineCap* lineCap = [CPTLineCap sweptArrowPlotLineCap];
    lineCap.size = CGSizeMake(10, 10);
    lineCap.fill = [CPTFill fillWithColor:[CPTColor blackColor]];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.graph.axisSet;
    
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    x.axisLineCapMax = lineCap;
    x.visibleAxisRange = xRange;
    CPTMutablePlotRange* xVisibleTickRange = [x.visibleAxisRange mutableCopy];
    [xVisibleTickRange expandRangeByFactor:CPTDecimalFromCGFloat(0.98f)];
    x.visibleRange = xVisibleTickRange;
    
    
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.axisLineCapMax = lineCap;
    y.visibleAxisRange = yRange;
    CPTMutablePlotRange* yVisibleTickRange = [y.visibleAxisRange mutableCopy];
    [yVisibleTickRange expandRangeByFactor:CPTDecimalFromCGFloat(0.98f)];
    y.visibleRange = yVisibleTickRange;
}

- (void) addPlotValue:(double)value toPlotIndex:(int)plotIndex
{
    [[self.data objectAtIndex:plotIndex] addObject:[NSNumber numberWithDouble:value]];
}

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSUInteger result = 0;
    
    for (NSMutableArray* plotValues in self.data)
    {
        NSUInteger nbValues = plotValues.count;
        if (nbValues > result)
            result = nbValues;
    }
    
    return result;
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    int plotIndex = [self.graph.allPlots indexOfObject:plot];
    int x = index;
    if (fieldEnum == CPTScatterPlotFieldY)
    {
        return [[self.data objectAtIndex:plotIndex] objectAtIndex:x];
    }
    else if (fieldEnum == CPTScatterPlotFieldX)
    {
        return [NSNumber numberWithDouble:x];
    }
    
    return [NSNumber numberWithDouble:index];
}

- (void)reloadData
{
    [self.graph reloadData];
}

@end
