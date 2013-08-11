//
//  PXGMapViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXGMapViewController : UIViewController

@property (strong, nonatomic) UIImageView* table;
@property (strong, nonatomic) UIImageView* robot;

@property (nonatomic) CGSize tableSize;
@property (nonatomic) float robotRadius;

@property (nonatomic) CGPoint robotPosition;
- (void)setRobotPosition:(CGPoint)robotPosition;

- (CGPoint)mapPointFromRobotToTable:(CGPoint)point;
- (CGPoint)mapPointFromTableToRobot:(CGPoint)point;
- (void)doTableLayout;

@end
