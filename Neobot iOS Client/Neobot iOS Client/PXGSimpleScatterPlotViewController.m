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
#import "CPTLineStyle.h"

@interface PXGSimpleScatterPlotViewController ()

@property (strong, nonatomic) CPTLegend *legend;
@property (strong, nonatomic) CPTXYGraph *graph;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation PXGSimpleScatterPlotViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.maxValues = -1;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.data = [NSMutableArray array];
    
    self.graphHostingView = (CPTGraphHostingView*)self.view;
    self.graphHostingView.allowPinchScaling = YES;
    
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.graphHostingView.bounds];
    self.graphHostingView.hostedGraph = self.graph;

    self.graph.title = self.name;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor colorWithGenericGray:0.33];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 17.0f;
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
    
    
    //[self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];;
    self.graph.fill = [CPTFill fillWithColor:[CPTColor colorWithGenericGray:.9]];
    CPTMutableLineStyle* borderStyle = [CPTMutableLineStyle lineStyle];
    self.graph.borderLineStyle = borderStyle;
    
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
    
    [self refreshPlotSpace:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.graph.title = _name;
}

- (void)fillDataWith:(double)defaultValue forSize:(int)size
{
    if (size > 0)
    {
        for (NSMutableArray* plotValues in self.data)
        {
            while (plotValues.count < size)
            {
                [plotValues addObject:[NSNumber numberWithDouble:defaultValue]];
            }
        }
    }
}

- (void) addPlot:(NSString*)name withColor:(CPTColor*)color
{
    //robot plot
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] init];
    plot.identifier = name;
    
    CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 3.f;
    lineStyle.lineColor              = color;
    plot.dataLineStyle = lineStyle;
    
    plot.dataSource = self;
    
    [self.graph addPlot:plot];
    [self.legend addPlot:plot];
    [self.data addObject:[NSMutableArray array]];
}

- (void)setYBoundMin:(double) min andMax:(double) max
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    yRange.location = CPTDecimalFromDouble(min);
    yRange.length = CPTDecimalFromDouble(max - min);
    
    plotSpace.yRange = yRange;
    
    [self refreshPlotSpace:true];
}

- (void) refreshPlotSpace:(bool)forceChange
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    NSDecimal oldXLoc = plotSpace.xRange.location;
    NSDecimal oldXLength = plotSpace.xRange.length;
    
    NSDecimal oldYLoc = plotSpace.yRange.location;
    NSDecimal oldYLength = plotSpace.yRange.length;
    
    [plotSpace scaleToFitPlots:self.graph.allPlots];
    
    bool xChanged = forceChange || !CPTDecimalEquals(oldXLoc, plotSpace.xRange.location) || !CPTDecimalEquals(oldXLength, plotSpace.xRange.length);
    bool yChanged = forceChange || !CPTDecimalEquals(oldYLoc, plotSpace.yRange.location) || !CPTDecimalEquals(oldYLength, plotSpace.yRange.length);
    
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    
    if (xChanged)
    {
        NSDecimal xRangeEnd = CPTDecimalAdd(xRange.location, xRange.length);
        if (CPTDecimalGreaterThan(xRange.location, CPTDecimalFromCGFloat(0.0f)))
        {
            xRange.location = CPTDecimalFromFloat(0.f);
            xRange.length = xRangeEnd;
        }
        else if (CPTDecimalLessThan(xRangeEnd, CPTDecimalFromCGFloat(0.0f)))
        {
            xRange.length = CPTDecimalAbs(xRange.location);
        }
    }

    
    if (yChanged)
    {
        NSDecimal yRangeEnd = CPTDecimalAdd(yRange.location, yRange.length);
        if (CPTDecimalGreaterThan(yRange.location, CPTDecimalFromCGFloat(0.0f)))
        {
            
            yRange.location = CPTDecimalFromFloat(0.f);
            yRange.length = yRangeEnd;
        }
        else if (CPTDecimalLessThan(yRangeEnd, CPTDecimalFromCGFloat(0.0f)))
        {
            yRange.length = CPTDecimalAbs(yRange.location);
        }
    }
    
    if (self.maxValues > 0)
    {
        xRange.length = CPTDecimalFromInt(self.maxValues);
    }
    
    CPTMutablePlotRange *xRange2 = [xRange mutableCopy];
    CPTMutablePlotRange *yRange2 = [yRange mutableCopy];
    
    if (xChanged)
    {
        [xRange2 expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
        plotSpace.xRange = xRange2;
    }
    
    if (yChanged)
    {
        [yRange2 expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
        plotSpace.yRange = yRange2;
    }

    plotSpace.globalXRange = xRange2;
    plotSpace.globalYRange = yRange2;
    plotSpace.elasticGlobalXRange = YES;
    plotSpace.elasticGlobalYRange = YES;
    
    //axis
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor colorWithGenericGray:0.7];
    gridLineStyle.lineWidth = .5f;
    gridLineStyle.dashPattern = @[@2];
    
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
    //x.majorGridLineStyle = gridLineStyle;
    //x.minorGridLineStyle = gridLineStyle;
    x.gridLinesRange = xVisibleTickRange;
    
    
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.axisLineCapMax = lineCap;
    y.visibleAxisRange = yRange;
    CPTMutablePlotRange* yVisibleTickRange = [y.visibleAxisRange mutableCopy];
    [yVisibleTickRange expandRangeByFactor:CPTDecimalFromCGFloat(0.98f)];
    y.visibleRange = yVisibleTickRange;
    //y.majorGridLineStyle = gridLineStyle;
    //y.minorGridLineStyle = gridLineStyle;
    y.gridLinesRange = yVisibleTickRange;
}

- (void) addValue:(double)value toPlotIndex:(int)plotIndex
{
    NSMutableArray* values = [self.data objectAtIndex:plotIndex];
    [values addObject:[NSNumber numberWithDouble:value]];
    
    while(values.count > self.maxValues)
    {
        [values removeObjectAtIndex:0];
    }
}

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot
{

    int plotIndex = [self.graph.allPlots indexOfObject:plot];
    return [[self.data objectAtIndex:plotIndex] count];
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
    [self refreshPlotSpace:false];
}

@end
