//
//  PXGStringListViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 21/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGStringViewListControllerDelegate <NSObject>
- (void) didSelectString:(NSString*)string;
@end

@interface PXGStringListViewController : UITableViewController

@property (strong, nonatomic) NSArray* recentlyUsed;
@property (strong, nonatomic) NSArray* propositions;
@property (strong, nonatomic) id<PXGStringViewListControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtCustomValue;

- (IBAction)customValueSelected:(UITextField *)sender;

@end
