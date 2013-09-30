//
//  PXGAX12CollectionCell.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 30/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12CollectionCell.h"

@interface PXGAX12CollectionCell ()
{
    int _id;
}

@end

@implementation PXGAX12CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setId:(int)ax12ID
{
    self.lblID.text = [NSString stringWithFormat:@"ID = %i", ax12ID];
    _id = ax12ID;
}

- (void)setPosition:(double)position
{
    self.txtPosition.text = [NSString stringWithFormat:@"%f", position];
}

- (IBAction)speedChanged:(PXGStickControlView *)sender
{
    self.lblSpeed.text = [NSString stringWithFormat:@"%i%%", (int)sender.value];
    [self.delegate speedChanged:sender.value forAX12:_id];
}

- (IBAction)positionChanged:(UITextField *)sender
{
    [self.delegate positionChanged:[sender.text doubleValue] forAX12:_id];
}

- (IBAction)lockedStatusChanged:(UISwitch *)sender
{
    [self.delegate lockStatusChanged:sender.isOn forAX12:_id];
}

@end
