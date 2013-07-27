//
//  PXGTeleportViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGTeleportSelectionViewControllerDelegate <NSObject>
- (void) teleportPositionSelected:(NSDictionary*)position among:(NSArray*)positions;
@end

@interface PXGTeleportViewController : UITableViewController

@property (strong, nonatomic) NSArray* positions;
@property (strong, nonatomic) id<PXGTeleportSelectionViewControllerDelegate> delegate;
@property (strong, nonatomic) UIPopoverController* parentPopOverController;

@end
