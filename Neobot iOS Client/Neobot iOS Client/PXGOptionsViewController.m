//
//  PXGOptionsViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 08/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGOptionsViewController.h"
#import "PXGParametersKeys.h"

@interface PXGOptionsViewController ()

@end

@implementation PXGOptionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.followFingerSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:FOLLOW_THE_FINGER]];

    int delayInMs = [[NSUserDefaults standardUserDefaults] doubleForKey:FOLLOW_THE_FINGER_DELAY] * 1000.0;
    [self.followFingerDelaySlider setValue:delayInMs];
    [self.lblFollowFingerDelay setText:[NSString stringWithFormat:@"%i ms", delayInMs]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)followFingerChanged:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:FOLLOW_THE_FINGER];
}

- (IBAction)followFingerDelayChanged:(UISlider *)sender
{
    [self.lblFollowFingerDelay setText:[NSString stringWithFormat:@"%i ms", (int)sender.value]];
    [[NSUserDefaults standardUserDefaults] setDouble:sender.value/1000.0 forKey:FOLLOW_THE_FINGER_DELAY];
}


@end
