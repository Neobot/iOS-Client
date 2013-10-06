//
//  PXGAX12ListTableViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 06/10/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12ListTableViewController.h"

@interface PXGAX12ListTableViewController ()

@end

@implementation PXGAX12ListTableViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
        return 1;
    
    return self.ax12IdList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    static NSString *addCellIdentifier = @"addNewCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0)
    {
        int ax12ID = [[self.ax12IdList objectAtIndex:indexPath.row] intValue];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"N°%i", ax12ID];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:addCellIdentifier forIndexPath:indexPath];
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
        int removedID = [[self.ax12IdList objectAtIndex:indexPath.row] intValue];
        [self.ax12IdList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([self.delegate respondsToSelector:@selector(ax12:removedAtRow:)])
            [self.delegate ax12:removedID removedAtRow:indexPath.row];
    } 
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    int movedID = [[self.ax12IdList objectAtIndex:fromIndexPath.row] intValue];
    
    id obj = [self.ax12IdList objectAtIndex:fromIndexPath.row];
    [self.ax12IdList removeObjectAtIndex:fromIndexPath.row];
    [self.ax12IdList insertObject:obj atIndex:toIndexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(ax12:movedFromRow:toRow:)])
        [self.delegate ax12:movedID movedFromRow:fromIndexPath.row toRow:toIndexPath.row];

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
    return indexPath.section == 0;
}

- (void)ax12Added:(int)ax12ID
{
    [self.ax12IdList addObject:[NSNumber numberWithInt:ax12ID]];
    NSIndexPath* insertedPath = [NSIndexPath indexPathForRow:self.ax12IdList.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:insertedPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if ([self.delegate respondsToSelector:@selector(ax12:addedAtRow:)])
        [self.delegate ax12:ax12ID addedAtRow:insertedPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addAX12Segue"])
    {
        PXGAddAX12ViewController* controller = (PXGAddAX12ViewController*)segue.destinationViewController;
        controller.delegate = self;
        controller.alreadyUsedIds = self.ax12IdList;
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
