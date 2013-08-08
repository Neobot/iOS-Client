//
//  PXGMainToolBarViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMainToolBarViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PXGMainToolBarViewController ()
{
    int _messageCount;
}

@end

@implementation PXGMainToolBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
    
    UIViewController* connectionControler = [self.storyboard instantiateViewControllerWithIdentifier:@"CommViewController"];
    self.connectionPopoverController = [[UIPopoverController alloc] initWithContentViewController:connectionControler];
    
    UIViewController* logController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    self.logPopoverController = [[UIPopoverController alloc] initWithContentViewController:logController];
    
    [self.lblCount.layer setCornerRadius:8.0f];
    
    [self connectionStatusChangedTo:Disconnected];
    [self resetMessageCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)displayConnectionView:(id)sender
{
    if (self.connectionPopoverController.popoverVisible)
    {
        [self.connectionPopoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [self.logPopoverController dismissPopoverAnimated:NO];
        [self.connectionPopoverController presentPopoverFromBarButtonItem:self.connectionBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)displayLogView:(id)sender
{
    if (self.logPopoverController.popoverVisible)
    {
        [self.logPopoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [self.connectionPopoverController dismissPopoverAnimated:NO];
        [self.logPopoverController presentPopoverFromBarButtonItem:self.logBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self resetMessageCount];
    }
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    switch(status)
    {
        case Lookup:
            self.lblStatus.text = NSLocalizedString(@"Lookup", nil);
            break;
        case Disconnected:
            self.lblStatus.text = NSLocalizedString(@"Disconnected", nil);
            break;
        case Connected:
            self.lblStatus.text = NSLocalizedString(@"Connected", nil);
            break;
        case Controlled:
            self.lblStatus.text = NSLocalizedString(@"Controlled", nil);
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
