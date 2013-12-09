//
//  PXGPositionActionsViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 09/12/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGPositionActionsViewControllerProtocol <NSObject>
- (void)runUntilHere;
- (void)moveToPosition;
@end

@interface PXGPositionActionsViewController : UITableViewController

- (IBAction)runUntilHere:(id)sender;
- (IBAction)moveToPosition:(id)sender;

@property (weak, nonatomic) id<PXGPositionActionsViewControllerProtocol> delegate;

@end
