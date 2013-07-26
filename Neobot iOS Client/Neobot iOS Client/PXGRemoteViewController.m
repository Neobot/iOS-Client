//
//  PXGFirstViewController.m
//  Neobot iOS Client
//
//  Created by Thibaud Rabillard on 13/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGRemoteViewController.h"

@interface PXGRemoteViewController ()
{
    NSArray* _strategyNames;
    int _currentStrategy;
    BOOL _currentStrategyIsRunning;
}

@end

@implementation PXGRemoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _strategyNames = nil;
    _currentStrategy = -1;
    _currentStrategyIsRunning = NO;
	
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
    
    UIApplication *app = [UIApplication sharedApplication];
    [self doLayoutForOrientation:app.statusBarOrientation];
    
    [self updateCurrentStrategyGui];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self doLayoutForOrientation:toInterfaceOrientation];
}

- (void)doLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
    self.btnStartStrategy.hidden = !isPortrait;
    self.lblStrategy.hidden = !isPortrait;
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    BOOL robotInteractioEnabled = status == Controlled && !_currentStrategyIsRunning;
    
    self.btnStartStrategy.enabled = robotInteractioEnabled;
    self.btnTeleport.enabled = robotInteractioEnabled;
    self.btnFlush.enabled = robotInteractioEnabled;
    self.btnTrajectory.enabled = robotInteractioEnabled;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"StrategySelectionSegue"])
    {
        if (_currentStrategyIsRunning)
            [[PXGCommInterface sharedInstance] stopStrategy];
        
        return !_currentStrategyIsRunning;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"StrategySelectionSegue"])
    {
        UIStoryboardPopoverSegue* popoverSegue = (UIStoryboardPopoverSegue*)segue;
        PXGStrategySelectionViewController* controller = (PXGStrategySelectionViewController*)segue.destinationViewController;
        
        controller.strategyNames = _strategyNames;
        controller.delegate = self;
        controller.parentPopOverController = popoverSegue.popoverController;
    }
}

- (IBAction)flush:(id)sender
{
    [[PXGCommInterface sharedInstance] sendFlush];
}

- (void)didReceiveRobotPositionX:(int16_t)x  Y:(int16_t)y angle:(double)theta direction:(uint8_t)direction
{
    int td = theta * 180.0 / 3.14116;
    NSString* text = [NSString stringWithFormat:@"x=%d y=%d t=%d", x, y, td];
    self.txtPosition.text = text;
}

- (void)didReceiveRobotObjectiveX:(int16_t)x Y:(int16_t)y angle:(double)theta
{
    int td = theta * 180.0 / M_PI;
    NSString* text = [NSString stringWithFormat:@"x=%d y=%d t=%d", x, y, td];
    self.txtObjective.text = text;
}

- (void)didReceiveStrategyNames:(NSArray*)names
{
    _strategyNames = names;
    [self updateCurrentStrategyGui];
}

- (void)didReceiveStatus:(BOOL)isRunning forStrategy:(int)strategyNum
{
    _currentStrategy = strategyNum;
    _currentStrategyIsRunning = isRunning;
    [self updateCurrentStrategyGui];
}

- (void)updateCurrentStrategyGui
{
    if (_currentStrategyIsRunning && _currentStrategy >= 0 && _currentStrategy < [_strategyNames count])
    {
        [self setCurrentStrategyName: _strategyNames[_currentStrategy]];
        [self.btnStartStrategy setTitle:@"Stop" forState:UIControlStateNormal];
        [self connectionStatusChangedTo:[[PXGCommInterface sharedInstance] connectionStatus]];
        self.btnStartStrategy.enabled = true;
    }
    else
    {
        [self setCurrentStrategyName:@"None"];
        [self.btnStartStrategy setTitle:@"Start" forState:UIControlStateNormal];
        [self connectionStatusChangedTo:[[PXGCommInterface sharedInstance] connectionStatus]];
    }
}

-(void) setCurrentStrategyName:(NSString*)name
{
    self.lblStrategy.text = [NSString stringWithFormat:@"Strategy: %@", name ];
}

- (void) didSelectStrategy:(int)strategyNum
{
    if (!_currentStrategyIsRunning)
    {
        [[PXGCommInterface sharedInstance] startStrategy:strategyNum withMirrorMode:NO];
    }
}


@end
