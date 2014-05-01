//
//  PXGColorCollectionViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 01/05/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGColorCollectionViewController.h"

@interface PXGColorCollectionViewController ()

@property (strong, nonatomic) NSMutableArray* colors;

@end

@implementation PXGColorCollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.colors = [NSMutableArray array];
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
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *txtCellIdentifier = @"cell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:txtCellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[self.colors objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)clear
{
    [self.colors removeAllObjects];
    [self.collectionView reloadData];
}

- (void)setColor:(UIColor*)color forIndex:(int)index
{
    if (index < 0)
        return;
    
    if (index >= self.colors.count)
    {
        for(int i = self.colors.count; i <= index; ++i)
        {
            if (i != index)
                [self.colors addObject:[UIColor blackColor]];
            else
                [self.colors addObject:color];
            
        }
    }
    else
    {
        [self.colors replaceObjectAtIndex:index withObject:color];
    }
    
    [self.collectionView reloadData];
}


@end
