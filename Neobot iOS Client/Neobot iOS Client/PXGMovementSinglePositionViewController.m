//
//  PXGMovementSinglePositionViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 09/12/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMovementSinglePositionViewController.h"

@interface PXGMovementSinglePositionViewController ()

@end

@implementation PXGMovementSinglePositionViewController

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
    switch (section)
    {
        case 0:
            return self.ids.count;
        case 1:
            return 2;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITextField* txt = (UITextField*)[cell.contentView viewWithTag:1];
    UILabel* lbl = (UILabel*)[cell.contentView viewWithTag:2];
    
    if (indexPath.section == 0)
    {
        int num = [[self.ids objectAtIndex:indexPath.row] intValue];
        lbl.text = [NSString stringWithFormat:@"AX-12 N°%i", num];
        
        float value = [[self.positions objectAtIndex:indexPath.row] floatValue];
        txt.text = [NSString stringWithFormat:@"%02f", value];
    }
    else if (indexPath.section == 1)
    {
        float value = 0.0;
        if (indexPath.row == 0)
        {
            lbl.text = @"Speed";
            value = self.speed;
        }
        else
        {
            lbl.text = @"Torque";
            value = self.torque;
        }
        
        txt.text = [NSString stringWithFormat:@"%02f", value];
    }
    
    return cell;
}

@end
