//
//  PXGFirstViewController.h
//  Neobot iOS Client
//
//  Created by Thibaud Rabillard on 13/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"
#import "PXGStrategySelectionViewController.h"
#import "PXGTeleportViewController.h"
#import "PXGTrajectoriesViewController.h"
#import "PXGMapViewController.h"

@interface PXGRemoteViewController : UIViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate, PXGStrategySelectionViewControllerDelegate, PXGTeleportSelectionViewControllerDelegate, PXGTrajectoriesViewControllerDelegate, PXGMapViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) PXGMapViewController* mapController;

@property (weak, nonatomic) IBOutlet UIButton *btnStartStrategy;
@property (weak, nonatomic) IBOutlet UILabel *lblStrategy;

@property (weak, nonatomic) IBOutlet UIButton *btnTrajectory;
@property (weak, nonatomic) IBOutlet UIButton *btnTeleport;
@property (weak, nonatomic) IBOutlet UIButton *btnFlush;
@property (weak, nonatomic) IBOutlet UIButton *btnActions;

@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblObjective;

@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeedTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeedValue;

- (IBAction)flush:(id)sender;
- (IBAction)speedSliderChanged:(UISlider *)sender;


@end
