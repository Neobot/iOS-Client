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
        NSMutableArray* newTrajectories = [NSMutableArray arrayWithArray:self.trajectories];
        [newTrajectories removeObjectAtIndex:indexPath.row];
        self.trajectories = newTrajectories;
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([self.delegate respondsToSelector:@selector(availableTrajectoriesChanged:)])
            [self.delegate availableTrajectoriesChanged:self.trajectories];
    }
}

@end
