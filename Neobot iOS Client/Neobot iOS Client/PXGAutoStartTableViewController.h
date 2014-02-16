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

@interface PXGAutoStartTableViewController : UITableViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate, PXGStringViewListControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtStrat;
@property (weak, nonatomic) IBOutlet UITextField *txtRobotSerial;
@property (weak, nonatomic) IBOutlet UITextField *txtAX12Serial;
@property (weak, nonatomic) IBOutlet UITextField *txtStratType;

- (IBAction)onSend:(id)sender;
- (IBAction)onRefresh:(id)sender;

@end
