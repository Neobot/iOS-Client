//
//  PXGTrajectoriesViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 29/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGTrajectoryEditionViewController.h"

@protocol PXGTrajectoriesViewControllerDelegate <NSObject>
- (void) sendTrajectory:(NSArray*)trajectoryPoints;
- (void) availableTrajectoriesChanged:(NSArray*)trajectories;
@end

@interface PXGTrajectoriesViewController : UITableViewController <PXGTrajectoryEditionViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray* trajectories;
@property (weak, nonatomic) id<PXGTrajectoriesViewControllerDelegate> delegate;
@property (weak, nonatomic) UIPopoverController* parentPopOverController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;

- (IBAction)onEdit:(id)sender;

@end
