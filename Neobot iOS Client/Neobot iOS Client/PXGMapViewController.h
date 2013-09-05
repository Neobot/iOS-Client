//
//  PXGMapViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGMapObject.h"

@interface PXGMapViewController : UIViewController

@property (readonly, strong, nonatomic) UIImageView* scene;
@property (nonatomic) CGSize tableSize;

@property (strong, nonatomic) PXGMapObject* robot;
@property (strong, nonatomic) PXGMapObject* target;

- (void)setRobotPositionAtX:(double)x Y:(double)y theta:(double)theta;
- (void)setObjectivePositionAtX:(double)x Y:(double)y theta:(double)theta;

- (CGPoint)mapPointFromRobotToScene:(PXGRPoint*)robotPoint;
- (PXGRPoint*)mapPointFromSceneToRobot:(CGPoint)point;

- (void)addMapObject:(PXGMapObject*)object;
- (void)removeMapObject:(PXGMapObject*)object;

- (void)updateSceneLayout;
- (void)updateAllObjects;

- (PXGMapObject*)findObjectAtPosition:(CGPoint)point;

@end
