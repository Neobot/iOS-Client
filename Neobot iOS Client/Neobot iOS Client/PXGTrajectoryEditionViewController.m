//
//  PXGTrajectoryEditionViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 01/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGTrajectoryEditionViewController.h"
#import "PXGTools.h"

@interface PXGTrajectoryEditionViewController ()
{
    int _editedPointIndex;
    UITableViewCell* _sendActionCell;
}

@end

@implementation PXGTrajectoryEditionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    if ([segue.identifier isEqualToString:@"AddPointSegue"])
    {
        PXGCreatePointViewController* controller = (PXGCreatePointViewController*)segue.destinationViewController;
        controller.delegate = self;
        _editedPointIndex = -1;
    }
    else if ([segue.identifier isEqualToString:@"EditPointSegue"])
    {
        PXGCreatePointViewController* controller = (PXGCreatePointViewController*)segue.destinationViewController;
        controller.delegate = self;
        
        _editedPointIndex = [self.tableView indexPathForSelectedRow].row;
        controller.pointData = [self.trajectoryPoints objectAtIndex:_editedPointIndex];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case PXGTrajectoryNameSection:
            return 1;
        case PXGTrajectoryPointsSection:
            return [self.trajectoryPoints count];
        case PXGTrajectoryAddPointSection:
            return 1;
        case PXGTrajectoryActionsSection:
            return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *txtCellIdentifier = @"txtCell";
    static NSString *pointCellIdentifier = @"pointCell";
    static NSString *actionCellIdentifier = @"actionCell";
    static NSString *newValueCellIdentifier = @"NewValue";
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case PXGTrajectoryNameSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:txtCellIdentifier forIndexPath:indexPath];
            UITextField* txt = (UITextField*)[cell viewWithTag:1];
            txt.delegate = self;
            txt.text = self.trajectoryName;
            break;
        }
        case PXGTrajectoryPointsSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:pointCellIdentifier forIndexPath:indexPath];
            
            NSDictionary* pointData = [self.trajectoryPoints objectAtIndex:indexPath.row];
            double x;
            double y;
            double theta;
            pxgDecodePointData(pointData, &x, &y, &theta);
            
            cell.textLabel.text = [NSString stringWithFormat:@"x=%d y=%d t=%d", (int)x, (int)y, (int)pxgRadiansToDegrees(theta)];
            break;
        }
        case PXGTrajectoryAddPointSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:newValueCellIdentifier forIndexPath:indexPath];
            break;
        }
        case PXGTrajectoryActionsSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:actionCellIdentifier forIndexPath:indexPath];
            if ([self.trajectoryPoints count] == 0)
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            else
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            if (indexPath.row == 0)
                cell.textLabel.text = NSLocalizedString(@"Send", nil);
            
            break;
        }
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case PXGTrajectoryPointsSection:
            if ([self.trajectoryPoints count] > 0)
                return NSLocalizedString(@"Trajectory Content", nil);
    }
    
    return @"";

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == PXGTrajectoryPointsSection;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self.trajectoryPoints removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([self.delegate respondsToSelector:@selector(trajectoryPointsChanged:)])
            [self.delegate trajectoryPointsChanged:self.trajectoryPoints];
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.trajectoryPoints exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(trajectoryPointsChanged:)])
        [self.delegate trajectoryPointsChanged:self.trajectoryPoints];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
   return indexPath.section == PXGTrajectoryPointsSection;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == PXGTrajectoryActionsSection)
    {
        if (indexPath.row == 0)
        {
            //send
            if ([self.delegate respondsToSelector:@selector(sendTrajectory:)])
                [self.delegate sendTrajectory:self.trajectoryPoints];
        }
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
    }
}

- (void) newPointCreatedOnX:(int)x andY:(int)y andTheta:(double)theta
{
    NSDictionary* pointData = pxgEncodePointData(x, y, theta);
    
    if (_editedPointIndex < 0)
    {
        [self.trajectoryPoints addObject:pointData];
    }
    else
    {
        [self.trajectoryPoints replaceObjectAtIndex:_editedPointIndex withObject:pointData];
    }
    
    if ([self.delegate respondsToSelector:@selector(trajectoryPointsChanged:)])
        [self.delegate trajectoryPointsChanged:self.trajectoryPoints];

    
    [self.tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(trajectoryNameChanged:)])
        [self.delegate trajectoryNameChanged:textField.text];
}

@end
