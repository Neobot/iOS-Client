//
//  PXGOptionsViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 08/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXGOptionsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *followFingerSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowFingerDelay;
@property (weak, nonatomic) IBOutlet UISlider *followFingerDelaySlider;

- (IBAction)followFingerChanged:(UISwitch *)sender;
- (IBAction)followFingerDelayChanged:(UISlider *)sender;

@end
