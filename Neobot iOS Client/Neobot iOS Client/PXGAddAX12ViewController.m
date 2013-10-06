//
//  PXGAddAX12ViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 06/10/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAddAX12ViewController.h"

@interface PXGAddAX12ViewController ()

@end

@implementation PXGAddAX12ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(ax12Added:)])
        [self.delegate ax12Added:[self.pickerView selectedRowInComponent:0] + 1];
    [((UINavigationController*)[self parentViewController])popViewControllerAnimated:YES];
}

#pragma mark PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 99;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%i", row + 1];
}

@end
