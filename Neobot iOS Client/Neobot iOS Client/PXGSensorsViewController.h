//
//  PXGSensorsViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 08/02/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"
#import "PXGColorCollectionViewController.h"

@class PXGSimpleScatterPlotViewController;

@interface PXGSensorsViewController : UIViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate>

@property (nonatomic, weak) PXGSimpleScatterPlotViewController* avoidingGraphController;
@property (nonatomic, weak) PXGColorCollectionViewController* colorCollectionController;
@property (weak, nonatomic) IBOutlet UISwitch *switchRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnEnableSensors;
@property (weak, nonatomic) IBOutlet UIButton *btnDisableSensors;

- (IBAction)recordingStatusChanged:(UISwitch *)sender;
- (IBAction)onEnableSensors:(id)sender;
- (IBAction)onDisableSensors:(id)sender;


@end
