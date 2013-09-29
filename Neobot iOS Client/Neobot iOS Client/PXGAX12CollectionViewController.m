//
//  PXGAX12CollectionViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 29/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12CollectionViewController.h"

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell;
    
    static NSString *txtCellIdentifier = @"AX12Cell";
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:txtCellIdentifier forIndexPath:indexPath];
    [cell.layer setCornerRadius:8.0f];
    //[cell.layer setBorderWidth:3];
    //[cell.layer setBorderColor:[UIColor grayColor].CGColor];
    
    return cell;
}

@end
