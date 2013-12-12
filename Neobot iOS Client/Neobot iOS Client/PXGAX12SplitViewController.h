//
//  PXGAX12SplitViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGMovementsViewController.h"
#import "PXGAX12ViewController.h"

@class PXGMovementContentTableViewController;

@interface PXGAX12SplitViewController : UISplitViewController <PXGAX12ViewControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) PXGAX12ViewController* ax12Controller;
@property (strong, nonatomic) PXGMovementsViewController* movementController;
@property (weak, nonatomic) PXGMovementContentTableViewController* movementDetailsController;


@end
