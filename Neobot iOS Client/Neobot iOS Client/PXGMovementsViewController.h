//
//  PXGMovementsViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"
#import "PXGAX12MovementManager.h"

@interface PXGMovementsViewController : UIViewController <PXGConnectedViewDelegate, PXGServerInterfaceDelegate>

@property (strong, nonatomic) PXGAX12MovementManager* movementManager;
@property (strong, nonatomic) UINavigationController* movementNavigationController;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnReload;

- (IBAction)saveMovements:(id)sender;
- (IBAction)reloadMovements:(id)sender;


@end
