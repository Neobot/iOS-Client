//
//  PXGStrategySelectionViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 26/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGStrategySelectionViewController.h"

@interface PXGStrategySelectionViewController ()

@end

@implementation PXGStrategySelectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.delegate = nil;
        self.parentPopOverController = nil;
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.strategyNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.strategyNames objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectStrategy:)])
        [self.delegate didSelectStrategy:indexPath.row];

    [self.parentPopOverController dismissPopoverAnimated:YES];
}

@end
