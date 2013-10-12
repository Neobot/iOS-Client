//
//  PXGAX12CollectionCell.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 30/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGStickControlView.h"
#import "PXGSelectAngleViewController.h"

@protocol PXGAX12CollectionCellProtocol <NSObject>

- (void) speedChanged:(double)speed forAX12:(int)ax12ID;
- (void) lockStatusChanged:(BOOL)locked forAX12:(int)ax12ID;
- (void) commandDefined:(double)command forAX12:(int)ax12ID;

@end

@interface PXGAX12CollectionCell : UICollectionViewCell <PXGSelectAngleViewControllerDelegate>

@property (weak, nonatomic) IBOutlet PXGStickControlView *stick;
@property (weak, nonatomic) IBOutlet UILabel *lblID;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UIButton *btnSetPosition;

@property (weak, nonatomic) id<PXGAX12CollectionCellProtocol> delegate;
@property (weak, nonatomic) UIPopoverController* setPositionPopoverController;


- (void)setId:(int)ax12ID;
- (void)setPosition:(double)position;

- (IBAction)speedChanged:(PXGStickControlView *)sender;
- (IBAction)onSetPosition:(id)sender;
- (IBAction)onLock:(id)sender;
- (IBAction)onUnlock:(id)sender;

@end
