//
//  PXGMovementsViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMovementsViewController.h"
#import "PXGGroupTableViewController.h"

@interface MovementRunContext : NSObject

@property (strong, nonatomic) NSString* movement;
@property (strong, nonatomic) NSString* group;
@property (nonatomic) int speed;
@property (nonatomic) int lastPositionIndex;

@end

@implementation MovementRunContext
@end

////-------------

@interface PXGMovementsViewController ()

@property (strong, nonatomic) MovementRunContext* currentMovementContext;

@end


@implementation PXGMovementsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hasChanges = false;
    
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.currentMovementContext = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"navigationControllerSegue"])
    {
        self.movementNavigationController = (UINavigationController*)segue.destinationViewController;
        PXGGroupTableViewController* groupController = (PXGGroupTableViewController*)self.movementNavigationController.topViewController;
        groupController.delegate = self;
        groupController.runDelegate = self;
    }
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    BOOL connected = status == Controlled;
    
    self.btnReload.enabled = connected;
    self.btnSave.enabled = connected;
    
    if (connected)
        [self reloadMovements:nil];
    
    [self.movementNavigationController popToRootViewControllerAnimated:YES];
    PXGGroupTableViewController* groupController = (PXGGroupTableViewController*)self.movementNavigationController.topViewController;
    [groupController setEnabled:connected];
}

- (void)didReceiveAx12MovementsFileData:(NSData*)data
{
    [self.movementNavigationController popToRootViewControllerAnimated:YES];
    self.movementManager = [[PXGAX12MovementManager alloc] initWithFile:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
    
    PXGGroupTableViewController* groupController = (PXGGroupTableViewController*)[self.movementNavigationController visibleViewController];
    groupController.groups = self.movementManager.groups;
    
    self.hasChanges = false;
    
    [groupController.tableView reloadData];
}

- (IBAction)saveMovements:(id)sender
{
    NSData* data = [[self.movementManager writeToString] dataUsingEncoding:NSASCIIStringEncoding];
    [[PXGCommInterface sharedInstance] setAX12MovementFile:data];
    self.hasChanges = false;
}

- (IBAction)reloadMovements:(id)sender
{
    [[PXGCommInterface sharedInstance] askAX12Movements];
}

- (void)dataChanged
{
    self.hasChanges = true;
}

- (void)setHasChanges:(BOOL)hasChanges
{
    _hasChanges = hasChanges;
    
    NSString* saveBtnText = hasChanges ? @"Save*" : @"Save";
    [self.btnSave setTitle:saveBtnText forState:UIControlStateNormal];
}

- (void)askSaveMovement
{
    if (self.hasChanges)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to save the movements ?"
                                                        message:@"You need to upload the movements on the server before being able to run them."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
        [alert show];
    }
    else
    {
        [self runCurrentMovementContext];
    }
}

- (void)runCurrentMovementContext
{
    [[PXGCommInterface sharedInstance] runAX12Movement:self.currentMovementContext.movement
                                             fromGroup:self.currentMovementContext.group
                                        withSpeedLimit:self.currentMovementContext.speed
                                       toPositionIndex:self.currentMovementContext.lastPositionIndex];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex] && self.currentMovementContext != nil)
    {
        [self saveMovements:nil];
        [self runCurrentMovementContext];
    }
}

- (void)runMovement:(NSString*)name fromGroup:(NSString*)group withSpeed:(float)speed
{
    if (self.currentMovementContext == nil)
    {
        self.currentMovementContext = [[MovementRunContext alloc] init];
    }
    
    self.currentMovementContext.movement = name;
    self.currentMovementContext.group = group;
    self.currentMovementContext.speed = speed;
    self.currentMovementContext.lastPositionIndex = -1;
    
    [self askSaveMovement];
}

- (void)runMovement:(NSString*)name fromGroup:(NSString*)group withSpeed:(float)speed until:(int)positionIndex
{
    if (self.currentMovementContext == nil)
    {
        self.currentMovementContext = [[MovementRunContext alloc] init];
    }

    self.currentMovementContext.movement = name;
    self.currentMovementContext.group = group;
    self.currentMovementContext.speed = speed;
    self.currentMovementContext.lastPositionIndex = positionIndex;
    
    [self askSaveMovement];
}

@end
