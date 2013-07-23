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
{
    NSArray* _availableSerialPorts;
    UITextField* _editedTextField;
    NSString* _editedRecentUserDefaultKey;
    
    NSTimer* _serverPingTimer;
    NSTimer* _robotPingTimer;
    
    NSDate* _serverPingStartedDate;
    NSDate* _robotPingStartedDate;
}

@end

@implementation PXGCommViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _editedTextField = nil;
        _serverPingTimer = nil;
        _robotPingTimer = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnPingServer setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.btnAskRobotControl setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.btnRobotPing setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
    
    _availableSerialPorts = nil;
    [self connectionStatusChangedTo:Disconnected];
    
    [self setDefaultValueForTextField:self.txtServerAdress withKey:@"RecentIpAdress"];
    [self setDefaultValueForTextField:self.txtPort withKey:@"RecentPorts"];
    [self setDefaultValueForTextField:self.txtRobotSerialPort withKey:@"RecentRobotSerials"];
    [self setDefaultValueForTextField:self.txtAx12SerialPort withKey:@"RecentAx12Serials"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Edition
- (void) setDefaultValueForTextField:(UITextField*)textField withKey:(NSString*)key
{
    NSArray* recentValuesArray = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    if ([recentValuesArray count] > 0)
        textField.text = [recentValuesArray objectAtIndex:0];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    PXGConnectionStatus status = [[PXGCommInterface sharedInstance] connectionStatus];
    
    if ([identifier isEqualToString:@"serverAdressSegue"])
    {
        return status == Disconnected;
    }
    else if ([identifier isEqualToString:@"serverPortSegue"])
    {
        return status == Disconnected;
    }
    else if ([identifier isEqualToString:@"robotSerialSegue"])
    {
        return status == Connected;
    }
    else if ([identifier isEqualToString:@"ax12SerialSegue"])
    {
        return status == Connected;
    }
    
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PXGStringListViewController* controller = (PXGStringListViewController*)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"serverAdressSegue"])
    {
        _editedTextField = self.txtServerAdress;
        _editedRecentUserDefaultKey = @"RecentIpAdress";
        //controller.txtCustomValue.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([segue.identifier isEqualToString:@"serverPortSegue"])
    {
        _editedTextField = self.txtPort;
        _editedRecentUserDefaultKey = @"RecentPorts";
        //controller.txtCustomValue.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([segue.identifier isEqualToString:@"robotSerialSegue"])
    {
        _editedTextField = self.txtRobotSerialPort;
        _editedRecentUserDefaultKey = @"RecentRobotSerials";
        controller.propositions = _availableSerialPorts;
        //controller.txtCustomValue.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else if ([segue.identifier isEqualToString:@"ax12SerialSegue"])
    {
        _editedTextField = self.txtAx12SerialPort;
        _editedRecentUserDefaultKey = @"RecentAx12Serials";
        controller.propositions = _availableSerialPorts;
        //controller.txtCustomValue.keyboardType = UIKeyboardTypeASCIICapable;
    }
    
    NSArray* recentValues = [[NSUserDefaults standardUserDefaults] arrayForKey:_editedRecentUserDefaultKey];
    NSMutableArray* displayedRecentValues = [NSMutableArray arrayWithArray:recentValues];
    if ([displayedRecentValues count] > 0)
        [displayedRecentValues removeObjectAtIndex:0];
    controller.recentlyUsed = displayedRecentValues;
    controller.customValue = _editedTextField.text;
    
    controller.delegate = self;
}

- (void) didSelectString:(NSString*)string
{
    _editedTextField.text = string;
    
    NSArray* recentValues = [[NSUserDefaults standardUserDefaults] arrayForKey:_editedRecentUserDefaultKey];
    NSMutableArray* newRecentsValues = [NSMutableArray arrayWithArray:recentValues];
    if ([newRecentsValues containsObject:string])
        [newRecentsValues removeObject:string];
    
    [newRecentsValues insertObject:string atIndex:0];
    if ([newRecentsValues count] > 5)
        [newRecentsValues removeLastObject];
    
    [[NSUserDefaults standardUserDefaults] setObject:newRecentsValues forKey:_editedRecentUserDefaultKey];
}

- (void) setSelectionForCell:(UITableViewCell*)cell withControl:(UIControl*)control
{
    cell.selectionStyle = control.enabled == YES ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
}

- (void) setIndicatorForCell:(UITableViewCell*)cell withControl:(UIControl*)control
{
    cell.accessoryType = control.enabled == YES ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

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
            [self.btnAskRobotControl setTitle:@"Ask Control" forState:UIControlStateNormal];
            self.btnRobotPing.enabled = NO;
            self.simulationSwitch.enabled = YES;
            
            [[PXGCommInterface sharedInstance] askSerialPorts];
            break;
        case Controlled:
            self.txtServerAdress.enabled = NO;
            self.txtPort.enabled = NO;
            self.btnConnectServer.enabled = NO;
            self.btnPingServer.enabled = YES;
            
            self.txtRobotSerialPort.enabled = NO;
            self.txtAx12SerialPort.enabled = NO;
            self.btnAskRobotControl.enabled = YES;
            [self.btnAskRobotControl setTitle:@"Release Control" forState:UIControlStateNormal];
            self.btnRobotPing.enabled = YES;
            self.simulationSwitch.enabled = NO;
            break;
    };
    
    [self setSelectionForCell:self.cellServerAdress withControl:self.txtServerAdress];
    [self setSelectionForCell:self.cellPort withControl:self.txtPort];
    [self setSelectionForCell:self.cellConnect withControl:self.btnConnectServer];
    [self setSelectionForCell:self.cellPingServer withControl:self.btnPingServer];
    [self setSelectionForCell:self.cellRobotSerialPort withControl:self.txtRobotSerialPort];
    [self setSelectionForCell:self.cellAx12SerialPort withControl:self.txtAx12SerialPort];
    [self setSelectionForCell:self.cellSimulation withControl:self.simulationSwitch];
    [self setSelectionForCell:self.cellAskControl withControl:self.btnAskRobotControl];
    [self setSelectionForCell:self.cellPingRobot withControl:self.btnRobotPing];
    
    [self setIndicatorForCell:self.cellServerAdress withControl:self.txtServerAdress];
    [self setIndicatorForCell:self.cellPort withControl:self.txtPort];
    [self setIndicatorForCell:self.cellRobotSerialPort withControl:self.txtRobotSerialPort];
    [self setIndicatorForCell:self.cellAx12SerialPort withControl:self.txtAx12SerialPort];
    
}


#pragma mark Ping
- (IBAction)pingServer:(id)sender
{
     [[PXGCommInterface sharedInstance] sendPingToServer];
    _serverPingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(didReceivedServerPingTimeout:) userInfo:nil repeats:NO];
    _serverPingStartedDate = [NSDate date];
    self.btnPingServer.enabled = NO;
}

- (void)didReceiveNetworkNoticeOfReceiptForInstruction:(uint8_t)instruction withResult:(BOOL)result
{
    if (instruction == PING_SERVER && _serverPingTimer)
    {
        [_serverPingTimer invalidate];
        _serverPingTimer = nil;
        NSTimeInterval duration = abs([_serverPingStartedDate timeIntervalSinceNow]);
        self.lblServerPing.text = [NSString stringWithFormat:@"%fs", duration];
        [self.tableView reloadData];
        self.btnPingServer.enabled = YES;

        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(didReceivedDisplayServerPingTimeout:) userInfo:nil repeats:NO];
    }
}

- (void)didReceivedServerPingTimeout:(NSTimer*)timer
{
    self.lblServerPing.text = @"timeout...";
    _serverPingTimer = nil;
    self.btnPingServer.enabled = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(didReceivedDisplayServerPingTimeout:) userInfo:nil repeats:NO];
}

- (void)didReceivedDisplayServerPingTimeout:(NSTimer*)timer
{
    [UIView animateWithDuration:0.5
                     animations:^{self.lblServerPing.alpha = 0.0;}
                     completion:^(BOOL finished) {self.lblServerPing.text = @"";self.lblServerPing.alpha = 1;}];
}

- (IBAction)pingRobot:(id)sender
{
    [[PXGCommInterface sharedInstance] sendPingToRobot];
    _robotPingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(didReceivedRobotPingTimeout:) userInfo:nil repeats:NO];
    _robotPingStartedDate = [NSDate date];
    self.btnRobotPing.enabled = NO;
}

- (void)didReceivedRobotPingTimeout:(NSTimer*)timer
{
    self.lblRobotPing.text = @"timeout...";
    _robotPingTimer = nil;
    self.btnRobotPing.enabled = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(didReceivedDisplayRobotPingTimeout:) userInfo:nil repeats:NO];
}


- (void)didReceiveNoticeOfReceiptForInstruction:(uint8_t)instruction withResult:(BOOL)result
{
    if (instruction == PING && _robotPingTimer)
    {
        [_robotPingTimer invalidate];
        _robotPingTimer = nil;
        NSTimeInterval duration = abs([_robotPingStartedDate timeIntervalSinceNow]);
        self.lblRobotPing.text = [NSString stringWithFormat:@"%fs", duration];
        self.btnRobotPing.enabled = YES;
        
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(didReceivedDisplayRobotPingTimeout:) userInfo:nil repeats:NO];
    }
}

- (void)didReceivedDisplayRobotPingTimeout:(NSTimer*)timer
{
    [UIView animateWithDuration:0.5
                     animations:^{self.lblRobotPing.alpha = 0.0;}
                     completion:^(BOOL finished) {self.lblRobotPing.text = @"";self.lblRobotPing.alpha = 1;}];
}

#pragma mark Connection
- (void)didReceiveSerialPortsInfo:(NSArray*)serialports
{
    _availableSerialPorts = serialports;
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

- (IBAction)askRobotControl:(id)sender
{
    if ([[PXGCommInterface sharedInstance] connectionStatus] == Connected)
    {
        [[PXGCommInterface sharedInstance] connectToRobotOnPort:self.txtRobotSerialPort.text withAx12port:self.txtAx12SerialPort.text inSimulationMode:self.simulationSwitch.isOn];
    }
    else if ([[PXGCommInterface sharedInstance] connectionStatus] == Controlled)
        [[PXGCommInterface sharedInstance] disconnectFromRobot];
}

@end
