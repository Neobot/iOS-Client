//
//  PXGCommViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGCommViewController.h"
#import "PXGInstructions.h"

@interface PXGCommViewController ()

@end

@implementation PXGCommViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
    [self connectionStatusChangedTo:Disconnected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    switch(status)
    {
        case Lookup:
            self.txtServerAdress.enabled = NO;
            self.txtPort.enabled = NO;
            self.btnConnectServer.enabled = NO;
            self.btnPingServer.enabled = NO;
            
            self.txtRobotSerialPort.enabled = NO;
            self.txtAx12SerialPort.enabled = NO;
            self.btnAskRobotControl.enabled = NO;
            self.btnRobotPing.enabled = NO;
            self.simulationSwitch.enabled = NO;
            break;
        case Disconnected:
            self.txtServerAdress.enabled = YES;
            self.txtPort.enabled = YES;
            self.btnConnectServer.enabled = YES;
            [self.btnConnectServer setTitle:@"Connect" forState:UIControlStateNormal];
            self.btnPingServer.enabled = NO;
            
            self.txtRobotSerialPort.enabled = NO;
            self.txtAx12SerialPort.enabled = NO;
            self.btnAskRobotControl.enabled = NO;
            self.btnRobotPing.enabled = NO;
            self.simulationSwitch.enabled = NO;
            break;
        case Connected:
            self.txtServerAdress.enabled = NO;
            self.txtPort.enabled = NO;
            self.btnConnectServer.enabled = YES;
            [self.btnConnectServer setTitle:@"Disconnect" forState:UIControlStateNormal];
            self.btnPingServer.enabled = YES;
            
            self.txtRobotSerialPort.enabled = YES;
            self.txtAx12SerialPort.enabled = YES;
            self.btnAskRobotControl.enabled = YES;
            self.btnRobotPing.enabled = NO;
            self.simulationSwitch.enabled = YES;
            break;
        case Controlled:
            self.txtServerAdress.enabled = NO;
            self.txtPort.enabled = NO;
            self.btnConnectServer.enabled = NO;
            self.btnPingServer.enabled = YES;
            
            self.txtRobotSerialPort.enabled = NO;
            self.txtAx12SerialPort.enabled = NO;
            self.btnAskRobotControl.enabled = YES;
            self.btnRobotPing.enabled = YES;
            self.simulationSwitch.enabled = NO;
            break;
    }
}


- (IBAction)connectToServer:(id)sender
{
    if ([[PXGCommInterface sharedInstance] connectionStatus] == Disconnected)
    {
        UInt16 port = [self.txtPort.text intValue];
        [[PXGCommInterface sharedInstance] connectToServer:self.txtServerAdress.text onPort:port  withTimeout:5.0 error:nil];
    }
    else
        [[PXGCommInterface sharedInstance] disconnectFromServer];
}

- (IBAction)pingServer:(id)sender
{
     [[PXGCommInterface sharedInstance] sendPingToServer];
}

- (IBAction)askRobotControl:(id)sender
{
    if ([[PXGCommInterface sharedInstance] connectionStatus] == Connected)
    {
        [[PXGCommInterface sharedInstance] connectToRobotOnPort:self.txtRobotSerialPort.text withAx12port:self.txtAx12SerialPort.text inSimulationMode:self.simulationSwitch.isOn];
    }
    else if ([[PXGCommInterface sharedInstance] connectionStatus] == Controlled)
        [[PXGCommInterface sharedInstance] disconnectFromRobot];
}

- (IBAction)pingRobot:(id)sender
{
    [[PXGCommInterface sharedInstance] sendPingToRobot];
}


- (void)didReceiveNoticeOfReceiptForInstruction:(uint8_t)instruction withResult:(BOOL)result
{
    if (instruction == PING)
    {
       
    }
}

- (void)didReceiveNetworkNoticeOfReceiptForInstruction:(uint8_t)instruction withResult:(BOOL)result
{
    if (instruction == PING_SERVER)
    {
        self.lblPingResult.text = @"ok";
    }
}

@end
