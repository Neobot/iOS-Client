//
//  PXGFirstViewController.m
//  Neobot iOS Client
//
//  Created by Thibaud Rabillard on 13/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGRemoteViewController.h"
#import "PXGParametersKeys.h"
#import "PXGTools.h"

@interface PXGRemoteViewController ()
{
    NSArray* _strategyNames;
    int _currentStrategy;
    BOOL _currentStrategyIsRunning;
    
    __weak UIPopoverController* _currentTeleportPopoverController;
}

@end

@implementation PXGRemoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentTeleportPopoverController = nil;
    
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

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (_currentTeleportPopoverController == popoverController)
        _currentTeleportPopoverController = nil;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"StrategySelectionSegue"])
    {
        if (_currentStrategyIsRunning)
            [[PXGCommInterface sharedInstance] stopStrategy];
        
        return !_currentStrategyIsRunning;
    }
    else if ([identifier isEqualToString:@"TeleportPopoverSegue"])
    {
        if (_currentTeleportPopoverController)
        {
            [_currentTeleportPopoverController dismissPopoverAnimated:YES];
            _currentTeleportPopoverController = nil;
            return NO;
        }
        else
            return YES;
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
    else if ([segue.identifier isEqualToString:@"TeleportPopoverSegue"])
    {
        UIStoryboardPopoverSegue* popoverSegue = (UIStoryboardPopoverSegue*)segue;
        UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
        PXGTeleportViewController* teleportController = (PXGTeleportViewController*)navController.topViewController;
        teleportController.parentPopOverController = popoverSegue.popoverController;
        _currentTeleportPopoverController = popoverSegue.popoverController;
        popoverSegue.popoverController.delegate = self;
        teleportController.delegate = self;
        
        NSArray* values = [[NSUserDefaults standardUserDefaults] arrayForKey:TELEPORT_POSITIONS_KEY];
        //if ([values count] == 0)
        {
            NSMutableArray* defaultValues = [NSMutableArray array];
            [defaultValues addObject:pxgEncodePointData(0, 0, 0)];
            [defaultValues addObject:pxgEncodePointData(0, 0, M_PI_2)];
            [defaultValues addObject:pxgEncodePointData(250, 250, M_PI_2)];
            [defaultValues addObject:pxgEncodePointData(250, 2750, -M_PI_2)];
            values = defaultValues;
            [[NSUserDefaults standardUserDefaults] setValue:defaultValues forKey:TELEPORT_POSITIONS_KEY];
        }
        
        teleportController.positions = values;
    }
}

- (IBAction)flush:(id)sender
{
    [[PXGCommInterface sharedInstance] sendFlush];
}

- (void)didReceiveRobotPositionX:(int16_t)x  Y:(int16_t)y angle:(double)theta direction:(uint8_t)direction
{
    int td = pxgRadiansToDegrees(theta);
    NSString* text = [NSString stringWithFormat:@"x=%d y=%d t=%d", x, y, td];
    self.txtPosition.text = text;
}

- (void)didReceiveRobotObjectiveX:(int16_t)x Y:(int16_t)y angle:(double)theta
{
    int td = pxgRadiansToDegrees(theta);
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

- (void) teleportPositionSelected:(NSDictionary*)position among:(NSArray*)positions
{
    int x, y;
    double theta;
    pxgDecodePointData(position, &x, &y, &theta);
    
    [[PXGCommInterface sharedInstance] sendTeleportRobotInX:x Y:y angle:theta];
    [[NSUserDefaults standardUserDefaults] setValue:positions forKey:TELEPORT_POSITIONS_KEY];
    _currentTeleportPopoverController = nil;
}


@end
