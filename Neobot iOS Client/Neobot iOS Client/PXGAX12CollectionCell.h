//
//  PXGAX12CollectionCell.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 30/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGStickControlView.h"

@protocol PXGAX12CollectionCellProtocol <NSObject>

- (void) speedChanged:(double)speed forAX12:(int)ax12ID;
- (void) lockStatusChanged:(BOOL)locked forAX12:(int)ax12ID;
- (void) positionChanged:(double)position forAX12:(int)ax12ID;

@end

@interface PXGAX12CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PXGStickControlView *stick;

@property (weak, nonatomic) IBOutlet UILabel *lblID;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UISwitch *switchLocked;

@property (weak, nonatomic) id<PXGAX12CollectionCellProtocol> delegate;

- (void)setId:(int)ax12ID;
- (void)setPosition:(double)position;

- (IBAction)speedChanged:(PXGStickControlView *)sender;
- (IBAction)lockedStatusChanged:(UISwitch *)sender;

@end
