//
//  PXGAddAX12ViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 06/10/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAddAX12ViewController.h"

@interface PXGAddAX12ViewController ()

@property (strong, nonatomic) NSMutableArray* idList;

@end


@implementation PXGAddAX12ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.idList = [NSMutableArray array];
    [self updateIdList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAlreadyUsedIds:(NSArray*)ids
{
    _alreadyUsedIds = ids;
    [self updateIdList];
}

- (void)updateIdList
{
    [self.idList removeAllObjects];
    for (int i = 1; i <= 99; ++i)
    {
        NSNumber* num = [NSNumber numberWithInt:i];
        if (![self.alreadyUsedIds containsObject:num])
        {
            [self.idList addObject:num];
        }
    }
}

- (IBAction)done:(id)sender
{
    int selectedNum = [[self.idList objectAtIndex:[self.pickerView selectedRowInComponent:0]] intValue];
    if ([self.delegate respondsToSelector:@selector(ax12Added:)])
        [self.delegate ax12Added:selectedNum];
    
    [((UINavigationController*)[self parentViewController])popViewControllerAnimated:YES];
}

#pragma mark PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.idList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%i", [[self.idList objectAtIndex:row] intValue]];
}

@end
