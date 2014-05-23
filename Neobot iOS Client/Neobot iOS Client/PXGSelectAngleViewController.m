//
//  PXGSelectAngleViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 07/10/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGSelectAngleViewController.h"

const int NB_LOOP = 4;

@interface PXGSelectAngleViewController ()
{
    int _nbValues;
}

@end

@implementation PXGSelectAngleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.picker selectRow:_nbValues * NB_LOOP inComponent:0 animated:NO];
    [self.picker selectRow:200 inComponent:1 animated:NO];
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

- (int)getAngleIntegerForRow:(NSInteger)row
{
    return (row % _nbValues) + self.min;
}

- (int)getDecimalsForRow:(NSInteger)row
{
    return row % 100;
}

#pragma mark PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _nbValues * NB_LOOP * 2;
    }
    else
        return 100 * NB_LOOP * 2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label;
    if (view == nil)
        label = [[UILabel alloc] init];
    else
        label = (UILabel*)view;
    
    if (component == 0)
    {
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%i ", [self getAngleIntegerForRow:row]];
    }
    else
    {
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@" .%02d°", [self getDecimalsForRow:row]];
    }
    
    return label;
}

- (IBAction)onDone:(id)sender
{
    int integer = [self getAngleIntegerForRow:[self.picker selectedRowInComponent:0]];
    int decimals = [self getDecimalsForRow:[self.picker selectedRowInComponent:1]];
    
    double value = integer + (double)decimals / 100.0;
    
    if ([self.delegate respondsToSelector:@selector(angleSelected:)])
        [self.delegate angleSelected:value];
}

- (IBAction)onResetToCentralPosition:(id)sender
{
    [self setValue:(self.max - self.min) / 2.0 animated:YES];
}

- (void)setValue:(double)value animated:(BOOL)animated
{
    double finteger;
    double fdecimals = modf(value, &finteger);
    
    int integer = finteger;
    int decimals = round(fdecimals * 100.0);
    
    [self.picker selectRow:NB_LOOP * _nbValues + integer inComponent:0 animated:animated];
    [self.picker selectRow:NB_LOOP * 100 + decimals inComponent:1 animated:animated];
}
@end
