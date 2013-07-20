//
//  PXGCommViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"

@interface PXGCommViewController : UITableViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtServerAdress;
@property (weak, nonatomic) IBOutlet UITextField *txtPort;
@property (weak, nonatomic) IBOutlet UIButton *btnConnectServer;
@property (weak, nonatomic) IBOutlet UIButton *btnPingServer;
@property (weak, nonatomic) IBOutlet UILabel *lblPingResult;

@property (weak, nonatomic) IBOutlet UITextField *txtRobotSerialPort;
@property (weak, nonatomic) IBOutlet UITextField *txtAx12SerialPort;
@property (weak, nonatomic) IBOutlet UIButton *btnAskRobotControl;
@property (weak, nonatomic) IBOutlet UIButton *btnRobotPing;
@property (weak, nonatomic) IBOutlet UISwitch *simulationSwitch;

- (IBAction)connectToServer:(id)sender;
- (IBAction)pingServer:(id)sender;
- (IBAction)askRobotControl:(id)sender;
- (IBAction)pingRobot:(id)sender;

@end
