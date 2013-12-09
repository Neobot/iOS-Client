//
//  PXGMovementSinglePositionViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 09/12/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  PXGMovementSinglePositionViewControllerProtocol <NSObject>
- (void)movementNameChanged:(NSString*)name;
- (void)movementPositionsChanged;
@end

@interface PXGMovementSinglePositionViewController : UITableViewController

@property (nonatomic) float speed;
@property (nonatomic) float torque;
@property (strong, nonatomic) NSArray* positions;
@property (strong, nonatomic) NSMutableArray* ids;

@property (weak, nonatomic) id<PXGMovementSinglePositionViewControllerProtocol> delegate;

@end
