//
//  PXGGroupContentViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGAX12ListTableViewController.h"
#import "PXGMovementContentTableViewController.h"

@interface PXGGroupContentViewController : UITableViewController

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSMutableArray* movements;
@property (strong, nonatomic) NSMutableArray* ids;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
- (IBAction)onEdit:(id)sender;

@end
