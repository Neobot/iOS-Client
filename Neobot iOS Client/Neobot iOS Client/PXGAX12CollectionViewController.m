//
//  PXGAX12CollectionViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 29/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12CollectionViewController.h"
#import "PXGSelectAngleViewController.h"

@interface PXGAX12CollectionViewController ()

@end

@implementation PXGAX12CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PXGSelectAngleViewController* setPositionViewController = (PXGSelectAngleViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectAngleView"];
    setPositionViewController.min = 0;
    setPositionViewController.max = 300;
    self.setPositionPopoverController = [[UIPopoverController alloc] initWithContentViewController:setPositionViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ax12List.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *txtCellIdentifier = @"AX12Cell";
    
    PXGAX12CollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:txtCellIdentifier forIndexPath:indexPath];
    //[cell.layer setCornerRadius:8.0f];
    [cell.layer setBorderWidth:3];
    [cell.layer setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
    
    PXGAX12Data* data = [self.ax12List objectAtIndex:indexPath.row];
    [cell setId:data.ax12ID];
    [cell setPosition:data.position];
    [cell setLoad:data.load];
    
    cell.delegate = self;
    cell.setPositionPopoverController = self.setPositionPopoverController;
    
    return cell;
}

- (void)insertAx12:(int)ax12ID atRow:(int)row
{
    PXGAX12Data* data = [PXGAX12Data ax12WithId:ax12ID];
    [self.ax12List insertObject:data atIndex:row];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)removeAx12:(int)ax12ID atRow:(int)row
{
    [self.ax12List removeObjectAtIndex:row];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)moveAx12:(int)ax12ID fromRow:(int)fromRow toRow:(int)toRow
{
    PXGAX12Data* data = [self.ax12List objectAtIndex:fromRow];
    [self.ax12List removeObjectAtIndex:fromRow];
    [self.ax12List insertObject:data atIndex:toRow];
    
    NSIndexPath* fromIndexPath = [NSIndexPath indexPathForRow:fromRow inSection:0];
    NSIndexPath* toIndexPath = [NSIndexPath indexPathForRow:toRow inSection:0];
    
    [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

-(PXGAX12Data*)getAX12DataForID:(int)ax12ID
{
    for (PXGAX12Data* data in self.ax12List)
    {
        if (data.ax12ID == ax12ID)
            return data;
    }
    
    return nil;
}

- (void)speedChanged:(double)speed forAX12:(int)ax12ID
{    
    [self.delegate speedChanged:speed forAX12:[self getAX12DataForID:ax12ID]];
}

- (void)lockStatusChanged:(BOOL)locked forAX12:(int)ax12ID
{
     [self.delegate lockStatusChanged:locked forAX12:[self getAX12DataForID:ax12ID]];
}

- (void)commandDefined:(double)command forAX12:(int)ax12ID
{
    PXGAX12Data* ax12 = [self getAX12DataForID:ax12ID];
    ax12.command = command;
    [self.delegate commandDefined:command forAX12:ax12];
}

- (void)setPosition:(double)position andLoad:(double)load forAx12:(int)ax12ID
{
    PXGAX12Data* ax12 = [self getAX12DataForID:ax12ID];
    ax12.position = position;
    ax12.load = load;
    
    
    NSInteger i = [self.ax12List indexOfObject:ax12];
    if (i != NSNotFound)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:i inSection:0];
        PXGAX12CollectionCell* cell = (PXGAX12CollectionCell*)[self.collectionView cellForItemAtIndexPath:ip];
        [cell setPosition:position];
        [cell setLoad:load];
    }
}

- (void)setAX12ControlEnabled:(BOOL)enabled
{
    for (PXGAX12CollectionCell* cell in self.collectionView.visibleCells)
    {
        cell.enabled = enabled;
    }
}

@end
