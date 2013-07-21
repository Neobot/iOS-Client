//
//  PXGCommViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"
#import "PXGStringListViewController.h"

@interface PXGCommViewController : UITableViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate, PXGStringViewListControllerDelegate>

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

@property (weak, nonatomic) IBOutlet UITableViewCell *cellServerAdress;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellPort;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellConnect;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellPingServer;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellRobotSerialPort;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellAx12SerialPort;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellSimulation;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellAskControl;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellPingRobot;

- (IBAction)connectToServer:(id)sender;
- (IBAction)pingServer:(id)sender;
- (IBAction)askRobotControl:(id)sender;
- (IBAction)pingRobot:(id)sender;

@end
