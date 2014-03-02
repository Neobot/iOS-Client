//
//  PXGParametersViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 17/02/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGParametersViewController.h"

@interface PXGParametersViewController ()
{
    BOOL _hasChanges;
}

@property (strong, nonatomic) NSArray* names;
@property (strong, nonatomic) NSArray* values;

@end

@implementation PXGParametersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hasChanges = false;
    
    [[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connectionStatusChangedTo:(PXGConnectionStatus)status
{
    if(status == Controlled)
    {
        [[PXGCommInterface sharedInstance]  askParameters];
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
        return self.values.count;
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    static NSString *btnCellIdentifier = @"BtnCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        UILabel* parameterNameLbl = (UILabel*)[cell viewWithTag:2];
        parameterNameLbl.text = [self.names objectAtIndex:indexPath.row];
        
        UITextField* parameterValueTxt = (UITextField*)[cell viewWithTag:1];
        parameterValueTxt.text = [NSString stringWithFormat:@"%f", [[self.values objectAtIndex:indexPath.row] floatValue]];
        [parameterValueTxt addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];

    }
    else if (indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:btnCellIdentifier forIndexPath:indexPath];
        
        UIButton* btn = (UIButton*)[cell viewWithTag:1];
        
        if (indexPath.row == 0)
        {
            if (_hasChanges)
                [btn setTitle:@"Send*" forState:UIControlStateNormal];
            else
                [btn setTitle:@"Send" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(sendValues:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [btn setTitle:@"Refresh" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(refreshValues:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}

#pragma mark Actions
- (void) sendValues:(UIButton*)textField
{
    NSMutableArray* values = [NSMutableArray array];
    for (NSIndexPath* path in [self.tableView indexPathsForVisibleRows])
    {
        if (path.section == 0)
        {
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];
            UITextField* textField = (UITextField*)[cell viewWithTag:1];
            float value = [textField.text floatValue];
            [values addObject:[NSNumber numberWithFloat:value]];
        }
    }
    
    [[PXGCommInterface sharedInstance] sendParameters:values];
    [self setHasChanges:NO];
}

- (void)refreshValues:(UIButton*)textField
{
    [[PXGCommInterface sharedInstance] askParameters];
    [self setHasChanges:NO];
}

- (void)valueChanged:(UITextField*)textField
{
    [self setHasChanges:YES];
}

- (void)setHasChanges:(BOOL)hasChanges
{
    _hasChanges = hasChanges;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark Comm
- (void)didReceiveParametersValues:(NSArray*)values
{
    self.values = values;
    [self.tableView reloadData];
}

- (void)didReceiveParameterNames:(NSArray*)names
{
    self.names = names;
    [self.tableView reloadData];
}

@end
