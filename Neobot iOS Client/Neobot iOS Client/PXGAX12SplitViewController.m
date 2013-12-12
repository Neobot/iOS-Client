//
//  PXGAX12SplitViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12SplitViewController.h"
#import "PXGMovementContentTableViewController.h"


@interface PXGAX12SplitViewController ()

@end

@implementation PXGAX12SplitViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

	self.ax12Controller = [self.viewControllers objectAtIndex:1];
    self.ax12Controller.delegate = self;
    
    self.movementController = [self.viewControllers objectAtIndex:0];
    self.movementController.movementNavigationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[PXGMovementContentTableViewController class]])
    {
        self.movementDetailsController = (PXGMovementContentTableViewController*)viewController;
        [self.ax12Controller setRecordEnabled:YES];
        [self defaultSpeedChanged:self.ax12Controller.sliderSpeed.value];
        [self defaultTorqueChanged:self.ax12Controller.sliderTorque.value];
    }
    else
    {
        self.movementDetailsController = nil;
        [self.ax12Controller setRecordEnabled:NO];
    }
}

- (void)recordPositions:(NSArray*)positions forIds:(NSArray*)ids
{
    [self.movementDetailsController recordPositions:positions forIds:ids];
}

- (void)defaultSpeedChanged:(float)speed
{
    self.movementDetailsController.maxSpeed = speed;
}

- (void)defaultTorqueChanged:(float)torque
{
    self.movementDetailsController.maxTorque = torque;
}

@end
