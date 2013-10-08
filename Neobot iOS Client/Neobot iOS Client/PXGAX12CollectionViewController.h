//
//  PXGAX12CollectionViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 29/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGAX12CollectionCell.h"

@interface PXGAX12CollectionViewController : UICollectionViewController <PXGAX12CollectionCellProtocol>

@property (strong, nonatomic) UIPopoverController* setPositionPopoverController;
@property (strong, nonatomic) NSMutableArray* ax12List;

- (void)insertAx12:(int)ax12ID atRow:(int)row;
- (void)removeAx12:(int)ax12ID atRow:(int)row;
- (void)moveAx12:(int)ax12ID fromRow:(int)fromRow toRow:(int)toRow;

@end
