//
//  PXGCreatePointViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGCreatePointViewControllerDelegate <NSObject>
- (void) newPointCreatedOnX:(int)x andY:(int)y andTheta:(double)theta;
@end

@interface PXGCreatePointViewController : UITableViewController

@property (weak, nonatomic) IBOutlet NSDictionary *pointData;

@property (weak, nonatomic) IBOutlet UITextField *txtXValue;
@property (weak, nonatomic) IBOutlet UITextField *txtYValue;
@property (weak, nonatomic) IBOutlet UITextField *txtThetaValue;

@property (strong, nonatomic) id<PXGCreatePointViewControllerDelegate> delegate;
- (IBAction)nextEditionAfterX:(id)sender;
- (IBAction)nextEditionAfterY:(id)sender;

- (IBAction)pointCreationDone:(id)sender;

@end
