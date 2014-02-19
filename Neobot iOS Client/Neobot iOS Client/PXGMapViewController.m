//
//  PXGMapViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 11/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PXGMapViewController.h"
#import "PXGTools.h"
#import "PXGParametersKeys.h"

@interface PXGMapViewController ()
{
    BOOL _panEnabled;
    NSTimer* _followFingerPanTimer;
    CADisplayLink* _displayLink;
    NSTimer* _sceneUpdateTimer;
}

@property (strong, nonatomic) NSMutableArray* objects;

@property (strong, nonatomic) CALayer* trajectoryLayer;
@property (strong, nonatomic) NSMutableArray* trajectory;
@property (strong, nonatomic) NSMutableArray* trajectoryToSend;

@end


@implementation PXGMapViewController

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.tableSize = CGSizeMake(2000, 3000);
        self.robot = [[PXGMapObject alloc] initWithPosition:[PXGRPoint rpointAtUnknownPosition] radius:350/2 andImage:@"Neobot.png"];
        self.robot.selectable = YES;
        self.robot.selectedImageName = @"NeobotSelected.png";
        self.robot.animatedSelection = YES;
        self.target = [[PXGMapObject alloc] initWithPosition:[PXGRPoint rpointAtUnknownPosition] radius:100 andImage:@"target.png"];
        self.objects = [NSMutableArray array];
        self.robotControlEnabled = NO;
        _panEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    UIImage* tableImage = [UIImage imageNamed:@"Table2014.png"];
    _scene = [[UIImageView alloc] initWithImage:tableImage];
    self.scene.contentMode = UIViewContentModeScaleAspectFit;
    self.scene.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    self.scene.userInteractionEnabled = YES;
    
    [self.view addSubview:self.scene];
    
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
    
    UITapGestureRecognizer* tapSelectionRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelectionGesture:)];
    [tapSelectionRecognizer setNumberOfTapsRequired:1];
    [self.scene addGestureRecognizer:tapSelectionRecognizer];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateSceneAnimations)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
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

#pragma mark Scene management

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

-(void)updateSceneAnimations
{
    for (PXGMapObject* object in self.objects)
    {
        if (object.needPositionUpdate == YES)
        {
            [self updatePositionOfObject:object];
        }
        
        [object updateAnimationAtTimeStamp:[_displayLink timestamp]];
    }
}

#pragma mark General objects management

- (void)addMapObject:(PXGMapObject*)object
{
    [self.objects addObject:object];
    
    UIView* view = object.view;
    self.view.center = CGPointMake(-1000, -1000); //Move it outside the scene
    
    [self updateBoundsOfObject:object];
    [self updatePositionOfObject:object];
        
    [self.scene addSubview:view];
}

- (void)removeMapObject:(PXGMapObject*)object
{
    NSUInteger index = [self.objects indexOfObject:object];
    if (index != NSNotFound)
    {
        [self.objects removeObjectAtIndex:index];
    }
}

- (void)updatePositionOfObject:(PXGMapObject*)object
{
    CGPoint scenePos = [self mapPointFromRobotToScene:object.position];
    object.view.center = scenePos;
    object.view.transform = CGAffineTransformMakeRotation(M_PI/2 - object.position.theta);
}

- (void)updateBoundsOfObject:(PXGMapObject*)object
{
    double sceneRadius = (self.scene.bounds.size.height * object.radius) / self.tableSize.width;
    CGRect viewBounds = object.view.bounds;
    viewBounds.size.width = sceneRadius * 2;
    viewBounds.size.height = sceneRadius * 2;
    [object setBounds:viewBounds];
}

- (void)updateAllObjects
{
    int index = 0;
    for (PXGMapObject* object in self.objects)
    {       
        [self updatePositionOfObject:object];
        [self updateBoundsOfObject:object];

        ++index;
    }
}

- (PXGMapObject*)findObjectInSceneAtPosition:(CGPoint)point
{
    UIView* hitView = [self.scene hitTest:point withEvent:nil];
    
    for (PXGMapObject* obj in self.objects)
    {
        if (obj.view == hitView)
            return obj;
    }
    
    return nil;
}

- (void)setSelectedObject:(PXGMapObject*)object
{
    if (object == nil)
    {
        [self clearSelection];
    }
    else if ([object selectable])
    {
        [self.selectedObject setSelected:NO];
        
        [object setSelected: YES];
        _selectedObject = object;
    }
}

- (void)clearSelection
{
    [_selectedObject setSelected:NO];
    _selectedObject = nil;
}

#pragma mark Robot/Target objects management

- (void)setRobotPositionAtX:(double)x Y:(double)y theta:(double)theta
{
    PXGRPoint* robotPosition = self.robot.position;
    robotPosition.x = x;
    robotPosition.y = y;
    robotPosition.theta = theta;
    
    self.robot.needPositionUpdate = YES;
}

- (void)setObjectivePositionAtX:(double)x Y:(double)y theta:(double)theta
{
    PXGRPoint* targetPosition = self.target.position;
    targetPosition.x = x;
    targetPosition.y = y;
    
    self.target.needPositionUpdate = YES;
}

#pragma mark Trajectory drawing

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
    
    int radius = 5;
    CGContextSetFillColorWithColor(ctx,[UIColor grayColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx,[UIColor darkGrayColor].CGColor);
    CGContextSetLineWidth(ctx, 2);
    
    for (PXGRPoint* pt in self.trajectory)
    {
        CGPoint scenePoint = [self mapPointFromRobotToScene:pt];
        CGContextBeginPath(ctx);
        
        CGContextAddEllipseInRect(ctx, CGRectMake(scenePoint.x - radius, scenePoint.y - radius, radius * 2, radius * 2));
        CGContextFillPath(ctx);
        
        CGContextBeginPath(ctx);
        CGContextAddEllipseInRect(ctx, CGRectMake(scenePoint.x - radius, scenePoint.y - radius, radius * 2, radius * 2));
        CGContextStrokePath(ctx);
    }
    
}

#pragma mark Gestures

-(void)panGesture:(UIPanGestureRecognizer*)panRecognizer
{
    if (!self.robotControlEnabled)
        return;
    
    CGPoint pos = [panRecognizer locationInView:self.scene];
    
    if (_panEnabled && [panRecognizer state] == UIGestureRecognizerStateBegan)
    {
        PXGMapObject* obj = [self findObjectInSceneAtPosition:pos];
        if (obj == self.robot)
        {
            [self setSelectedObject:self.robot];
            
            PXGRPoint* p = [self mapPointFromSceneToRobot:pos];
            [self addTrajectoryPoint:[PXGRPoint rpointFromRPoint:self.robot.position] andRedraw:NO];
            [self addTrajectoryPoint:p andRedraw:YES];
            
            if (self.trajectoryToSend == nil)
            {
                self.trajectoryToSend = [NSMutableArray array];
            }
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:FOLLOW_THE_FINGER])
            {
                NSTimeInterval delay = [[NSUserDefaults standardUserDefaults] doubleForKey:FOLLOW_THE_FINGER_DELAY];
                _followFingerPanTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(followFingerPanTimerFired:) userInfo:nil repeats:YES];
            }
        }
        else
            _panEnabled = NO;

    }
    else if (_panEnabled && [panRecognizer state] == UIGestureRecognizerStateChanged)
    {
        PXGRPoint* p = [self mapPointFromSceneToRobot:pos];
        
        int count = [self.trajectory count];
        
        if (count >= 3)
        {
            PXGRPoint* pm1  = [self.trajectory objectAtIndex: count - 2];
            PXGRPoint* pm2  = [self.trajectory objectAtIndex: count - 3];

        
            double a12 = atan2(pm1.x - pm2.x, pm1.y - pm2.y);
            double a01 = atan2(p.x - pm1.x, p.y - pm1.y);
        
            double dif = a01 - a12;
            
            double lastSegmentLength = fabs(p.x - pm1.x + p.y - pm1.y);
            double val = fabs(sin(dif) * lastSegmentLength);
            
            if (lastSegmentLength < 30.0 || (val <= 20.0))
            {
                [self.trajectory removeLastObject];
            }
            else
            {
                [self.trajectoryToSend addObject:[self.trajectory lastObject]];
            }
        }
        
        
        [self addTrajectoryPoint:p andRedraw:YES];
        
    }
    else if ([panRecognizer state] == UIGestureRecognizerStateEnded)
    {
        [self clearSelection]; //The robot is always selected at this point
        
        PXGRPoint* p = [self mapPointFromSceneToRobot:pos];
        [self.trajectoryToSend addObject:p];
        
        [_followFingerPanTimer invalidate];
        [self.delegate sendMapTrajectory:self.trajectoryToSend];
        [self.trajectoryToSend removeAllObjects];
        [self clearTrajectory];
        _panEnabled = YES;
    }
}

-(void)followFingerPanTimerFired:(NSTimer*)timer
{
    if ([self.trajectoryToSend count] > 0)
    {
        [self.delegate sendMapTrajectory:self.trajectoryToSend];
        [self.trajectoryToSend removeAllObjects];
    }
}

-(void)tapSelectionGesture:(UITapGestureRecognizer*)recognizer
{
    if (!self.robotControlEnabled)
        return;
    
    CGPoint pos = [recognizer locationInView:self.scene];
    
    
    PXGMapObject* obj = [self findObjectInSceneAtPosition:pos];
    
    if (obj == self.robot)
    {
        if (obj.selected)
            [self clearSelection];
        else
            [self setSelectedObject:self.robot];
    }
    else if (obj != nil)
    {
        [self setSelectedObject:obj];
    }
    else
    {
        if (self.robot.selected)
        {
            PXGRPoint* p = [self mapPointFromSceneToRobot:pos];
            [self.delegate sendMapPoint:p];
        }

        [self clearSelection];
    }
}

@end
