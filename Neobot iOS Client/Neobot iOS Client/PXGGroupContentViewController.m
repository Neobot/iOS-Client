//
//  PXGGroupContentViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGGroupContentViewController.h"
#import "PXGAX12MovementManager.h"
#import "PXGCommInterface.h"

@interface PXGGroupContentViewController ()
{
    int _editedRow;
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editIdsSegue"])
    {
        PXGAX12ListTableViewController* controller = (PXGAX12ListTableViewController*)segue.destinationViewController;
        controller.ax12IdList = self.ids;
        controller.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"editMovementSegue"])
    {
        _editedRow = [self.tableView indexPathForSelectedRow].row;
        PXGAX12Movement* mvt = [self.movements objectAtIndex:_editedRow];
     
        PXGMovementContentTableViewController* controller = (PXGMovementContentTableViewController*)segue.destinationViewController;
        controller.name = mvt.name;
        controller.groupName = self.name;
        controller.positions = mvt.positions;
        controller.ids = self.ids;
        controller.delegate = self;
        controller.runDelegate = self.runDelegate;
    }
    else if ([segue.identifier isEqualToString:@"newMovementSegue"])
    {
        PXGAskNameViewController* controller = (PXGAskNameViewController*)segue.destinationViewController;
        controller.delegate = self;
        [controller setObjectName:@"Movement"];
    }
}

- (void) newNameSelected:(NSString*)name
{
    PXGAX12Movement* mvt = [[PXGAX12Movement alloc] initWithName:name];
    [self.movements addObject:mvt];
    [self.tableView reloadData];
    [self.delegate groupMovementsChanged];
}

- (void)movementNameChanged:(NSString*)name
{
    if (_editedRow >= 0)
    {
        PXGAX12Movement* mvt = [self.movements objectAtIndex:_editedRow];
        mvt.name = name;
        
        [self reloadCurrentRow];
    }
    
    [self.delegate otherDataChanged];
}

- (void)movementPositionsChanged
{
    [self reloadCurrentRow];
    [self.delegate otherDataChanged];
}

#pragma mark - Table view data source

- (void) reloadCurrentRow
{
    if (_editedRow >= 0)
        [self reloadMovementAtRow:_editedRow];
}

- (void)reloadMovementAtRow:(NSInteger)row
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

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
                [txt addTarget:self action:@selector(nameChanged:) forControlEvents:UIControlEventEditingDidEnd];
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

-(void)nameChanged:(UITextField*)textField
{
    [self.delegate groupNameChanged:textField.text];
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
        
        [self.delegate groupMovementsChanged];
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

- (void) ax12:(int)ax12ID addedAtRow:(int)row
{
    [self.delegate groupIdsChanged];
    [self.tableView reloadData];
}

- (void) ax12:(int)ax12ID removedAtRow:(int)row
{
    [self.delegate groupIdsChanged];
    [self.tableView reloadData];
}

- (void) ax12:(int)ax12ID movedFromRow:(int)fromRow toRow:(int)toRow
{
    [self.delegate groupIdsChanged];
    [self.tableView reloadData];
}

@end
