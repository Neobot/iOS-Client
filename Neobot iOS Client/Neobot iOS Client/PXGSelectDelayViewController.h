//
//  PXGSelectDelayViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 23/05/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGSelectDelayViewControllerDelegate <NSObject>
- (void)delayValueSelected:(int)value;
@end

@interface PXGSelectDelayViewController : UIViewController

@property (nonatomic) int min;
@property (nonatomic) int max;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) id<PXGSelectDelayViewControllerDelegate> delegate;

- (IBAction)onDone:(id)sender;
- (void)setValue:(int)value animated:(BOOL)animated;

@end
