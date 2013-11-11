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
    }
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    BOOL connected = status == Controlled;
    
    self.btnReload.enabled = connected;
    self.btnSave.enabled = connected;
    
    if (connected)
        [self reloadMovements:nil];
}

- (void)didReceiveAx12MovementsFileData:(NSData*)data
{
    [self.movementNavigationController popToRootViewControllerAnimated:YES];
    self.movementManager = [[PXGAX12MovementManager alloc] initWithFile:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
    
    PXGGroupTableViewController* groupController = (PXGGroupTableViewController*)[self.movementNavigationController visibleViewController];
    groupController.groups = self.movementManager.groups;
    
    [groupController.tableView reloadData];
}

- (IBAction)saveMovements:(id)sender
{
}

- (IBAction)reloadMovements:(id)sender
{
    [[PXGCommInterface sharedInstance] askAX12Movements];
}
@end
