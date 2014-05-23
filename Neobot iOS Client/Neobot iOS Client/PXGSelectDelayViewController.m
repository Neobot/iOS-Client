//
//  PXGSelectDelayViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 23/05/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGSelectDelayViewController.h"

@interface PXGSelectDelayViewController ()
{
    int _nbValues;
    int _preRowSelection;
}

@end

@implementation PXGSelectDelayViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.min = 0;
        self.max = 100;
        _preRowSelection = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.picker selectRow:_preRowSelection inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMin:(int)min
{
    _min = min;
    _nbValues = _max - _min + 1;
}

- (void)setMax:(int)max
{
    _max = max;
    _nbValues = _max - _min + 1;
}

- (int)getValueForRow:(NSInteger)row
{
    return (row % _nbValues) + self.min;
}


#pragma mark PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _nbValues;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label;
    if (view == nil)
        label = [[UILabel alloc] init];
    else
        label = (UILabel*)view;
    
    
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%i", [self getValueForRow:row]];
    
    return label;
}

- (IBAction)onDone:(id)sender
{
    int value = [self getValueForRow:[self.picker selectedRowInComponent:0]];
    
    if ([self.delegate respondsToSelector:@selector(delayValueSelected:)])
        [self.delegate delayValueSelected:value];
    
    [(UINavigationController*)(self.parentViewController) popViewControllerAnimated:YES];
}

- (void)setValue:(int)value animated:(BOOL)animated
{
    int row = (value - self.min);
    _preRowSelection = row;
    [self.picker selectRow:row inComponent:0 animated:animated];
}

@end
