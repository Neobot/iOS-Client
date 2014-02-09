//
//  PXGSensorsViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 08/02/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"

@class PXGSimpleScatterPlotViewController;

@interface PXGSensorsViewController : UIViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate>

@property (nonatomic, weak) PXGSimpleScatterPlotViewController* avoidingGraphController;
@property (nonatomic, weak) PXGSimpleScatterPlotViewController* otherGraphController;
@property (weak, nonatomic) IBOutlet UISwitch *switchRecord;
- (IBAction)recordingStatusChanged:(UISwitch *)sender;

@end
