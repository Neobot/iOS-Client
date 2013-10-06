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
- (void) sendTrajectory:(NSArray*)trajectoryPoints;
- (void) trajectoryNameChanged:(NSString*)name;
- (void) trajectoryPointsChanged:(NSArray*)trajectoryPoints;
@end

typedef NS_ENUM(NSInteger, PXGTrajectoryEditionViewSections)
{
    PXGTrajectoryNameSection = 0,
    PXGTrajectoryPointsSection = 1,
    PXGTrajectoryAddPointSection = 2,
    PXGTrajectoryActionsSection = 3
};


@interface PXGTrajectoryEditionViewController : UITableViewController <PXGCreatePointViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray* trajectoryPoints;
@property (strong, nonatomic) NSString* trajectoryName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;

@property (weak, nonatomic) id<PXGTrajectoryEditionViewControllerDelegate> delegate;

- (IBAction)onEdit:(id)sender;

@end
