//
//  PXGOdometryViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 19/01/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGOdometryViewController.h"
#import "PXGSimpleScatterPlotViewController.h"

@interface PXGOdometryViewController ()
{
    bool _positionReceived;
    bool _objectiveReceived;
    
    double _lastPosX, _lastPosY, _lastPosTheta;
    double _lastObjX, _lastObjY, _lastObjTheta;
}

@end

@implementation PXGOdometryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lastPosX = -1;
    _lastPosY = -1;
    _lastPosTheta = -1;
    _lastObjX = -1;
    _lastObjY = -1;
    _lastObjTheta = -1;
    
    [self.xGraphController addPlot:@"Robot" withColor:[CPTColor redColor]];
    [self.xGraphController addPlot:@"Objective" withColor:[CPTColor blueColor]];
    self.xGraphController.name = @"X/t";
    self.xGraphController.maxValues = 300;

    [self.yGraphController addPlot:@"Robot" withColor:[CPTColor redColor]];
    [self.yGraphController addPlot:@"Objective" withColor:[CPTColor blueColor]];
    self.yGraphController.name = @"Y/t";
    self.yGraphController.maxValues = 300;

    [self.thetaGraphController addPlot:@"Robot" withColor:[CPTColor redColor]];
    [self.thetaGraphController addPlot:@"Objective" withColor:[CPTColor blueColor]];
    self.thetaGraphController.name = @"Theta/t";
    self.thetaGraphController.maxValues = 300;
    
    _positionReceived = false;
    _objectiveReceived = false;
	
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PXGSimpleScatterPlotViewController* controller = (PXGSimpleScatterPlotViewController*)segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"xGraphSegue"])
    {
        self.xGraphController = controller;
    }
    else if ([segue.identifier isEqualToString:@"yGraphSegue"])
    {
        self.yGraphController = controller;
    }
    else if ([segue.identifier isEqualToString:@"thetaGraphSegue"])
    {
        self.thetaGraphController = controller;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
}

- (void)didReceiveRobotPositionX:(int16_t)x  Y:(int16_t)y angle:(double)theta direction:(uint8_t)direction
{
    double xd = x;
    double yd = y;
    
    if (xd != _lastPosX || yd != _lastPosY || theta != _lastPosTheta)
    {
        _lastPosX = xd;
        _lastPosY = yd;
        _lastPosTheta = theta;
        
        [self reloadGraphIfNeeded:&_positionReceived and:&_objectiveReceived];
    }
}

- (void)didReceiveRobotObjectiveX:(int16_t)x Y:(int16_t)y angle:(double)theta
{
    double xd = x;
    double yd = y;
    
    if (xd != _lastObjX || yd != _lastObjY || theta != _lastObjTheta)
    {
        _lastObjX = xd;
        _lastObjY = yd;
        _lastObjTheta = theta;
        
        [self reloadGraphIfNeeded:&_objectiveReceived and:&_positionReceived];
    }
}

- (void)addLatestDataToGraphs
{
    [self.xGraphController addValue:_lastPosX toPlotIndex:0];
    [self.yGraphController addValue:_lastPosY toPlotIndex:0];
    [self.thetaGraphController addValue:_lastPosTheta toPlotIndex:0];
    
    [self.xGraphController addValue:_lastObjX toPlotIndex:1];
    [self.yGraphController addValue:_lastObjY toPlotIndex:1];
    [self.thetaGraphController addValue:_lastObjTheta toPlotIndex:1];
}

-(void)reloadGraphIfNeeded:(bool*)firstReceivedValue and:(bool*)secondReceivedValue
{
    if ((*firstReceivedValue && !*secondReceivedValue) || (!*firstReceivedValue && *secondReceivedValue))
	{
        [self addLatestDataToGraphs];
        [self reloadAllgraphs];
        *firstReceivedValue = false;
        *secondReceivedValue = false;
        
    }
    else if (!*firstReceivedValue && !*secondReceivedValue)
    {
        *firstReceivedValue = true;
    }
    else
    {
        //should not be possible
        *firstReceivedValue = false;
        *secondReceivedValue = false;
    }
}

- (void)reloadAllgraphs
{
    [self.xGraphController reloadData];
    [self.yGraphController reloadData];
    [self.thetaGraphController reloadData];
}

@end
