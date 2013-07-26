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

@interface PXGRemoteViewController : UIViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate, PXGStrategySelectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnStartStrategy;
@property (weak, nonatomic) IBOutlet UILabel *lblStrategy;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnTrajectory;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnTeleport;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFlush;

@property (weak, nonatomic) IBOutlet UITextField *txtPosition;
@property (weak, nonatomic) IBOutlet UITextField *txtObjective;

- (IBAction)flush:(id)sender;

@end
