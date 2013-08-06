//
//  PXGTrajectoryEditionViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 01/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCreatePointViewController.h"

@protocol PXGTrajectoryEditionViewControllerDelegate <NSObject>
- (void) sendTrajectory:(NSDictionary*)trajectory;
- (void) availableTrajectoriesChanged:(NSArray*)trajectories;
@end

typedef NS_ENUM(NSInteger, PXGTrajectoryEditionViewSections)
{
    PXGTrajectoryNameSection = 0,
    PXGTrajectoryPointsSection = 1,
    PXGTrajectoryAddPointSection = 2,
    PXGTrajectoryActionsSection = 3
};


@interface PXGTrajectoryEditionViewController : UITableViewController <PXGCreatePointViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray* trajectoryPoints;
@property (strong, nonatomic) NSString* trajectoryName;

@property (strong, nonatomic) id<PXGTrajectoryEditionViewControllerDelegate> delegate;

@end
