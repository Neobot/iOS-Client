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
        self.pointData = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.pointData != nil)
    {
        int x, y;
        double theta;
        pxgDecodePointData(self.pointData, &x, &y, &theta);
        self.txtXValue.text = [NSString stringWithFormat:@"%d", x];
        self.txtYValue.text = [NSString stringWithFormat:@"%d", y];
        
        double thetaD = pxgRadiansToDegrees(theta);
        if (round(thetaD) == thetaD)
            self.txtThetaValue.text = [NSString stringWithFormat:@"%d", (int)thetaD];
        else
            self.txtThetaValue.text = [NSString stringWithFormat:@"%f", thetaD];
            

    }
    
	[self.txtXValue becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextEditionAfterX:(id)sender
{
    [self.txtYValue becomeFirstResponder];
}

- (IBAction)nextEditionAfterY:(id)sender
{
    [self.txtThetaValue becomeFirstResponder];
}

- (IBAction)pointCreationDone:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(newPointCreatedOnX:andY:andTheta:)])
    {
        int x = [self.txtXValue.text intValue];
        int y = [self.txtYValue.text intValue];
        double theta = pxgDegreesToRadians([self.txtThetaValue.text doubleValue]);
        
        [self.delegate newPointCreatedOnX:x andY:y andTheta:theta];
    }
    
    [((UINavigationController*)[self parentViewController])popViewControllerAnimated:YES];
}
@end
