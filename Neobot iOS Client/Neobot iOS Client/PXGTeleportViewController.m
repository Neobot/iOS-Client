//
//  PXGTeleportViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGTeleportViewController.h"
#import "PXGTools.h"

@interface PXGTeleportViewController ()

@end

@implementation PXGTeleportViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewPointSegue"])
    {
        PXGCreatePointViewController* controller = (PXGCreatePointViewController*)segue.destinationViewController;
        controller.delegate = self;
    }
}

- (void) newPointCreatedOnX:(int)x andY:(int)y andTheta:(double)theta
{
    NSMutableArray* newPositions = [NSMutableArray arrayWithArray:self.positions];
    [newPositions addObject:pxgEncodePointData(x, y, theta)];
    
    self.positions = newPositions;
    [self.tableView reloadData];
}

- (IBAction)editPositions:(id)sender
{
    if (!self.tableView.editing)
    {
        self.btnEdit.style = UIBarButtonItemStyleDone;
        self.btnEdit.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
    }
    else
    {
        self.btnEdit.style = UIBarButtonItemStyleBordered;
        self.btnEdit.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [_positions count];
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSDictionary* pointData = [_positions objectAtIndex:indexPath.row];
        int x;
        int y;
        double theta;
        pxgDecodePointData(pointData, &x, &y, &theta);
        
        NSString* text = [NSString stringWithFormat:@"x=%d y=%d t=%d", x, y, (int)pxgRadiansToDegrees(theta)];
        cell.textLabel.text = text;
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewValue" forIndexPath:indexPath];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
         NSMutableArray* newPositions = [NSMutableArray arrayWithArray:self.positions];
        [newPositions removeObjectAtIndex:indexPath.row];
        self.positions = newPositions;
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if ([self.delegate respondsToSelector:@selector(teleportPositionSelected:among:)])
            [self.delegate teleportPositionSelected:[self.positions objectAtIndex:indexPath.row] among:self.positions];
        
        [self.parentPopOverController dismissPopoverAnimated:YES];
    }
}

@end
