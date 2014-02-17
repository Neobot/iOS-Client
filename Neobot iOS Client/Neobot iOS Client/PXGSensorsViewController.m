//
//  PXGSensorsViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 08/02/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGSensorsViewController.h"
#import "PXGSimpleScatterPlotViewController.h"
#import "PXGParametersKeys.h"

#include "math.h"

@interface PXGSensorsViewController ()
{
    int _nbAvoiding;
    int _nbOther;
}

@property (nonatomic, strong) NSArray* colors;

@end

@implementation PXGSensorsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.switchRecord setOn:[[NSUserDefaults standardUserDefaults] boolForKey:SENSORS_RECORD_ACTIVATED]];
    
    _nbAvoiding = 0;
    _nbOther = 0;
    
    self.colors = @[[CPTColor redColor], [CPTColor blueColor], [CPTColor greenColor], [CPTColor yellowColor], [CPTColor grayColor], [CPTColor cyanColor]];
	
    self.avoidingGraphController.name = @"Avoiding sensors";
    self.avoidingGraphController.maxValues = 600;
    [self.avoidingGraphController setYBoundMin:0 andMax:260];
    
    self.otherGraphController.name = @"Other sensors";
    self.otherGraphController.maxValues = 600;
    [self.otherGraphController setYBoundMin:0 andMax:260];

    
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PXGSimpleScatterPlotViewController* controller = (PXGSimpleScatterPlotViewController*)segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"avoidingGraphSegue"])
    {
        self.avoidingGraphController = controller;

    }
    else if ([segue.identifier isEqualToString:@"otherGraphSegue"])
    {
        self.otherGraphController = controller;
    }
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
}

- (void)didReceiveAvoidingSensorsValues:(NSArray*)values
{
    if (self.switchRecord.isOn)
    {
        [self addValues:values toGraph:self.avoidingGraphController withLoadedPlots:_nbAvoiding];
        _nbAvoiding = MAX(_nbAvoiding, values.count);
    }
}

- (void)didReceiveOtherSensorsValues:(NSArray*)values
{
    if (self.switchRecord.isOn)
    {
        [self addValues:values toGraph:self.otherGraphController withLoadedPlots:_nbOther];
        _nbOther = MAX(_nbOther, values.count);
    }
}

- (void)addValues:(NSArray*)values toGraph:(PXGSimpleScatterPlotViewController*)graphController withLoadedPlots:(int)nbExistingPlots
{
    int numPlot = 0;
    for (NSNumber* num in values)
    {
        int value = [num intValue];
        
        if (nbExistingPlots <= numPlot)
        {
            [graphController addPlot:[NSString stringWithFormat:@"Sensor %i", numPlot] withColor:[self.colors objectAtIndex:numPlot]];
            [graphController fillDataWith:0 forSize:graphController.maxValues];
            ++nbExistingPlots;
        }
        
        [graphController addValue:value toPlotIndex:numPlot];
        
        ++numPlot;
    }
    
    [graphController reloadData];

}

- (IBAction)recordingStatusChanged:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:SENSORS_RECORD_ACTIVATED];

}
@end