//
//  PXGGroupTableViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGGroupContentViewController.h"
#import "PXGAskNameViewController.h"

@protocol PXGGroupTableViewControllerDelegate <NSObject>
- (void)dataChanged;
@end

@interface PXGGroupTableViewController : UITableViewController <PXGAskNameViewControllerProtocol, PXGGroupContentViewControllerProtocol>

@property (strong, nonatomic) NSMutableArray* groups;
@property (nonatomic) BOOL enabled;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) id<PXGGroupTableViewControllerDelegate> delegate;

- (IBAction)onEdit:(id)sender;
- (void)setEnabled:(BOOL)enabled;

@end
