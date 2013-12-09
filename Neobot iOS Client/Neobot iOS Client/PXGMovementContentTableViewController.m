//
//  PXGMovementContentTableViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMovementContentTableViewController.h"
#import "PXGAX12MovementManager.h"

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)runUntilHere
{
    PXGAX12MovementSinglePosition* singlePos = [self.positions objectAtIndex:_editedRow];
    //TODO

}

- (void)moveToPosition
{
    PXGAX12MovementSinglePosition* singlePos = [self.positions objectAtIndex:_editedRow];
    //TODO
}

#pragma mark - Table view data source

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
        NSMutableString* detailedIdList = [NSMutableString stringWithString:@"Position list (AX-12 "];
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
            for (NSNumber* pos in singlePos.ax12Positions)
            {
                if (!isFirst)
                    [posText appendString:@", "];
                else
                    isFirst = false;
                
                [posText appendFormat:@"%i°", [pos intValue]];
            }
            cell.textLabel.text = posText;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"speed: %.2f%%, torque: %.2f%%", singlePos.speed, singlePos.torque];
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
        
        //if ([self.delegate respondsToSelector:@selector(ax12:removedAtRow:)])
        //    [self.delegate ax12:removedID removedAtRow:indexPath.row];
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //PXGAX12MovementSinglePosition* movedPos = [self.positions objectAtIndex:fromIndexPath.row];
    
    PXGAX12MovementSinglePosition* pos = [self.positions objectAtIndex:fromIndexPath.row];
    [self.positions removeObjectAtIndex:fromIndexPath.row];
    [self.positions insertObject:pos atIndex:toIndexPath.row];
    
    //if ([self.delegate respondsToSelector:@selector(ax12:movedFromRow:toRow:)])
      //  [self.delegate ax12:movedID movedFromRow:fromIndexPath.row toRow:toIndexPath.row];
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

@end
