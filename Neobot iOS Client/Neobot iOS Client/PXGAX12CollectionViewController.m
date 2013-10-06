//
//  PXGAX12CollectionViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 29/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12CollectionViewController.h"
#import "PXGAX12CollectionCell.h"
#import "PXGAX12Data.h"

@interface PXGAX12CollectionViewController ()

@end

@implementation PXGAX12CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [cell.switchLocked setOn:data.locked];
    
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

@end
