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
    UITextField* _editedTextField;
    NSString* _editedRecentUserDefaultKey;
}

@end

@implementation PXGAutoStartTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _availableSerialPorts = nil;
    
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
        
        found = true;
    }
    else if ([segue.identifier isEqualToString:@"strategyTypeSegue"])
    {
        controller.choices = @[@"Robot", @"Simulation", @"Reversed Simulation"];
        
        found = true;
    }
    
    
    if (found)
    {
        controller.delegate = self;
    }

}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
}

- (void)didReceiveSerialPortsInfo:(NSArray*)serialports
{
    _availableSerialPorts = serialports;
}

- (void)didReceiveStrategyNames:(NSArray*)names
{
    _availableStrategies = names;
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

- (void) didSelectChoice:(NSString*)string
{
    _editedTextField.text = string;
}

- (IBAction)onSend:(id)sender
{
}

- (IBAction)onRefresh:(id)sender
{
}
@end
