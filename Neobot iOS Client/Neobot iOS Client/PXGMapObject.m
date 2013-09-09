//
//  PXGMapObject.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 12/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PXGMapObject.h"

@interface PXGMapObject ()
{
    int _nbStep;
    int _currentStep;
    double _selectionAngleByStep;
}

@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) CALayer* selectionLayer;

@end

@implementation PXGMapObject


- (id)initWithPosition:(PXGRPoint*)position radius:(double)radius andImage:(NSString*)imageName
{
    if ((self = [super init]))
	{
        _nbStep = 50;
        _selectionAngleByStep = 2.0 * M_PI / (double)_nbStep;
        
		self.position = position;
        self.radius = radius;
        self.imageName = imageName;
        
        self.selectedImageName = nil;
        self.selectable = NO;
        self.selected = NO;
        
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        //self.view.contentMode = UIViewContentModeScaleAspectFit;
        self.view.userInteractionEnabled = YES;
        
        UIImage* image = [UIImage imageNamed:self.imageName];

        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.bounds = self.view.bounds;
        self.imageView.center = self.view.center;
        [self.view addSubview:self.imageView];
        
        self.selectionLayer = [[CALayer alloc] init];
        self.selectionLayer.bounds = self.view.bounds;
        self.selectionLayer.position = self.view.layer.position;
        self.selectionLayer.delegate = self;
        [self.view.layer insertSublayer:self.selectionLayer below:self.imageView.layer];
	}
    
    return self;
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
        
        //_currentStep = 0;
        _selected = selected;
        [self.selectionLayer setNeedsDisplay];
    }
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if (self.selected)
    {
        CGContextSetStrokeColorWithColor(ctx,[UIColor redColor].CGColor);
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

- (void)nextStep
{
    if (self.selected)
    {
        ++_currentStep;
        if (_currentStep >= _nbStep)
        {
            _currentStep = 0;
        }
    
    
        [self.selectionLayer setAffineTransform:CGAffineTransformMakeRotation(_selectionAngleByStep * (double)_currentStep)];
    }
}

@end
