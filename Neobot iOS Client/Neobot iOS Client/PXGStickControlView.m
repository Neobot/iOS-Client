//
//  PXGStickControlView.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 28/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGStickControlView.h"

#pragma mark Cursor
@interface PXGStickCursor : UIView
{
    CGContextRef _context;
}

@end

@implementation PXGStickCursor

- (id)initRadius:(double)radius
{
    self = [super initWithFrame:CGRectMake(0, 0, radius * 4.0, radius * 4.0)];
    if (self)
    {
        self.opaque = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _context = UIGraphicsGetCurrentContext();
    
    CGRect cursorRect = CGRectInset(rect, rect.size.width/4.0, rect.size.height/4.0);
    
    //cursor
    CGContextSetShadow(_context, CGSizeMake(1, 1), 5);
    
    CGContextSetLineWidth(_context, 1);
    CGContextSetStrokeColorWithColor(_context, self.tintColor.CGColor);
    CGContextSetFillColorWithColor(_context, [UIColor whiteColor].CGColor);
    
    CGContextBeginPath(_context);
    CGContextAddEllipseInRect(_context, cursorRect);
    CGContextFillPath(_context);
    
    CGContextBeginPath(_context);
    CGContextAddEllipseInRect(_context, cursorRect);
    CGContextStrokePath(_context);

}

@end




#pragma mark Main view
@interface PXGStickControlView ()
{
   CGContextRef _context;
    double _length;
    BOOL _touchEnabled;
}

@property (nonatomic) double width;
@property (nonatomic) double cursorRadius;
@property (strong, nonatomic) PXGStickCursor* cursorView;


@end

@implementation PXGStickControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.opaque = NO;
    self.userInteractionEnabled = YES;
    
    self.width = 2.0;
    self.cursorRadius = 15.0;
    _touchEnabled = YES;
    
    self.cursorView = [[PXGStickCursor alloc] initRadius:self.cursorRadius];
    self.cursorView.tintColor = [UIColor colorWithRed:.72 green:.72 blue:.72 alpha:1.0];
    [self addSubview:self.cursorView];
    
    [self updateInternalLayoutValues];
    
    _value = -1;
    self.value = 0.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateInternalLayoutValues];
    
    double prevValue = self.value;
    _value = -1;
    self.value = prevValue;
}

- (void)updateInternalLayoutValues
{
    _length = (self.bounds.size.width - 2.0 * self.width) / 2.0;
}

- (double)cursorYPositionFromValue:(double)value
{
    double diffFromCenter = value * _length / 100.0;
    return self.bounds.size.width / 2.0 - diffFromCenter;
}

- (double)valueFromCursorYPosition:(double)pos
{
    double diffFromCenter = self.bounds.size.width / 2.0 - pos;
    return 100.0 * diffFromCenter / _length;
}

- (void)drawRect:(CGRect)rect
{
    _context = UIGraphicsGetCurrentContext();
    double w = self.width;
    double r = w/2.0;
    double top = rect.origin.y + rect.size.height / 2.0 - r;
    double bottom = top + w;
    
    CGColorRef bColor = [UIColor colorWithRed:.72 green:.72 blue:.72 alpha:1.0].CGColor;
    
    //background
    CGContextBeginPath(_context);
    
    CGContextSetLineWidth(_context, 4);
    CGContextSetLineJoin(_context, kCGLineJoinRound);
    
    CGContextSetFillColorWithColor(_context, bColor);
    
    CGContextMoveToPoint(_context, rect.origin.x + w, top);
    CGContextAddLineToPoint(_context, rect.origin.x + rect.size.width - w, top);
    CGContextAddArc(_context, rect.origin.x + rect.size.width - w, top + r, r, -M_PI_2, M_PI_2, -1);
    //CGContextMoveToPoint(_context, rect.origin.x + rect.size.width - w, top);
    CGContextAddLineToPoint(_context, rect.origin.x + w, bottom);
    CGContextAddArc(_context, rect.origin.x + w, top + r, r, -M_PI_2, M_PI_2, 1);
    
    CGContextFillPath(_context);

    
    double cursorPos = [self cursorYPositionFromValue:self.value];
    
    //tint
    CGRect tintRect = CGRectMake(cursorPos, top, rect.size.width / 2 - cursorPos, w);
    CGContextBeginPath(_context);
    CGContextSetFillColorWithColor(_context, self.tintColor.CGColor);
    CGContextAddRect(_context, tintRect);
    CGContextFillPath(_context);
    
}

- (void)setValue:(double)value
{
    [self setValue:value withAnimation:NO];
}

- (void)setValue:(double)value withAnimation:(BOOL)animation
{
    if (value > 100.0)
        value = 100.0;
    else if (value < -100.0)
        value = -100.0;
    
    if (value == _value)
        return;
    
    _value = value;
    [self sendActionsForControlEvents: UIControlEventValueChanged];
    
    CGPoint pos = CGPointMake([self cursorYPositionFromValue:value], self.bounds.size.height / 2.0);
    if (animation)
    {
        _touchEnabled = NO;
        [UIView animateWithDuration:0.2
                         animations:^{self.cursorView.center = pos;}
                         completion:^(BOOL finished) {self.cursorView.center = pos; [self setNeedsDisplay]; _touchEnabled = YES;}];
    }
    else
    {
        self.cursorView.center = pos;
        [self setNeedsDisplay];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(self.cursorView.frame, [touch locationInView:self]);
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint pos = [touch locationInView:self];
    self.value = [self valueFromCursorYPosition:pos.x];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self setValue:0 withAnimation:YES];
}

@end
