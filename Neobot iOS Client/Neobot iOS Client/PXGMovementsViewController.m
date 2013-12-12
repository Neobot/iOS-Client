//
//  PXGMovementsViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMovementsViewController.h"
#import "PXGGroupTableViewController.h"

@interface PXGMovementsViewController ()

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
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"navigationControllerSegue"])
    {
        self.movementNavigationController = (UINavigationController*)segue.destinationViewController;
        PXGGroupTableViewController* groupController = (PXGGroupTableViewController*)self.movementNavigationController.topViewController;
        groupController.delegate = self;
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

@end
