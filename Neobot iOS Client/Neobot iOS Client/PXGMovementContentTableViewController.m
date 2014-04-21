//
//  PXGMovementContentTableViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMovementContentTableViewController.h"
#import "PXGAX12MovementManager.h"
#import "PXGCommInterface.h"

@interface PXGMovementContentTableViewController ()
{
    int _editedRow;
}
@end

@implementation PXGMovementContentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _editedRow = -1;
    
    self.maxSpeed = 100;
    self.maxTorque = 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editPositionSegue"])
    {
        _editedRow = [self.tableView indexPathForSelectedRow].row;
        PXGAX12MovementSinglePosition* singlePos = [self.positions objectAtIndex:_editedRow];
        
        PXGMovementSinglePositionViewController* controller = (PXGMovementSinglePositionViewController*)segue.destinationViewController;
        controller.speed = singlePos.speed;
        controller.torque = singlePos.torque;
        controller.loadLimit = singlePos.loadLimit;
        controller.ids = self.ids;
        controller.positions = singlePos.ax12Positions;
        controller.delegate = self;
    }
}

-(void)positionChanged:(NSArray*)positions speed:(float)speed torque:(float)torque loadLimit:(float)load
{
    PXGAX12MovementSinglePosition* singlePos = [self.positions objectAtIndex:_editedRow];
    singlePos.speed = speed;
    singlePos.torque = torque;
    singlePos.loadLimit = load;
    singlePos.ax12Positions = positions;
    
    [self reloadCurrentRow];
    [self.delegate movementPositionsChanged];
}

- (void)runUntilHere
{
    [self.runDelegate runMovement:self.name fromGroup:self.groupName withSpeed:self.maxSpeed until:_editedRow];
    [self.accessoryPopoverController dismissPopoverAnimated:YES];
}

- (void)moveToPosition
{
    PXGAX12MovementSinglePosition* singlePos = [self.positions objectAtIndex:_editedRow];
    
    struct Ax12Info info[10];
    int i = 0;
    for (NSNumber* ax12IdNum in self.ids)
    {
        info[i].id = [ax12IdNum intValue];
        info[i].angle = [[singlePos.ax12Positions objectAtIndex:i] floatValue];
        info[i].speed = 100;
        info[i].torque = self.maxTorque;
        
        ++i;
        if (i >= 10)
            break;
    }
    
    [[PXGCommInterface sharedInstance] moveAX12:self.ids.count of:info atSmoothedMaxSpeed:self.maxSpeed];

    
    [self.accessoryPopoverController dismissPopoverAnimated:YES];
}

- (IBAction)onRun:(id)sender
{
    [self.runDelegate runMovement:self.name fromGroup:self.groupName withSpeed:self.maxSpeed];
}

#pragma mark - Table view data source

- (void) reloadCurrentRow
{
    if (_editedRow >= 0)
        [self reloadPositionAtRow:_editedRow];
}

- (void)reloadPositionAtRow:(NSInteger)row
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return 1;
        case 1: return self.positions.count;
    }
    
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1 && self.positions.count > 0)
    {
        NSMutableString* detailedIdList = [NSMutableString stringWithString:@"Position list (IDs "];
        bool isFirst = true;
        for (NSNumber* num in self.ids)
        {
            if (!isFirst)
                [detailedIdList appendString:@", "];
            else
                isFirst = false;
            
            [detailedIdList appendFormat:@"%i", [num intValue]];
        }

        [detailedIdList appendString:@")"];
        
        return detailedIdList;
    }
    
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1 && self.positions.count == 0)
    {
        return @"Record new positions from the right panel to create a movement.";
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *nameCellIdentifier = @"name";
    static NSString *posCellIdentifier = @"position";
    
    UITableViewCell *cell;
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:nameCellIdentifier forIndexPath:indexPath];
            UITextField* txt = (UITextField*)[cell.contentView viewWithTag:1];
            txt.text = self.name;
            [txt addTarget:self action:@selector(nameChanged:) forControlEvents:UIControlEventEditingDidEnd];

            break;
        }
        case 1:
        {
            PXGAX12MovementSinglePosition* singlePos = [self.positions objectAtIndex:indexPath.row];
            
            cell = [tableView dequeueReusableCellWithIdentifier:posCellIdentifier forIndexPath:indexPath];
            NSMutableString* posText = [NSMutableString string];
            
            bool isFirst = true;
            for(int i = 0; i < self.ids.count; ++i)
            {
                float value = 0.0;
                if (i < singlePos.ax12Positions.count)
                {
                    NSNumber* pos = [singlePos.ax12Positions objectAtIndex:i];
                    value = [pos floatValue];
                }
                
                if (!isFirst)
                    [posText appendString:@", "];
                else
                    isFirst = false;
                
                [posText appendFormat:@"%i°", (int)value];
            }
            cell.textLabel.text = posText;
            if (singlePos.loadLimit > 0)
                cell.detailTextLabel.text = [NSString stringWithFormat:@"s: %.2f%%, t: %.2f%% l: %.2f%%", singlePos.speed, singlePos.torque, singlePos.loadLimit];
            else
                cell.detailTextLabel.text = [NSString stringWithFormat:@"s: %.2f%%, t: %.2f%%", singlePos.speed, singlePos.torque];
        }
    }
    
    return cell;
}

-(void)nameChanged:(UITextField*)textField
{
    [self.delegate movementNameChanged:textField.text];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 1;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        //PXGAX12MovementSinglePosition* removedPos = [self.positions objectAtIndex:indexPath.row];
        [self.positions removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (self.positions.count == 0)
            [self.tableView reloadData]; //Reload all the table to update the footer view
        
        [self.delegate movementPositionsChanged];
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //PXGAX12MovementSinglePosition* movedPos = [self.positions objectAtIndex:fromIndexPath.row];
    
    PXGAX12MovementSinglePosition* pos = [self.positions objectAtIndex:fromIndexPath.row];
    [self.positions removeObjectAtIndex:fromIndexPath.row];
    [self.positions insertObject:pos atIndex:toIndexPath.row];
    
    [self.delegate movementPositionsChanged];
}

//Restrict move to original section
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
   return indexPath.section == 1;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _editedRow = indexPath.row;
    
    if (self.accessoryPopoverController == nil)
    {
        PXGPositionActionsViewController* contentController = (PXGPositionActionsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PositionActionController"];
        contentController.delegate = self;
        self.accessoryPopoverController = [[UIPopoverController alloc] initWithContentViewController:contentController];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.accessoryPopoverController presentPopoverFromRect:cell.bounds
                                                     inView:cell.contentView
                                   permittedArrowDirections:UIPopoverArrowDirectionLeft
                                                   animated:YES];
}

- (IBAction)onEdit:(id)sender
{
    if (!self.tableView.editing)
    {
        self.btnEdit.style = UIBarButtonItemStyleDone;
        self.btnEdit.title = NSLocalizedString(@"Done", nil);
        [self.tableView setEditing:YES animated:YES];
    }
    else
    {
        self.btnEdit.style = UIBarButtonItemStyleBordered;
        self.btnEdit.title = NSLocalizedString(@"Edit", nil);
        [self.tableView setEditing:NO animated:YES];
    }
}

- (void)recordPositions:(NSArray*)positions forIds:(NSArray*)ids
{
    NSMutableArray* pos = [NSMutableArray array];
    for (NSNumber* ax12ID in self.ids)
    {
        int idIndex = [ids indexOfObject:ax12ID];
        if (idIndex != NSNotFound)
        {
            [pos addObject:[positions objectAtIndex:idIndex]];
        }
        else
        {
            [pos addObject:[NSNumber numberWithFloat:0.0]];
        }
    }
    
    
    PXGAX12MovementSinglePosition* singlePosition = [[PXGAX12MovementSinglePosition alloc] initWithSpeed:self.maxSpeed torque:self.maxTorque loadLimit:0.0 andPositions:pos];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.positions.count inSection:1];

    [self.positions addObject:singlePosition];
    
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.positions.count == 1)
        [self.tableView reloadData]; //Reload all the table to update the footer view
    
    [self.delegate movementPositionsChanged];
}

@end
