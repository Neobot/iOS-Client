//
//  PXGMapObject.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 12/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PXGMapObject.h"
#import "PXGTools.h"

@interface PXGMapObject ()
{
    CFTimeInterval _previousTimeStamp;
}

@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) CALayer* selectionLayer;

@end

@implementation PXGMapObject


- (id)initWithPosition:(PXGRPoint*)position radius:(double)radius andImage:(NSString*)imageName
{
    if ((self = [super init]))
	{
        self.selectionAnimationSpeed = 0.3*2.0*M_PI;
        self.selectionAnimationColor = [UIColor redColor];
        
		self.position = position;
        self.radius = radius;
        self.imageName = imageName;
        
        self.selectedImageName = nil;
        self.selectable = NO;
        self.selected = NO;
        
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.view.contentMode = UIViewContentModeScaleAspectFit;
        self.view.userInteractionEnabled = YES;
        
        UIImage* image = [UIImage imageNamed:self.imageName];

        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.imageView];
        
        self.selectionLayer = [[CALayer alloc] init];
        self.selectionLayer.delegate = self;
        [self.view.layer insertSublayer:self.selectionLayer below:self.imageView.layer];
        
        [self setBounds:self.view.bounds];
	}
    
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    self.view.bounds = bounds;
    self.imageView.bounds = bounds;
    self.imageView.center = CGPointMake(bounds.size.width/2.0, bounds.size.height/2.0);
    self.selectionLayer.bounds = bounds;
    self.selectionLayer.position = self.imageView.layer.position;
}

- (void)setSelected:(BOOL)selected
{
    if (selected != _selected && self.selectable)
    {
        if (self.selectedImageName != nil)
        {
            UIImage* image = nil;
            if (selected)
                image = [UIImage imageNamed:self.selectedImageName];
            else
                image = [UIImage imageNamed:self.imageName];
            
            [self.imageView setImage:image];
        }
        
        _selected = selected;
        _previousTimeStamp = 0;
        [self.selectionLayer setNeedsDisplay];
    }
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if (self.selected)
    {
        CGContextSetStrokeColorWithColor(ctx, self.selectionAnimationColor.CGColor);
        CGContextSetLineWidth(ctx, 5);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGFloat dashLengths[2] = {10, 10};
        CGContextSetLineDash(ctx, 0, dashLengths, 2);
        
        CGContextBeginPath(ctx);
        CGContextAddEllipseInRect(ctx, CGRectInset(layer.bounds, 10, 10));
        
        CGContextStrokePath(ctx);
        
        CGContextSetFillColorWithColor(ctx,[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.6].CGColor);
        CGContextBeginPath(ctx);
        CGContextAddEllipseInRect(ctx, CGRectInset(layer.bounds, 10, 10));
        
        CGContextFillPath(ctx);
    }
}

- (void)updateAnimationAtTimeStamp:(CFTimeInterval)timestamp;
{
    if (self.selected && self.animatedSelection)
    {
        if (_previousTimeStamp > 0)
        {
            NSTimeInterval diffTime = timestamp - _previousTimeStamp;
            double angleDiff = self.selectionAnimationSpeed * diffTime;
            
            CGAffineTransform t = self.selectionLayer.affineTransform;
            [self.selectionLayer setAffineTransform:CGAffineTransformRotate(t, angleDiff)];
        }
        
        _previousTimeStamp = timestamp;
    }
}

@end
