//
//  PXGMainToolBarViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"

@interface PXGMainToolBarViewController : UIViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate, UIPopoverControllerDelegate, UIToolbarDelegate>

- (IBAction)displayConnectionView:(id)sender;
- (IBAction)displayLogView:(id)sender;
- (IBAction)displayOptionsView:(id)sender;
- (IBAction)displayParameters:(id)sender;
- (IBAction)displayAutoStart:(id)sender;

@property (strong, nonatomic) UIPopoverController* connectionPopoverController;
@property (strong, nonatomic) UIPopoverController* logPopoverController;
@property (strong, nonatomic) UIPopoverController* optionsPopoverController;
@property (strong, nonatomic) UIPopoverController* autoStartPopoverController;
@property (weak, nonatomic)   UITabBarController* tabBarController;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@property (weak, nonatomic) IBOutlet UIToolbar *mainToolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *connectionBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *optionsBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *parametersBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *autoStartBtn;

@end
