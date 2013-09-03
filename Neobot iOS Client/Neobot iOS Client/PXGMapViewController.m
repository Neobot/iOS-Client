//
//  PXGMapViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PXGMapViewController.h"

@interface PXGMapViewController ()

@property (strong, nonatomic) NSMutableArray* objectViews;
@property (strong, nonatomic) NSMutableArray* objects;

@property (strong, nonatomic) CALayer* trajectoryLayer;

@property (strong, nonatomic) NSMutableArray* trajectory;


@end


@implementation PXGMapViewController

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.tableSize = CGSizeMake(2000, 3000);
        self.robot = [[PXGMapObject alloc] initWithPosition:[PXGRPoint rpointAtUnknownPosition] radius:350/2 andImage:@"Neobot.png"];
        self.target = [[PXGMapObject alloc] initWithPosition:[PXGRPoint rpointAtUnknownPosition] radius:100 andImage:@"target.png"];
        self.objects = [NSMutableArray array];
        self.objectViews = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    UIImage* tableImage = [UIImage imageNamed:@"Table2013.png"];
    _scene = [[UIImageView alloc] initWithImage:tableImage];
    self.scene.contentMode = UIViewContentModeScaleAspectFit;
    self.scene.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    self.scene.userInteractionEnabled = YES;
    
    [self.view addSubview:self.scene];
    
    //The robot must be always the first object
    [self addMapObject:self.target];
    [self addMapObject:self.robot];
    
    self.trajectoryLayer = [[CALayer alloc] init];
    self.trajectoryLayer.delegate = self;
    self.trajectoryLayer.bounds = self.scene.bounds;
    self.trajectoryLayer.position = self.scene.layer.position;
    [self.scene.layer insertSublayer:self.trajectoryLayer atIndex:0];
    
    [self.trajectoryLayer setNeedsDisplay];
    
    UIPanGestureRecognizer* panRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [self.scene addGestureRecognizer:panRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self updateSceneLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateSceneLayout];
}

- (void)updateSceneLayout
{
    double imageRatio = self.scene.image.size.width / self.scene.image.size.height;
    double viewRatio = self.view.bounds.size.width / self.view.bounds.size.height;
    
    CGRect tableBounds = self.scene.bounds;
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
    
    self.scene.bounds = tableBounds;
    self.scene.center = self.view.center;
    
    [self updateAllObjects];
}

- (CGPoint)mapPointFromRobotToScene:(PXGRPoint*)robotPoint
{
    CGFloat x = (self.scene.bounds.size.width * robotPoint.y) / self.tableSize.height;
    CGFloat y = (self.scene.bounds.size.height * robotPoint.x) / self.tableSize.width;
    
    return CGPointMake(x, y);
}

- (PXGRPoint*)mapPointFromSceneToRobot:(CGPoint)point
{
    CGFloat x = (self.tableSize.width * point.y) / self.scene.bounds.size.height;
    CGFloat y = (self.tableSize.height * point.x) / self.scene.bounds.size.width;
    
    return [[PXGRPoint alloc] initWithX:x y:y theta:0.0];
}

- (void)addMapObject:(PXGMapObject*)object
{
    [self.objects addObject:object];
    
    UIImage* image = [UIImage imageNamed:object.imageName];
    UIImageView* view = [[UIImageView alloc] initWithImage:image];
    view.contentMode = UIViewContentModeScaleAspectFit;
    view.center = CGPointMake(-1000, -1000); //Move it outside the scene
    
    [self updateViewBounds:view fromObject:object];
    [self updateViewPosition:view fromObject:object];
        
    [self.scene addSubview:view];
    [self.objectViews addObject:view];
}

- (void)removeMapObject:(PXGMapObject*)object
{
    NSUInteger index = [self.objects indexOfObject:object];
    if (index != NSNotFound)
    {
        [self.objects removeObjectAtIndex:index];
        [self.objectViews removeObjectAtIndex:index];
    }
}

- (void)updateViewPosition:(UIView*)view fromObject:(PXGMapObject*)object
{
    CGPoint scenePos = [self mapPointFromRobotToScene:object.position];
    view.center = scenePos;
    
    view.transform = CGAffineTransformMakeRotation(M_PI/2 - object.position.theta);
}

- (void)updateViewBounds:(UIView*)view fromObject:(PXGMapObject*)object
{
    double sceneRadius = (self.scene.bounds.size.height * object.radius) / self.tableSize.width;
    CGRect viewBounds = view.bounds;
    viewBounds.size.width = sceneRadius * 2;
    viewBounds.size.height = sceneRadius * 2;
    view.bounds = viewBounds;
}

- (void)updateAllObjects
{
    int index = 0;
    for (PXGMapObject* object in self.objects)
    {
        UIView* view = [self.objectViews objectAtIndex:index];
        
        [self updateViewBounds:view fromObject:object];
        [self updateViewPosition:view fromObject:object];

        ++index;
    }
}

- (void)setRobotPositionAtX:(double)x Y:(double)y theta:(double)theta
{
    PXGRPoint* robotPosition = self.robot.position;
    robotPosition.x = x;
    robotPosition.y = y;
    robotPosition.theta = theta;
    
    //The robot is always the first object
    [self updateViewPosition:[self.objectViews objectAtIndex:1] fromObject:self.robot];
}

- (void)setObjectivePositionAtX:(double)x Y:(double)y theta:(double)theta
{
    PXGRPoint* targetPosition = self.target.position;
    targetPosition.x = x;
    targetPosition.y = y;
    
    //The target is always the second object
    [self updateViewPosition:[self.objectViews objectAtIndex:0] fromObject:self.target];
}

- (void)addTrajectoryPoint:(PXGRPoint*)point andRedraw:(BOOL)redraw
{
    if (self.trajectory == nil)
        self.trajectory = [NSMutableArray array];
    
    [self.trajectory addObject:point];
    
    if (redraw)
        [self.trajectoryLayer setNeedsDisplay];
}

- (void)clearTrajectory
{
    [self.trajectory removeAllObjects];
    [self redrawTrajectory];
}

- (void)redrawTrajectory
{
    [self.trajectoryLayer setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if (self.trajectory == nil || self.trajectory.count < 2)
        return;
    
    BOOL isFirst = YES;

    CGContextBeginPath(ctx);
    
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx,[UIColor redColor].CGColor);
    
    CGPoint firstPoint = [self mapPointFromRobotToScene:[self.trajectory objectAtIndex:0]];
    CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
    
    for (PXGRPoint* pt in self.trajectory)
    {
        if (!isFirst)
        {
            CGPoint scenePoint = [self mapPointFromRobotToScene:pt];
            CGContextAddLineToPoint(ctx, scenePoint.x, scenePoint.y);
        }
        
        isFirst = NO;
    }
    
    CGContextStrokePath(ctx);
}

-(void)panGesture:(UIPanGestureRecognizer*)panRecognizer
{
    if ([panRecognizer state] == UIGestureRecognizerStateBegan)
    {
        CGPoint pos = [panRecognizer locationInView:self.scene];
        PXGRPoint* p = [self mapPointFromSceneToRobot:pos];
        
        [self addTrajectoryPoint:p andRedraw:YES];

    }
    else if ([panRecognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint pos = [panRecognizer locationInView:self.scene];
        PXGRPoint* p = [self mapPointFromSceneToRobot:pos];
        
        [self addTrajectoryPoint:p andRedraw:YES];
    }
    else if ([panRecognizer state] == UIGestureRecognizerStateEnded)
    {
        [self clearTrajectory];
    }
}

@end
