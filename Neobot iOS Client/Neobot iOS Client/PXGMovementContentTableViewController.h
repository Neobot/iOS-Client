//
//  PXGMovementContentTableViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGMovementContentTableViewControllerProtocol <NSObject>
- (void)movementNameChanged:(NSString*)name;
- (void)movementPositionsChanged;
@end

@interface PXGMovementContentTableViewController : UITableViewController

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSMutableArray* positions;
@property (strong, nonatomic) NSMutableArray* ids;
@property (weak, nonatomic) id<PXGMovementContentTableViewControllerProtocol> delegate;

@end
