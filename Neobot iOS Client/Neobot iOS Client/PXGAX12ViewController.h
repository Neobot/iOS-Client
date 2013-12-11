//
//  PXGAX12ViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 28/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"
#import "PXGStickControlView.h"
#import "PXGAX12CollectionViewController.h"
#import "PXGAX12ListTableViewController.h"


@interface PXGAX12ViewController : UIViewController <PXGConnectedViewDelegate, PXGServerInterfaceDelegate, PXGAX12ListTableViewControllerDelegate, PXGAX12CollectionViewControllerProtocol, UISplitViewControllerDelegate>

@property (weak, nonatomic) PXGAX12CollectionViewController* ax12CollectionController;
@property (weak, nonatomic) IBOutlet UISlider *sliderSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UISlider *sliderTorque;
@property (weak, nonatomic) IBOutlet UILabel *lblTorque;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnLockAll;
@property (weak, nonatomic) IBOutlet UIButton *btnReleaseAll;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnShowMovements;
@property (weak, nonatomic) IBOutlet UIToolbar *movementToolBar;

@property (strong, nonatomic) UIPopoverController* movementPopoverController;

- (IBAction)speedChanged;
- (IBAction)torqueChanged;
- (IBAction)onLockAll:(id)sender;
- (IBAction)onReleaseAll:(id)sender;
- (IBAction)onShowMovements:(id)sender;

@end
