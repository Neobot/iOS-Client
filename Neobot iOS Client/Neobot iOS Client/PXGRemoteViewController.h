//
//  PXGFirstViewController.h
//  Neobot iOS Client
//
//  Created by Thibaud Rabillard on 13/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"

@interface PXGRemoteViewController : UIViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnStartStrategy;
@property (weak, nonatomic) IBOutlet UILabel *lblStrategy;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnTrajectory;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnTeleport;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFlush;

@property (weak, nonatomic) IBOutlet UITextField *txtPosition;
@property (weak, nonatomic) IBOutlet UITextField *txtObjective;

@end
