//
//  PXGDeplacementTypeTableViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/05/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGDeplacementTypeTableViewController.h"

@interface PXGDeplacementTypeTableViewController ()

@end

@implementation PXGDeplacementTypeTableViewController

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


#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate movementTypeSelected:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
