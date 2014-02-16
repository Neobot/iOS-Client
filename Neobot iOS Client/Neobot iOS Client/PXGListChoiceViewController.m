//
//  PXGListChoiceViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/02/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import "PXGListChoiceViewController.h"

@interface PXGListChoiceViewController ()

@end

@implementation PXGListChoiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

#pragma mark PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.choices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.choices objectAtIndex:row];
}

- (IBAction)onDone:(id)sender
{
    int row = [self.pickerView selectedRowInComponent:0];
    NSString* value = [self.choices objectAtIndex:row];
    
    [self.delegate didSelectChoice:value];
    [((UINavigationController*)[self parentViewController])popViewControllerAnimated:YES];
}
@end
