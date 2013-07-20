//
//  PXGMainToolBarViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"

@interface PXGMainToolBarViewController : UIViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate>

- (IBAction)displayConnectionView:(id)sender;
- (IBAction)displayLogView:(id)sender;

@property UIPopoverController* connectionPopoverController;
@property UIPopoverController* logPopoverController;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *connectionBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logBtn;

@end
