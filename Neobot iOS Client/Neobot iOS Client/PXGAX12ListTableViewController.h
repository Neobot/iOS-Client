//
//  PXGAX12ListTableViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 06/10/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGAX12Data.h"
#import "PXGAddAX12ViewController.h"


@protocol PXGAX12ListTableViewControllerDelegate <NSObject>

@optional
- (void) ax12:(int)ax12ID addedAtRow:(int)row;
- (void) ax12:(int)ax12ID removedAtRow:(int)row;
- (void) ax12:(int)ax12ID movedFromRow:(int)fromRow toRow:(int)toRow;

@end

@interface PXGAX12ListTableViewController : UITableViewController <PXGAddAX12ViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray* ax12IdList;
@property (weak, nonatomic) id<PXGAX12ListTableViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;

- (IBAction)onEdit:(id)sender;

@end
