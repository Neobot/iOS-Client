//
//  PXGColorCollectionViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 01/05/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXGColorCollectionViewController : UICollectionViewController

- (void)clear;
- (void)setColor:(UIColor*)color forIndex:(int)index;

@end
