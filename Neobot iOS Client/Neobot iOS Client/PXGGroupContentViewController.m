//
//  PXGGroupContentViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGGroupContentViewController.h"
#import "PXGAX12MovementManager.h"

@interface PXGGroupContentViewController ()

@end

@implementation PXGGroupContentViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editIdsSegue"])
    {
        PXGAX12ListTableViewController* controller = (PXGAX12ListTableViewController*)segue.destinationViewController;
        controller.ax12IdList = self.ids;
    }
    else if ([segue.identifier isEqualToString:@"editMovementSegue"])
    {
        int currentEditedIndex = [self.tableView indexPathForSelectedRow].row;
        PXGAX12Movement* mvt = [self.movements objectAtIndex:currentEditedIndex];
     
        PXGMovementContentTableViewController* controller = (PXGMovementContentTableViewController*)segue.destinationViewController;
        controller.name = mvt.name;
        controller.positions = mvt.positions;
        controller.ids = self.ids;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return 2;
        case 1: return self.movements.count;
        case 2: return 1;
    }
    
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Group information";
    
    else if (section == 1 && self.movements.count > 0)
        return @"Movement list";
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *movementCellIdentifier = @"cell";
    static NSString *addCellIdentifier = @"add";
    static NSString *nameCellIdentifier = @"name";
    static NSString *idsCellIdentifier = @"ids";
    UITableViewCell *cell;
    
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:nameCellIdentifier forIndexPath:indexPath];
                UITextField* txt = (UITextField*)[cell.contentView viewWithTag:1];
                txt.text = self.name;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:idsCellIdentifier forIndexPath:indexPath];
                
                NSMutableString* detailedIdList = [NSMutableString stringWithString:@"IDs: "];
                bool isFirst = true;
                for (NSNumber* num in self.ids)
                {
                    if (!isFirst)
                        [detailedIdList appendString:@", "];
                    else
                        isFirst = false;
                    
                    [detailedIdList appendFormat:@"%i", [num intValue]];
                }
                
                cell.textLabel.text = detailedIdList;
            }
            break;
        }
        case 1:
        {
            PXGAX12Movement* mvt = [self.movements objectAtIndex:indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:movementCellIdentifier forIndexPath:indexPath];
            
            cell.textLabel.text = mvt.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i position(s)", mvt.positions.count];
            
            break;
        }
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:addCellIdentifier forIndexPath:indexPath];
            break;
        }
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 1;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        //PXGAX12Movement* removedMvt = [self.movements objectAtIndex:indexPath.row];
        [self.movements removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //if ([self.delegate respondsToSelector:@selector(ax12:removedAtRow:)])
        //    [self.delegate ax12:removedID removedAtRow:indexPath.row];
    }
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
@end
