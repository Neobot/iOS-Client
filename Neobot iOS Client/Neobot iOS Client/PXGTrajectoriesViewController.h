//
//  PXGTrajectoriesViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 29/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGTrajectoriesViewControllerDelegate <NSObject>
- (void) trajectorySelected:(NSDictionary*)trajectory;
- (void) availableTrajectoriesChanged:(NSArray*)trajectories;
@end

@interface PXGTrajectoriesViewController : UITableViewController

@property (strong, nonatomic) NSArray* trajectories;
@property (strong, nonatomic) id<PXGTrajectoriesViewControllerDelegate> delegate;
@property (strong, nonatomic) UIPopoverController* parentPopOverController;

@end
