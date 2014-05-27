//
//  PXGDeplacementTypeTableViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/05/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"

@protocol PXGDeplacementTypeTableViewControllerDelegate <NSObject>
- (void)movementTypeSelected:(PXGAsservType)value;
@end

@interface PXGDeplacementTypeTableViewController : UITableViewController

@property (weak, nonatomic) id<PXGDeplacementTypeTableViewControllerDelegate> delegate;

@end
