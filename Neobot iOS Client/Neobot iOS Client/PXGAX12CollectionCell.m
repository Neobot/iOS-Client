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
}

@end

@implementation PXGAX12CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       self.lblSpeed.text = @"0%";

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
    self.lblPosition.text = [NSString stringWithFormat:@"%.2f°", position];
}

- (IBAction)speedChanged:(PXGStickControlView *)sender
{
    self.lblSpeed.text = [NSString stringWithFormat:@"%i%%", (int)sender.value];
    [self.delegate speedChanged:sender.value forAX12:_id];
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
@end
