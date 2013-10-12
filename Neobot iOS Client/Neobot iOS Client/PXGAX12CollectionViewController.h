//
//  PXGAX12CollectionViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 29/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGAX12CollectionCell.h"
#import "PXGAX12Data.h"

@protocol PXGAX12CollectionViewControllerProtocol <NSObject>

- (void) speedChanged:(double)speed forAX12:(PXGAX12Data*)ax12;
- (void) lockStatusChanged:(BOOL)locked forAX12:(PXGAX12Data*)ax12;
- (void) commandDefined:(double)command forAX12:(PXGAX12Data*)ax12;

@end

@interface PXGAX12CollectionViewController : UICollectionViewController <PXGAX12CollectionCellProtocol>

@property (strong, nonatomic) UIPopoverController* setPositionPopoverController;
@property (strong, nonatomic) NSMutableArray* ax12List;
@property (weak, nonatomic) id<PXGAX12CollectionViewControllerProtocol> delegate;

- (void)insertAx12:(int)ax12ID atRow:(int)row;
- (void)removeAx12:(int)ax12ID atRow:(int)row;
- (void)moveAx12:(int)ax12ID fromRow:(int)fromRow toRow:(int)toRow;

- (void)setPosition:(double)position forAx12:(int)ax12ID;

@end
