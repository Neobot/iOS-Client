//
//  PXGCreatePointViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 27/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGCreatePointViewController.h"
#import "PXGTools.h"

@interface PXGCreatePointViewController ()

@end

@implementation PXGCreatePointViewController

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

- (IBAction)pointCreationDone:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(newPointCreatedOnX:andY:andTheta:)])
    {
        int x = [self.txtXValue.text intValue];
        int y = [self.txtYValue.text intValue];
        double theta = pxgDegreesToRadians([self.txtThetaValue.text intValue]);
        
        [self.delegate newPointCreatedOnX:x andY:y andTheta:theta];
    }
    
    [((UINavigationController*)[self parentViewController])popViewControllerAnimated:YES];
}
@end
