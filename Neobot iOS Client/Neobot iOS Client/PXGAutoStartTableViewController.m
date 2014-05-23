//
//  PXGAutoStartTableViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 15/02/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGAutoStartTableViewController.h"
#import "PXGParametersKeys.h"

@interface PXGAutoStartTableViewController ()
{
    NSArray* _availableSerialPorts;
    NSArray* _availableStrategies;
    NSArray* _availableTypes;
    UITextField* _editedTextField;
    NSString* _editedRecentUserDefaultKey;
    
    bool _hasChanges;
}

@property (nonatomic) int delay;

@end

@implementation PXGAutoStartTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasChanges = false;
    _availableSerialPorts = nil;
    _availableTypes = @[@"Robot", @"Simulation", @"Reversed Simulation"];
    [self setDelayValue:20];
    
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self prepareStringSelectionSegue:segue sender:sender];
    [self prepareChoiceSelectionSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"delaySelectionSegue"])
    {
        PXGSelectDelayViewController* controller = (PXGSelectDelayViewController*)segue.destinationViewController;
        controller.delegate = self;
        controller.min = 1;
        controller.max = 999;
        [controller setValue:self.delay animated:NO];
    }
}

- (void)prepareStringSelectionSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    bool found = false;
    
    PXGStringListViewController* controller = (PXGStringListViewController*)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"robotSerialSegue"])
    {
        _editedTextField = self.txtRobotSerial;
        _editedRecentUserDefaultKey = RECENT_ROBOT_SERIALPORTS_KEY;
        controller.propositions = _availableSerialPorts;
        
        found = true;
    }
    else if ([segue.identifier isEqualToString:@"ax12SerialSegue"])
    {
        _editedTextField = self.txtAX12Serial;
        _editedRecentUserDefaultKey = RECENT_AX12_SERIALPORTS_KEY;
        controller.propositions = _availableSerialPorts;
        
        found = true;
    }
    
    
    if (found)
    {
        NSArray* recentValues = [[NSUserDefaults standardUserDefaults] arrayForKey:_editedRecentUserDefaultKey];
        NSMutableArray* displayedRecentValues = [NSMutableArray arrayWithArray:recentValues];
        if ([displayedRecentValues count] > 0)
            [displayedRecentValues removeObjectAtIndex:0];
        controller.recentlyUsed = displayedRecentValues;
        controller.customValue = _editedTextField.text;
        
        controller.delegate = self;
    }
}

- (void)prepareChoiceSelectionSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    bool found = false;
    
    PXGListChoiceViewController* controller = (PXGListChoiceViewController*)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"strategyNameSegue"])
    {
        controller.choices = _availableStrategies;
        _editedTextField = self.txtStrat;
        
        found = true;
    }
    else if ([segue.identifier isEqualToString:@"strategyTypeSegue"])
    {
        controller.choices = _availableTypes;
        _editedTextField = self.txtStratType;
        
        found = true;
    }
    
    if (found)
    {
        [controller setValue:_editedTextField.text];
        controller.delegate = self;
    }

}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    if (status == Connected)
    {
        [[PXGCommInterface sharedInstance] askStrategies];
        [[PXGCommInterface sharedInstance] askSerialPorts];
        [[PXGCommInterface sharedInstance] askAutoStrategyInfo];
    }
}

- (void)setHasChanges:(BOOL)hasChanges
{
    _hasChanges = hasChanges;
    
    NSString* saveBtnText = hasChanges ? @"Send*" : @"Send";
    [self.btnSave setTitle:saveBtnText forState:UIControlStateNormal];
}

- (void)didReceiveSerialPortsInfo:(NSArray*)serialports
{
    _availableSerialPorts = serialports;
}

- (void)didReceiveStrategyNames:(NSArray*)names
{
    _availableStrategies = names;
}

- (void)didReceiveAutoStrategyInfoForStrategy:(int)strategyNum withRobotPort:(NSString*)robotPort withax12Port:(NSString*)ax12port inSimulationMode:(BOOL)simulation inMirrorMode:(BOOL)mirrorMode isEnabled:(BOOL)enabled startingDelayInSeconds:(int)delay
{
    NSString* strategy = [_availableStrategies objectAtIndex:strategyNum];
    self.txtStrat.text = strategy;
    
    self.txtRobotSerial.text = robotPort;
    self.txtAX12Serial.text = ax12port;
    
    NSString* stratType;
    if (!simulation)
		stratType = [_availableTypes objectAtIndex:0];
	else if (mirrorMode)
		stratType = [_availableTypes objectAtIndex:1];
	else
		stratType = [_availableTypes objectAtIndex:2];
    
    self.txtStratType.text = stratType;
    [self.swEnabled setOn:enabled];
    
    [self setDelayValue:delay];
}

- (void)setDelayValue:(int)value
{
    self.delay = value;
    self.lblDelay.text = [NSString stringWithFormat:@"%i second(s)", value];
}

- (void)delayValueSelected:(int)value
{
    [self setDelayValue:value];
    [self setHasChanges:YES];
}

- (void) didSelectString:(NSString*)string
{
    if ([string isEqualToString:_editedTextField.text])
        return;
    
    _editedTextField.text = string;
    [self setHasChanges:YES];
    
    NSArray* recentValues = [[NSUserDefaults standardUserDefaults] arrayForKey:_editedRecentUserDefaultKey];
    NSMutableArray* newRecentsValues = [NSMutableArray arrayWithArray:recentValues];
    if ([newRecentsValues containsObject:string])
        [newRecentsValues removeObject:string];
    
    [newRecentsValues insertObject:string atIndex:0];
    if ([newRecentsValues count] > 5)
        [newRecentsValues removeLastObject];
    
    [[NSUserDefaults standardUserDefaults] setObject:newRecentsValues forKey:_editedRecentUserDefaultKey];
}

- (void) didSelectChoice:(NSString*)string
{
    if ([string isEqualToString:_editedTextField.text])
        return;
    
    _editedTextField.text = string;
    [self setHasChanges:YES];
}

- (IBAction)onEnabledStateChanged:(id)sender
{
    [self setHasChanges:YES];
}

- (IBAction)onSend:(id)sender
{
    [self setHasChanges:NO];
    
    int stratIndex = [_availableStrategies indexOfObject:self.txtStrat.text];
    int type = [_availableTypes indexOfObject:self.txtStratType.text];
    bool simulation = type >= 1; //1 or 2
    bool mirrored = type == 2;
    
    [[PXGCommInterface sharedInstance] setAutoStrategyWithStrategy:stratIndex
                                                     withRobotPort:self.txtRobotSerial.text
                                                      withAx12Port:self.txtAX12Serial.text
                                                  inSimulationMode:simulation ? YES : NO
                                                      inMirrorMode:mirrored ? YES : NO
                                                         isEnabled:self.swEnabled.isOn
                                            startingDelayInSeconds:self.delay];
}

- (IBAction)onRefresh:(id)sender
{
    [[PXGCommInterface sharedInstance] askAutoStrategyInfo];
    [self setHasChanges:NO];
}

@end
