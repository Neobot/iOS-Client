//
//  PXGMainToolBarViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMainToolBarViewController.h"

@interface PXGMainToolBarViewController ()

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
    UIViewController* connectionControler = [self.storyboard instantiateViewControllerWithIdentifier:@"CommViewController"];
    self.connectionPopoverController = [[UIPopoverController alloc] initWithContentViewController:connectionControler];
    
    UIViewController* logController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    self.logPopoverController = [[UIPopoverController alloc] initWithContentViewController:logController];
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
    }
}
@end
