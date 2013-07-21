//
//  PXGStringListViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 21/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGStringListViewController.h"

@interface PXGStringListViewController ()

@end

@implementation PXGStringListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.recentlyUsed = nil;
        self.propositions = nil;
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

- (BOOL)hasRecentSection
{
    return self.recentlyUsed != nil && [self.recentlyUsed count] > 0;
}

- (BOOL)hasPropositionsSection
{
    return self.propositions != nil && [self.propositions count] > 0;
}

- (void)getSectionIdForEditSection:(int*)editSection andForRecentSection:(int*)recentSection andForPropositionSection:(int*)propositionSection forTableView:(UITableView *)tableView
{
    BOOL hasRecentSection = [self hasRecentSection];
    BOOL hasPropositionSection = [self hasPropositionsSection];
    
    *editSection = [self numberOfSectionsInTableView:tableView] - 1;
    *recentSection = hasRecentSection ? 0 : -1;
    *propositionSection = hasRecentSection ? 0 : -1;
    if (hasPropositionSection)
        ++(*propositionSection);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = 1;
    
    if ([self hasRecentSection])
        ++count;
    
    if ([self hasPropositionsSection])
        ++count;
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int editSection;
    int recentSection;
    int propositionSection;
    [self getSectionIdForEditSection:&editSection andForRecentSection:&recentSection andForPropositionSection:&propositionSection forTableView:tableView];
        
    if (section == editSection)
        return 1;
    
    else if (section == recentSection)
        return [self.recentlyUsed count];
    
    else if (section == propositionSection)
        return [self.propositions count];
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int editSection;
    int recentSection;
    int propositionSection;
    [self getSectionIdForEditSection:&editSection andForRecentSection:&recentSection andForPropositionSection:&propositionSection forTableView:tableView];
    
    if (section == editSection)
        return @"New value";
    
    else if (section == recentSection)
        return @"Recently used";
    
    else if (section == propositionSection)
        return @"Available";
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int editSection;
    int recentSection;
    int propositionSection;
    [self getSectionIdForEditSection:&editSection andForRecentSection:&recentSection andForPropositionSection:&propositionSection forTableView:tableView];
    
    static NSString *readOnlyCellIdentifier = @"readOnly";
    static NSString *editableCellIdentifier = @"editable";
    
    UITableViewCell *cell;
    
    if (indexPath.section == editSection)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:editableCellIdentifier forIndexPath:indexPath];
    }
    
    else if (indexPath.section == recentSection)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:readOnlyCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [self.recentlyUsed objectAtIndex:indexPath.row];
    }
    
    else if (indexPath.section == propositionSection)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:readOnlyCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [self.propositions objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectString:)])
    {
        [self.delegate didSelectString:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }
    [((UINavigationController*)[self parentViewController])popViewControllerAnimated:YES];
}

- (IBAction)customValueSelected:(UITextField *)sender
{
    if ([sender.text length] > 0)
    {
        if ([self.delegate respondsToSelector:@selector(didSelectString:)])
        {
            [self.delegate didSelectString:sender.text];
        }
        [((UINavigationController*)[self parentViewController])popViewControllerAnimated:YES];
    }
}
@end
