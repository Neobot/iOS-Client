//
//  PXGAutoStartTableViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 15/02/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"
#import "PXGStringListViewController.h"
#import "PXGListChoiceViewController.h"
#import "PXGSelectDelayViewController.h"

@interface PXGAutoStartTableViewController : UITableViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate, PXGStringViewListControllerDelegate, PXGListChoiceViewControllerDelegate, PXGSelectDelayViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txtStrat;
@property (weak, nonatomic) IBOutlet UITextField *txtRobotSerial;
@property (weak, nonatomic) IBOutlet UITextField *txtAX12Serial;
@property (weak, nonatomic) IBOutlet UITextField *txtStratType;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UISwitch *swEnabled;
@property (weak, nonatomic) IBOutlet UILabel *lblDelay;

- (IBAction)onSend:(id)sender;
- (IBAction)onRefresh:(id)sender;
- (IBAction)onEnabledStateChanged:(id)sender;

@end
