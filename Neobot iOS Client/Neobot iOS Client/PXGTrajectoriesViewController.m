//
//  PXGTrajectoriesViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 29/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGTrajectoriesViewController.h"
#import "PXGTools.h"

@interface PXGTrajectoriesViewController ()
{
    int _currentEditedIndex;
}

@end

@implementation PXGTrajectoriesViewController

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
    PXGTrajectoryEditionViewController* controller = (PXGTrajectoryEditionViewController*)segue.destinationViewController;
    controller.delegate = self;
    
    if ([segue.identifier isEqualToString:@"EditTrajectorySegue"])
    {
        _currentEditedIndex = [self.tableView indexPathForSelectedRow].row;
        NSDictionary* trajectoryData = [self.trajectories objectAtIndex:_currentEditedIndex];
        
        NSString* name;
        NSArray* points;
        pxgDecodeTrajectoryData(trajectoryData, &name, &points);

        controller.trajectoryName = name;
        controller.trajectoryPoints = [NSMutableArray arrayWithArray:points];
    }
    else if ([segue.identifier isEqualToString:@"NewTrajectorySegue"])
    {
        _currentEditedIndex = -1;
        
        controller.trajectoryName = NSLocalizedString(@"Trajectory", nil);
        controller.trajectoryPoints = [NSMutableArray array];
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
        return [self.trajectories count];
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"TrajectoryCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSDictionary* trData = [self.trajectories objectAtIndex:indexPath.row];
        NSString* name;
        NSArray* points;
        pxgDecodeTrajectoryData(trData, &name, &points);
        
        cell.textLabel.text = name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d point(s)", [points count]];

        
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
        [self.trajectories removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([self.delegate respondsToSelector:@selector(availableTrajectoriesChanged:)])
            [self.delegate availableTrajectoriesChanged:self.trajectories];
    }
}

#pragma mark Trajectory edition delegate
- (void) sendTrajectory:(NSArray*)trajectoryPoints
{
    if ([self.delegate respondsToSelector:@selector(sendTrajectory:)])
        [self.delegate sendTrajectory:trajectoryPoints];
}

- (void) trajectoryNameChanged:(NSString*)name
{
    if (_currentEditedIndex >= 0)
    {
        NSDictionary* trajectoryData = [self.trajectories objectAtIndex:_currentEditedIndex];
        NSString* oldName;
        NSArray* points;
        pxgDecodeTrajectoryData(trajectoryData, &oldName, &points);
        
        [self.trajectories replaceObjectAtIndex:_currentEditedIndex withObject:pxgEncodeTrajectoryData(name, points)];
    }
    else
    {
        NSDictionary* newTrajectoryData = pxgEncodeTrajectoryData(name, [NSArray array]);
        [self.trajectories addObject:newTrajectoryData];
        _currentEditedIndex = self.trajectories.count - 1;
    }
    
    if ([self.delegate respondsToSelector:@selector(availableTrajectoriesChanged:)])
        [self.delegate availableTrajectoriesChanged:self.trajectories];
    
    [self.tableView reloadData];
}

- (void) trajectoryPointsChanged:(NSArray*)trajectoryPoints
{
    if (_currentEditedIndex >= 0)
    {
        NSDictionary* trajectoryData = [self.trajectories objectAtIndex:_currentEditedIndex];
        NSString* name;
        NSArray* oldPoints;
        pxgDecodeTrajectoryData(trajectoryData, &name, &oldPoints);
        
        [self.trajectories replaceObjectAtIndex:_currentEditedIndex withObject:pxgEncodeTrajectoryData(name, trajectoryPoints)];
    }
    else
    {
        NSDictionary* newTrajectoryData = pxgEncodeTrajectoryData(NSLocalizedString(@"Trajectory", nil), trajectoryPoints);
        [self.trajectories addObject:newTrajectoryData];
        _currentEditedIndex = self.trajectories.count - 1;
    }
    
    if ([self.delegate respondsToSelector:@selector(availableTrajectoriesChanged:)])
        [self.delegate availableTrajectoriesChanged:self.trajectories];
    
    [self.tableView reloadData];
}

@end
