//
//  PXGStrategySelectionViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 26/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGStrategySelectionViewControllerDelegate <NSObject>
- (void) didSelectStrategy:(int)strategyNum;
@end

@interface PXGStrategySelectionViewController : UITableViewController

@property (strong, nonatomic) NSArray* strategyNames;
@property (strong, nonatomic) id<PXGStrategySelectionViewControllerDelegate> delegate;
@property (strong, nonatomic) UIPopoverController* parentPopOverController;

@end
