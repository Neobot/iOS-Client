//
//  PXGSelectAngleViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 07/10/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PXGSelectAngleViewControllerDelegate <NSObject>
- (void)angleSelected:(double)angle;
@end

@interface PXGSelectAngleViewController : UIViewController

@property (nonatomic) int min;
@property (nonatomic) int max;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) id<PXGSelectAngleViewControllerDelegate> delegate;

- (IBAction)onDone:(id)sender;
- (IBAction)onResetToCentralPosition:(id)sender;
- (void)setValue:(double)value animated:(BOOL)animated;

@end
