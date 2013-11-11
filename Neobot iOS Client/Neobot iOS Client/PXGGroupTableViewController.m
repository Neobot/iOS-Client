//
//  PXGGroupTableViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGGroupTableViewController.h"
#import "PXGAX12MovementManager.h"

@interface PXGGroupTableViewController ()

@end

@implementation PXGGroupTableViewController

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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editGroupSegue"])
    {
        int currentEditedIndex = [self.tableView indexPathForSelectedRow].row;
        PXGAX12MovementGroup* group = [self.groups objectAtIndex:currentEditedIndex];
        
        PXGGroupContentViewController* controller = (PXGGroupContentViewController*)segue.destinationViewController;
        controller.name = group.name;
        controller.ids = group.ids;
        controller.movements = group.movements;
    }
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
        case 0:
            return self.groups.count;
        case 1:
            return 1;
    }
    
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.groups.count > 0)
        return @"Available groups";
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *groupCellIdentifier = @"cell";
    static NSString *addCellIdentifier = @"add";
    
    UITableViewCell *cell;
    switch (indexPath.section)
    {
        case 0:
        {
            PXGAX12MovementGroup* group = [self.groups objectAtIndex:indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:groupCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = group.name;
            
            NSMutableString* detailedIdList = [NSMutableString stringWithString:@"IDs: "];
            bool isFirst = true;
            for (NSNumber* num in group.ids)
            {
                if (!isFirst)
                    [detailedIdList appendString:@", "];
                else
                    isFirst = false;
                
                [detailedIdList appendFormat:@"%i", [num intValue]];
            }
            
            cell.detailTextLabel.text = detailedIdList;
            break;
        }
       case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:addCellIdentifier forIndexPath:indexPath];
            break;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        //PXGAX12MovementGroup* removedGroup = [self.groups objectAtIndex:indexPath.row];
        [self.groups removeObjectAtIndex:indexPath.row];
        
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
