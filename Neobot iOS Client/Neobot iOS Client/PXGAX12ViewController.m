//
//  PXGAX12ViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 28/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12ViewController.h"
#import "PXGStickControlView.h"
#import "PXGParametersKeys.h"

@interface PXGAX12ViewController ()

@end

@implementation PXGAX12ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sliderSpeed.value = [[NSUserDefaults standardUserDefaults] floatForKey:AX12_MAX_SPEED];
    self.sliderTorque.value = [[NSUserDefaults standardUserDefaults] floatForKey:AX12_MAX_TORQUE];
    [self speedChanged];
    [self torqueChanged];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)speedChanged
{
    int speed = self.sliderSpeed.value;
    self.lblSpeed.text = [NSString stringWithFormat:@"%i%%", speed];
    [[NSUserDefaults standardUserDefaults] setFloat:self.sliderSpeed.value forKey:AX12_MAX_SPEED];
}

- (IBAction)torqueChanged
{
    int torque = self.sliderTorque.value;
    self.lblTorque.text = [NSString stringWithFormat:@"%i%%", torque];
    [[NSUserDefaults standardUserDefaults] setFloat:self.sliderTorque.value forKey:AX12_MAX_TORQUE];
}

@end
