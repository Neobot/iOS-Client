//
//  PXGMainToolBarViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMainToolBarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PXGParametersKeys.h"

@interface PXGMainToolBarViewController ()
{
    int _messageCount;
}

@property (weak, nonatomic) UIPopoverController* currentPopoverController;

@end

@implementation PXGMainToolBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init options default values
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FOLLOW_THE_FINGER] == nil)
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FOLLOW_THE_FINGER];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FOLLOW_THE_FINGER_DELAY] == nil)
        [[NSUserDefaults standardUserDefaults] setDouble:0.5 forKey:FOLLOW_THE_FINGER_DELAY];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PORT_NUMBERS_KEY] == nil)
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:@"15042"] forKey:RECENT_PORT_NUMBERS_KEY];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RECENT_ROBOT_SERIALPORTS_KEY] == nil)
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:@"/dev/ttyS3"] forKey:RECENT_ROBOT_SERIALPORTS_KEY];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RECENT_AX12_SERIALPORTS_KEY] == nil)
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:@"/dev/ttyS2"] forKey:RECENT_AX12_SERIALPORTS_KEY];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TRAJECTORY_SPEED] == nil)
        [[NSUserDefaults standardUserDefaults] setDouble:100 forKey:TRAJECTORY_SPEED];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:AX12_MAX_SPEED] == nil)
        [[NSUserDefaults standardUserDefaults] setFloat:50 forKey:AX12_MAX_SPEED];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:AX12_MAX_TORQUE] == nil)
        [[NSUserDefaults standardUserDefaults] setFloat:50 forKey:AX12_MAX_TORQUE];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ODOMETRY_RECORD_ACTIVATED] == nil)
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ODOMETRY_RECORD_ACTIVATED];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SENSORS_RECORD_ACTIVATED] == nil)
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SENSORS_RECORD_ACTIVATED];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MOVEMENT_TYPE] == nil)
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:MOVEMENT_TYPE];
    
    
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
    
    UIViewController* connectionControler = [self.storyboard instantiateViewControllerWithIdentifier:@"CommViewController"];
    self.connectionPopoverController = [[UIPopoverController alloc] initWithContentViewController:connectionControler];
    self.connectionPopoverController.delegate = self;
    
    UIViewController* logController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    self.logPopoverController = [[UIPopoverController alloc] initWithContentViewController:logController];
    self.logPopoverController.delegate = self;
    
    UIViewController* optionsController = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionsViewController"];
    self.optionsPopoverController = [[UIPopoverController alloc] initWithContentViewController:optionsController];
    self.optionsPopoverController.delegate = self;
    
    UIViewController* autoStartController = [self.storyboard instantiateViewControllerWithIdentifier:@"AutoStartViewController"];
    self.autoStartPopoverController = [[UIPopoverController alloc] initWithContentViewController:autoStartController];
    self.autoStartPopoverController.delegate = self;
    
    UIViewController* parametersController = [self.storyboard instantiateViewControllerWithIdentifier:@"ParametersViewController"];
    self.parametersPopoverController = [[UIPopoverController alloc] initWithContentViewController:parametersController];
    self.parametersPopoverController.delegate = self;

    

    self.mainToolBar.delegate = self;
    
    [self.lblCount.layer setCornerRadius:8.0f];
    
    [self connectionStatusChangedTo:Disconnected];
    [self resetMessageCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_TAB] != nil)
        self.tabBarController.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_TAB];

}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.tabBarController.selectedIndex forKey:CURRENT_TAB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tabSegue"])
    {
        self.tabBarController = (UITabBarController*)segue.destinationViewController;
    }
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)displayPopover:(UIPopoverController*)controller onButton:(UIBarButtonItem*)button
{
    if (self.currentPopoverController == controller)
    {
        [controller dismissPopoverAnimated:YES];
        self.currentPopoverController = nil;
    }
    else
    {
        [self.currentPopoverController dismissPopoverAnimated:NO];
        self.currentPopoverController = controller;
        
        [controller presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)tryDismissPopover:(UIPopoverController*)controller
{
    if (self.currentPopoverController == controller)
    {
        [controller dismissPopoverAnimated:YES];
        self.currentPopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.currentPopoverController = nil;
}

- (IBAction)displayConnectionView:(id)sender
{
    [self displayPopover:self.connectionPopoverController onButton:self.connectionBtn];
}

- (IBAction)displayLogView:(id)sender
{
    [self displayPopover:self.logPopoverController onButton:self.logBtn];
    if (self.logPopoverController.popoverVisible)
    {
        [self resetMessageCount];
    }
}

- (IBAction)displayOptionsView:(id)sender
{
    [self displayPopover:self.optionsPopoverController onButton:self.optionsBtn];
}

- (IBAction)displayParameters:(id)sender
{
    [self displayPopover:self.parametersPopoverController onButton:self.parametersBtn];
}

- (IBAction)displayAutoStart:(id)sender
{
    [self displayPopover:self.autoStartPopoverController onButton:self.autoStartBtn];
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    switch(status)
    {
        case Lookup:
            self.lblStatus.text = NSLocalizedString(@"Lookup", nil);
            self.autoStartBtn.enabled = NO;
            [self tryDismissPopover:self.autoStartPopoverController];
            self.parametersBtn.enabled = NO;
            [self tryDismissPopover:self.parametersPopoverController];
            break;
        case Disconnected:
            self.lblStatus.text = NSLocalizedString(@"Disconnected", nil);
            self.autoStartBtn.enabled = NO;
            [self tryDismissPopover:self.autoStartPopoverController];
            self.parametersBtn.enabled = NO;
            [self tryDismissPopover:self.parametersPopoverController];
            break;
        case Connected:
            self.lblStatus.text = NSLocalizedString(@"Connected", nil);
            self.autoStartBtn.enabled = YES;
            self.parametersBtn.enabled = NO;
            [self tryDismissPopover:self.parametersPopoverController];
            break;
        case Controlled:
            self.lblStatus.text = NSLocalizedString(@"Controlled", nil);
            self.autoStartBtn.enabled = YES;
            self.parametersBtn.enabled = YES;
            break;
    }
}

- (void)incrementMessageCountBy:(int)value
{
    _messageCount += value;
    if (_messageCount < 99)
        self.lblCount.text = [NSString stringWithFormat:@"%i", _messageCount];
    else
        self.lblCount.text = @"99";
    [self.lblCount setHidden:NO];
}

- (void)resetMessageCount
{
    _messageCount = 0;
    [self.lblCount setHidden:YES];
}

- (void)didReceiveLog:(NSString*) text
{
    [self incrementMessageCountBy:1];
}

- (void)didReceiveServerAnnouncement:(NSString*) message
{
    [self incrementMessageCountBy:1];
}


@end
