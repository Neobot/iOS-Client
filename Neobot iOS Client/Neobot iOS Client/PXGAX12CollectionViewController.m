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
	
    self.ax12 = @[[PXGAX12Data ax12WithId:2], [PXGAX12Data ax12WithId:42], [PXGAX12Data ax12WithId:1],
                  [PXGAX12Data ax12WithId:4], [PXGAX12Data ax12WithId:25], [PXGAX12Data ax12WithId:7]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ax12.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *txtCellIdentifier = @"AX12Cell";
    
    PXGAX12CollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:txtCellIdentifier forIndexPath:indexPath];
    //[cell.layer setCornerRadius:8.0f];
    [cell.layer setBorderWidth:3];
    [cell.layer setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
    
    PXGAX12Data* data = [self.ax12 objectAtIndex:indexPath.row];
    [cell setId:data.ax12ID];
    [cell setPosition:data.position];
    [cell.switchLocked setOn:data.locked];
    
    return cell;
}

@end
