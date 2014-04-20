//
//  PXGAX12ViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 28/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12ViewController.h"
#import "PXGStickControlView.h"
#import "PXGParametersKeys.h"

@interface PXGAX12ViewController ()
{
    bool _recordEnabled;
}

@end

@implementation PXGAX12ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _recordEnabled = false;
    
    self.splitViewController.delegate = self;
    
    self.sliderSpeed.value = [[NSUserDefaults standardUserDefaults] floatForKey:AX12_MAX_SPEED];
    self.sliderTorque.value = [[NSUserDefaults standardUserDefaults] floatForKey:AX12_MAX_TORQUE];
    [self speedChanged];
    [self torqueChanged];
    
    self.ax12CollectionController.ax12List = [NSMutableArray array];
    NSArray* list = [[NSUserDefaults standardUserDefaults] objectForKey:AX12_LIST];
    for (NSDictionary* ax12Data in list)
    {
        PXGAX12Data* ax12 = [[PXGAX12Data alloc] initWithDictionary:ax12Data];
        [self.ax12CollectionController.ax12List addObject:ax12];
    }
    
    self.ax12CollectionController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
    
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
    
    UIApplication *app = [UIApplication sharedApplication];
    [self doLayoutForOrientation:app.statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    NSMutableArray* list = [NSMutableArray array];
    for (PXGAX12Data* ax12 in self.ax12CollectionController.ax12List)
    {
        NSDictionary* data = [ax12 encodeToDictionary];
        [list addObject:data];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:AX12_LIST];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self cancelRecursivePositionDemand];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[PXGCommInterface sharedInstance] connectionStatus] == Controlled)
        [self askAllAX12PositionsRecursively:YES];
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    self.btnShowMovements = barButtonItem;
    self.movementPopoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    self.btnShowMovements = nil;
    self.movementPopoverController = nil;
}

- (IBAction)onShowMovements:(id)sender
{
    [self.movementPopoverController presentPopoverFromBarButtonItem:self.btnShowMovements permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)onRecord:(id)sender
{
    NSMutableArray* ax12Ids = [NSMutableArray array];
    NSMutableArray* ax12Positions = [NSMutableArray array];
    for (PXGAX12Data* data in self.ax12CollectionController.ax12List)
    {
        [ax12Ids addObject:[NSNumber numberWithInt:data.ax12ID]];
        [ax12Positions addObject:[NSNumber numberWithFloat:data.position]];
    }
    
    
    [self.delegate recordPositions:ax12Positions forIds:ax12Ids];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self doLayoutForOrientation:toInterfaceOrientation];
}

- (void)doLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
    self.movementToolBar.hidden = !isPortrait;
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    bool ax12Connected = status >= Controlled;
    self.btnLockAll.enabled = ax12Connected;
    self.btnReleaseAll.enabled = ax12Connected;
    self.sliderSpeed.enabled = ax12Connected;
    self.sliderTorque.enabled = ax12Connected;
    
    if (status == Controlled)
        [self askAllAX12PositionsRecursively:YES];
    
    [self.ax12CollectionController setAX12ControlEnabled:status == Controlled];
    [self refreshRecordEnabledState];
}

-(void)setRecordEnabled:(BOOL)enabled
{
    _recordEnabled = enabled;
    [self refreshRecordEnabledState];
}

-(void)refreshRecordEnabledState
{
    self.btnRecord.enabled = self.btnLockAll.enabled && _recordEnabled;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ax12CollectionSegue"])
    {
        self.ax12CollectionController = (PXGAX12CollectionViewController*)segue.destinationViewController;
        
    }
    else if ([segue.identifier isEqualToString:@"ax12ListSegue"])
    {
        UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
        PXGAX12ListTableViewController* controller = (PXGAX12ListTableViewController*)navController.topViewController;
        controller.delegate = self;
        controller.ax12IdList = [NSMutableArray array];
        for (PXGAX12Data* ax12 in self.self.ax12CollectionController.ax12List)
        {
            [controller.ax12IdList addObject:[NSNumber numberWithInt:ax12.ax12ID]];
        }
    }
}

- (void) ax12:(int)ax12ID addedAtRow:(int)row
{
    [self.ax12CollectionController insertAx12:ax12ID atRow:row];
    [self askAllAX12PositionsRecursively:YES];
}

- (void) ax12:(int)ax12ID removedAtRow:(int)row
{
    [self.ax12CollectionController removeAx12:ax12ID atRow:row];
    [self askAllAX12PositionsRecursively:YES];
}

- (void) ax12:(int)ax12ID movedFromRow:(int)fromRow toRow:(int)toRow
{
    [self.ax12CollectionController moveAx12:ax12ID fromRow:fromRow toRow:toRow];
}

- (IBAction)speedChanged
{
    float speed = self.sliderSpeed.value;
    self.lblSpeed.text = [NSString stringWithFormat:@"%.2f%%", speed];
    [[NSUserDefaults standardUserDefaults] setFloat:speed forKey:AX12_MAX_SPEED];
    [self.delegate defaultSpeedChanged:speed];
}

- (IBAction)torqueChanged
{
    float torque = self.sliderTorque.value;
    self.lblTorque.text = [NSString stringWithFormat:@"%.2f%%", torque];
    [[NSUserDefaults standardUserDefaults] setFloat:torque forKey:AX12_MAX_TORQUE];
    [self.delegate defaultTorqueChanged:torque];
}

- (void)setAllAX12Locked:(BOOL)locked
{
    NSMutableArray* idArray = [NSMutableArray array];
    NSMutableArray* lockedInfoArray = [NSMutableArray array];
    
    for (PXGAX12Data* ax12 in self.ax12CollectionController.ax12List)
    {
        [idArray addObject:[NSNumber numberWithInt:ax12.ax12ID]];
        [lockedInfoArray addObject:[NSNumber numberWithBool:locked]];
    }
    
    [[PXGCommInterface sharedInstance] setAX12Ids:idArray lockedInfo:lockedInfoArray];
}

- (void)askAllAX12PositionsRecursively:(BOOL)recursive
{
    NSMutableArray* idArray = [NSMutableArray array];
    
    for (PXGAX12Data* ax12 in self.ax12CollectionController.ax12List)
    {
        [idArray addObject:[NSNumber numberWithInt:ax12.ax12ID]];
    }
    
    [[PXGCommInterface sharedInstance] askPositionsForAX12Ids:idArray recursively:recursive];
}

- (void)cancelRecursivePositionDemand
{
    [[PXGCommInterface sharedInstance] askPositionsForAX12Ids:[NSArray array] recursively:NO];
}

- (IBAction)onLockAll:(id)sender
{
    [self setAllAX12Locked:YES];
}

- (IBAction)onReleaseAll:(id)sender
{
    [self setAllAX12Locked:NO];
}

- (void)speedChanged:(double)speed forAX12:(PXGAX12Data*)ax12
{
    //called every 100ms
    
    double asbSpeed = fabs(speed);
    
    if (ax12.command < 0)
    {
        ax12.command = ax12.position;
    }
    
    if (speed == 0)
    {
        ax12.command = -1;
    }
    else if (asbSpeed > 5.0)
    {
        double diff = ax12.command - ax12.position;
        if (fabs(diff) <= 20.0)
        {
            double rate = 0.0;
            if (asbSpeed < 40)
                rate = 2.0;
            else if (asbSpeed < 70)
                rate = 8;
            else if (asbSpeed < 95)
                rate = 20;
            else
                rate = 30;
            
            double dir = speed < 0 ? -1.0 : 1.0;
            ax12.command = ax12.command + rate * dir;

            struct Ax12Info info[1];
            info[0].id = ax12.ax12ID;
            info[0].angle = ax12.command;
            info[0].speed = 10.0;
            info[0].torque = self.sliderTorque.value;
            
            [[PXGCommInterface sharedInstance] moveAX12:1 of:info];
            
            //NSLog(@"Angle sent: %f", ax12.command);
        }
        else
        {
            //NSLog(@"Too far, diff: %f", diff);
        }
    }
    
}

- (void)lockStatusChanged:(BOOL)locked forAX12:(PXGAX12Data*)ax12
{
    NSArray* idArray = @[[NSNumber numberWithInt:ax12.ax12ID]];
    NSArray* lockedInfoArray = @[[NSNumber numberWithBool:locked]];
    
    [[PXGCommInterface sharedInstance] setAX12Ids:idArray lockedInfo:lockedInfoArray];
}

- (void)commandDefined:(double)command forAX12:(PXGAX12Data*)ax12
{
    struct Ax12Info info[1];
    info[0].id = ax12.ax12ID;
    info[0].angle = command;
    info[0].speed = self.sliderSpeed.value;
    info[0].torque = self.sliderTorque.value;
    
    [[PXGCommInterface sharedInstance] moveAX12:1 of:info];
}

- (void)didReceivePositions:(NSArray*)positions withLoads:(NSArray*)loads forAx12:(NSArray*)ax12Ids
{
    int i = 0;
    for (NSNumber* num in ax12Ids)
    {
        double position = [[positions objectAtIndex:i] floatValue];
        double load = [[loads objectAtIndex:i] floatValue];
        if (position >= 0 && position <= 300)
        {
            [self.ax12CollectionController setPosition:position andLoad:load forAx12:[num intValue]];
        }
        ++i;
    }
}



@end
