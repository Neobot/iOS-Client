//
//  PXGAskNameViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 08/12/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAskNameViewController.h"

@interface PXGAskNameViewController ()

@end

@implementation PXGAskNameViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.txtName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDone:(id)sender
{
    if (![self.txtName.text  isEqual:@""])
        [self.delegate newNameSelected:self.txtName.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setObjectName:(NSString*)name
{
    self.navigationItem.title = [NSString stringWithFormat:@"New %@", name];
}

- (void)setDefaultName:(NSString*)defaultName
{
    [self.txtName setText:defaultName];
}

@end
