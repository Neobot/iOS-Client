//
//  PXGAX12ViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 28/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGStickControlView.h"

@interface PXGAX12ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *sliderSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UISlider *sliderTorque;
@property (weak, nonatomic) IBOutlet UILabel *lblTorque;

- (IBAction)speedChanged;
- (IBAction)torqueChanged;

@end
