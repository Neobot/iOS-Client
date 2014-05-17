//
//  PXGActionsTableViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 17/05/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGActionsTableViewController.h"
#import "PXGCommInterface.h"

@interface PXGActionsTableViewController ()

@end

@implementation PXGActionsTableViewController

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

- (IBAction)onStartLeft:(id)sender
{
    [[PXGCommInterface sharedInstance] executeAction:ACTION_START_PUMP withParameter:LeftPump];
}

- (IBAction)onStopLeft:(id)sender
{
    [[PXGCommInterface sharedInstance] executeAction:ACTION_STOP_PUMP withParameter:LeftPump];
}

- (IBAction)onStartRight:(id)sender
{
    [[PXGCommInterface sharedInstance] executeAction:ACTION_START_PUMP withParameter:RightPump];
}

- (IBAction)onStopRight:(id)sender
{
    [[PXGCommInterface sharedInstance] executeAction:ACTION_STOP_PUMP withParameter:RightPump];
}
@end
