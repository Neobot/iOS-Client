//
//  PXGTeleportViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCreatePointViewController.h"

@protocol PXGTeleportSelectionViewControllerDelegate <NSObject>
- (void) teleportPositionSelected:(NSDictionary*)position;
- (void) availableTeleportPositionsChanged:(NSArray*)positions;
@end

@interface PXGTeleportViewController : UITableViewController <PXGCreatePointViewControllerDelegate>

@property (strong, nonatomic) NSArray* positions;
@property (strong, nonatomic) id<PXGTeleportSelectionViewControllerDelegate> delegate;
@property (strong, nonatomic) UIPopoverController* parentPopOverController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
- (IBAction)editPositions:(id)sender;

@end
