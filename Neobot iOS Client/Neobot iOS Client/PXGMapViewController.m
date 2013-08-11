//
//  PXGMapViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMapViewController.h"

@interface PXGMapViewController ()

@end

@implementation PXGMapViewController

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.tableSize = CGSizeMake(2000, 3000);
        self.robotRadius = 350/2;
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    UIImage* tableImage = [UIImage imageNamed:@"Table2013.png"];
    self.table = [[UIImageView alloc] initWithImage:tableImage];
    self.table.contentMode = UIViewContentModeScaleAspectFit;
    self.table.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    
    [self.view addSubview:self.table];
    
    UIImage* robotImage = [UIImage imageNamed:@"Neobot.png"];
    self.robot = [[UIImageView alloc] initWithImage:robotImage];
    self.robot.contentMode = UIViewContentModeScaleAspectFit;
    [self.table addSubview:self.robot];
    self.robot.center = self.view.center;
    self.robot.center = CGPointMake(-1000, -1000);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self doTableLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doTableLayout
{
    double imageRatio = self.table.image.size.width / self.table.image.size.height;
    double viewRatio = self.view.bounds.size.width / self.view.bounds.size.height;
    
    CGRect tableBounds = self.table.bounds;
    if (viewRatio < imageRatio)
    {
        tableBounds.size.width = self.view.bounds.size.width;
        tableBounds.size.height = tableBounds.size.width / imageRatio;
    }
    else
    {
        tableBounds.size.height = self.view.bounds.size.height;
        tableBounds.size.width = tableBounds.size.height * imageRatio;
    }
    
    self.table.bounds = tableBounds;
    self.table.center = self.view.center;
    
    CGPoint r = [self mapPointFromRobotToTable:CGPointMake(self.robotRadius, self.robotRadius)];
    CGRect robotBounds = self.robot.bounds;
    robotBounds.size.width = r.x * 2;
    robotBounds.size.height = r.x * 2;
    self.robot.bounds = robotBounds;
    
    [self updateRobotPosition];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self doTableLayout];
}

- (CGPoint)mapPointFromRobotToTable:(CGPoint)point
{
    CGFloat x = (self.table.bounds.size.width * point.y) / self.tableSize.height;
    CGFloat y = (self.table.bounds.size.height * point.x) / self.tableSize.width;
    
    return CGPointMake(x, y);
}

- (CGPoint)mapPointFromTableToRobot:(CGPoint)point
{
    CGFloat x = (self.tableSize.width * point.y) / self.table.bounds.size.height;
    CGFloat y = (self.tableSize.height * point.x) / self.table.bounds.size.width;
    
    return CGPointMake(x, y);
}

- (void)setRobotPosition:(CGPoint)robotPosition;
{
    _robotPosition = robotPosition;
    [self updateRobotPosition];
}

- (void)updateRobotPosition
{
    CGPoint pos = [self mapPointFromRobotToTable:self.robotPosition];
    self.robot.center = pos;
}

@end
