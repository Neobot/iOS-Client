//
//  PXGFirstViewController.m
//  Neobot iOS Client
//
//  Created by Thibaud Rabillard on 13/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGRemoteViewController.h"


@interface PXGRemoteViewController ()

@end

@implementation PXGRemoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
    
    UIApplication *app = [UIApplication sharedApplication];
    [self doLayoutForOrientation:app.statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self doLayoutForOrientation:toInterfaceOrientation];
}

- (void)doLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
    self.btnStartStrategy.hidden = !isPortrait;
    self.lblStrategy.hidden = !isPortrait;
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    BOOL robotInteractionEnabled = status == Controlled;
    
    self.btnStartStrategy.enabled = robotInteractionEnabled;
    self.btnTeleport.enabled = robotInteractionEnabled;
    self.btnFlush.enabled = robotInteractionEnabled;
    self.btnTrajectory.enabled = robotInteractionEnabled;
}

- (void)didReceiveRobotPositionX:(int16_t)x  Y:(int16_t)y angle:(double)theta direction:(uint8_t)direction
{
    int td = theta * 180.0 / 3.14116;
    NSString* text = [NSString stringWithFormat:@"x=%d y=%d t=%d", x, y, td];
    self.txtPosition.text = text;
}

- (void)didReceiveRobotObjectiveX:(int16_t)x Y:(int16_t)y angle:(double)theta
{
    int td = theta * 180.0 / M_PI;
    NSString* text = [NSString stringWithFormat:@"x=%d y=%d t=%d", x, y, td];
    self.txtObjective.text = text;
}


@end
