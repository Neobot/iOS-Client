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
    
    UIPopoverController* _currentTeleportPopoverController;
    UIPopoverController* _currentTrajectoryPopoverController;
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
    
    int speed = [[[NSUserDefaults standardUserDefaults] valueForKey:TRAJECTORY_SPEED] intValue];
    self.speedSlider.value = speed;
    self.lblSpeedValue.text = [NSString stringWithFormat:@"%i%%", speed];
    
    self.lblPosition.text = @"Unknown";
    self.lblObjective.text = @"Unknown";
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
    self.speedSlider.hidden = !isPortrait;
    self.lblSpeedTitle.hidden = !isPortrait;
    self.lblSpeedValue.hidden = !isPortrait;
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    BOOL robotInteractioEnabled = status == Controlled && !_currentStrategyIsRunning;
    
    self.btnStartStrategy.enabled = robotInteractioEnabled;
    self.btnTeleport.enabled = robotInteractioEnabled;
    self.btnFlush.enabled = robotInteractioEnabled;
    self.btnTrajectory.enabled = robotInteractioEnabled;
    self.speedSlider.enabled = robotInteractioEnabled;
    self.mapController.robotControlEnabled = robotInteractioEnabled;
    
    if (!robotInteractioEnabled)
    {
        self.lblPosition.text = @"Unknown";
        self.lblObjective.text = @"Unknown";
    }
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
        if (_currentTrajectoryPopoverController && _currentTrajectoryPopoverController.isPopoverVisible)
            [_currentTrajectoryPopoverController dismissPopoverAnimated:NO];
        
        if (_currentTeleportPopoverController)
        {
            if (_currentTeleportPopoverController.isPopoverVisible)
                [_currentTeleportPopoverController dismissPopoverAnimated:YES];
            else
                [_currentTeleportPopoverController presentPopoverFromRect:self.btnTeleport.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            return NO;
        }
        else
            return YES;
    }
    else if ([identifier isEqualToString:@"TrajetoriesPopoverSegue"])
    {
        if (_currentTeleportPopoverController && _currentTeleportPopoverController.isPopoverVisible)
            [_currentTeleportPopoverController dismissPopoverAnimated:NO];
        
        if (_currentTrajectoryPopoverController)
        {
            if (_currentTrajectoryPopoverController.isPopoverVisible)
                [_currentTrajectoryPopoverController dismissPopoverAnimated:YES];
            else
                 [_currentTrajectoryPopoverController presentPopoverFromRect:self.btnTrajectory.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
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
        teleportController.delegate = self;
        
        NSArray* values = [[NSUserDefaults standardUserDefaults] arrayForKey:TELEPORT_POSITIONS_KEY];
        if ([values count] == 0)
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
    else if ([segue.identifier isEqualToString:@"TrajetoriesPopoverSegue"])
    {
        UIStoryboardPopoverSegue* popoverSegue = (UIStoryboardPopoverSegue*)segue;
        UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
        PXGTrajectoriesViewController* trajController = (PXGTrajectoriesViewController*)navController.topViewController;
        trajController.parentPopOverController = popoverSegue.popoverController;
        _currentTrajectoryPopoverController = popoverSegue.popoverController;
        trajController.delegate = self;
        
        NSArray* trajectortiesData = [[NSUserDefaults standardUserDefaults] arrayForKey:DEFINED_TRAJECTORIES_KEY];
        trajController.trajectories = [NSMutableArray arrayWithArray:trajectortiesData];
    }
    else if ([segue.identifier isEqualToString:@"MapSegue"])
    {
        self.mapController = (PXGMapViewController*)segue.destinationViewController;
        self.mapController.delegate = self;
    }
}

- (IBAction)flush:(id)sender
{
    [[PXGCommInterface sharedInstance] sendFlush];
}

- (IBAction)speedSliderChanged:(UISlider *)sender
{
    int speed = sender.value;
    self.lblSpeedValue.text = [NSString stringWithFormat:@"%i%%", speed];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:speed]  forKey:TRAJECTORY_SPEED];
}

- (void)didReceiveRobotPositionX:(int16_t)x  Y:(int16_t)y angle:(double)theta direction:(uint8_t)direction
{
    int td = pxgRadiansToDegrees(theta);
    NSString* text = [NSString stringWithFormat:@"x=%d y=%d t=%d", x, y, td];
    self.lblPosition.text = text;
    
    [self.mapController setRobotPositionAtX:x Y:y theta:theta];
}

- (void)didReceiveRobotObjectiveX:(int16_t)x Y:(int16_t)y angle:(double)theta
{
    int td = pxgRadiansToDegrees(theta);
    NSString* text = [NSString stringWithFormat:@"x=%d y=%d t=%d", x, y, td];
    self.lblObjective.text = text;
    
    [self.mapController setObjectivePositionAtX:x Y:y theta:theta];
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

- (void) teleportPositionSelected:(NSDictionary*)position
{
    double x, y;
    double theta;
    pxgDecodePointData(position, &x, &y, &theta);
    
    [[PXGCommInterface sharedInstance] sendTeleportRobotInX:x Y:y angle:theta];
}

- (void) availableTeleportPositionsChanged:(NSArray*)positions
{
    [[NSUserDefaults standardUserDefaults] setValue:positions forKey:TELEPORT_POSITIONS_KEY];
}


- (void) sendTrajectory:(NSArray*)trajectoryPoints
{   
    int nbPoints = [trajectoryPoints count];
    
    [_currentTrajectoryPopoverController dismissPopoverAnimated:YES];
    
    int curentPointIndex = 0;
    int speed = self.speedSlider.value;
    
    for (NSDictionary* pointData in trajectoryPoints)
    { 
        ++curentPointIndex;
        
        double x, y;
        double theta;
        pxgDecodePointData(pointData, &x, &y, &theta);
        
        [[PXGCommInterface sharedInstance] sendRobotInX:x
                                                      Y:y
                                                  angle:theta
                                     withTrajectoryType:AUTO
                                         withAsservType:TURN_THEN_MOVE
                                              withSpeed:speed
                                            isStopPoint:(curentPointIndex == nbPoints)];
    }
}

- (void) availableTrajectoriesChanged:(NSArray*)trajectories
{
    [[NSUserDefaults standardUserDefaults] setValue:trajectories forKey:DEFINED_TRAJECTORIES_KEY];
}

- (void) sendMapPoint:(PXGRPoint*)point
{
    int speed = self.speedSlider.value;

    [[PXGCommInterface sharedInstance] sendRobotInX:point.x
        Y:point.y
        angle:point.theta
        withTrajectoryType:AUTO
        withAsservType:TURN_THEN_MOVE
        withSpeed:speed
        isStopPoint:YES];
    
}

- (void) sendMapTrajectory:(NSArray*)trajectoryPoints
{
    int nbPoints = [trajectoryPoints count];
    
    int curentPointIndex = 0;
    int speed = self.speedSlider.value;
    
    for (PXGRPoint* point in trajectoryPoints)
    {
        ++curentPointIndex;
        
        [[PXGCommInterface sharedInstance] sendRobotInX:point.x
                                                      Y:point.y
                                                  angle:point.theta
                                     withTrajectoryType:AUTO
                                         withAsservType:TURN_THEN_MOVE
                                              withSpeed:speed
                                            isStopPoint:(curentPointIndex == nbPoints)];
    }

}

@end
