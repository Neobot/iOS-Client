//
//  PXGPositionActionsViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 09/12/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGPositionActionsViewController.h"

@interface PXGPositionActionsViewController ()

@end

@implementation PXGPositionActionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runUntilHere:(id)sender
{
    [self.delegate runUntilHere];
}

- (IBAction)moveToPosition:(id)sender
{
    [self.delegate moveToPosition];
}
@end
