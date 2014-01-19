//
//  PXGAX12CollectionCell.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 30/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12CollectionCell.h"
#import "PXGSelectAngleViewController.h"

@interface PXGAX12CollectionCell ()
{
    int _id;
    bool _isTimeout;
    bool _allowSpeedNotification;
}

@end

@implementation PXGAX12CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       self.lblSpeed.text = @"0%";
        _isTimeout = false;
        _allowSpeedNotification = true;
        self.speedNotificationInterval = 0.1;

    }
    return self;
}

- (void)setId:(int)ax12ID
{
    self.lblID.text = [NSString stringWithFormat:@"N°%i", ax12ID];
    _id = ax12ID;
}

- (void)setPosition:(double)position
{
    _isTimeout = position < 0;
    if (_isTimeout)
        self.lblPosition.text = [NSString stringWithFormat:@"Timeout"];
    else
        self.lblPosition.text = [NSString stringWithFormat:@"%.2f°", position];
    
    [self refreshState];
}

- (IBAction)speedChanged:(PXGStickControlView *)sender
{
    self.lblSpeed.text = [NSString stringWithFormat:@"%i%%", (int)sender.value];
    
    if (_allowSpeedNotification)
    {
        _allowSpeedNotification = false;
        [NSTimer scheduledTimerWithTimeInterval:self.speedNotificationInterval target:self selector:@selector(speedChangedTimeout:) userInfo:nil repeats:NO];
        [self.delegate speedChanged:sender.value forAX12:_id];
    }
}

- (void)speedChangedTimeout:(NSTimer*)timer
{
    _allowSpeedNotification = true;
}

- (IBAction)onSetPosition:(id)sender
{
    if (self.setPositionPopoverController.isPopoverVisible)
    {
        [self.setPositionPopoverController dismissPopoverAnimated:YES];
    }
    else
    {
        PXGSelectAngleViewController* angleSectionController = (PXGSelectAngleViewController*)self.setPositionPopoverController.contentViewController;
        angleSectionController.delegate = self;
        [angleSectionController setValue:[self.lblPosition.text doubleValue] animated:NO];
        
        [self.setPositionPopoverController presentPopoverFromRect:self.btnSetPosition.bounds
                                                           inView:self.btnSetPosition
                                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                                         animated:YES];
    }
}

- (IBAction)onLock:(id)sender
{
    [self.delegate lockStatusChanged:YES forAX12:_id];
}

- (void)angleSelected:(double)angle
{
    [self.delegate commandDefined:angle forAX12:_id];
    [self setPosition:angle];
    
    [self.setPositionPopoverController dismissPopoverAnimated:YES];
}

- (IBAction)onUnlock:(id)sender
{
    [self.delegate lockStatusChanged:NO forAX12:_id];
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [self refreshState];
}

- (void)refreshState
{
    BOOL enabled = self.enabled && !_isTimeout;
    self.stick.enabled = enabled;
    self.btnSetPosition.enabled = enabled;
    self.btnLock.enabled = enabled;
    self.btnUnlock.enabled = enabled;
}

@end
