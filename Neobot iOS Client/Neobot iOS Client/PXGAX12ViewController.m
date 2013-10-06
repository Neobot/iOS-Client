//
//  PXGAX12ViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 28/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12ViewController.h"
#import "PXGStickControlView.h"
#import "PXGParametersKeys.h"

@interface PXGAX12ViewController ()

@end

@implementation PXGAX12ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sliderSpeed.value = [[NSUserDefaults standardUserDefaults] floatForKey:AX12_MAX_SPEED];
    self.sliderTorque.value = [[NSUserDefaults standardUserDefaults] floatForKey:AX12_MAX_TORQUE];
    [self speedChanged];
    [self torqueChanged];
    
    self.ax12CollectionController.ax12List = [NSMutableArray array];
    NSArray* list = [[NSUserDefaults standardUserDefaults] objectForKey:AX12_LIST];
    for (NSDictionary* ax12Data in list)
    {
        PXGAX12Data* ax12 = [[PXGAX12Data alloc] initWithDictionary:ax12Data];
        [self.ax12CollectionController.ax12List addObject:ax12];
    }
    
    //self.ax12CollectionController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    NSMutableArray* list = [NSMutableArray array];
    for (PXGAX12Data* ax12 in self.ax12CollectionController.ax12List)
    {
        NSDictionary* data = [ax12 encodeToDictionary];
        [list addObject:data];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:AX12_LIST];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ax12CollectionSegue"])
    {
        self.ax12CollectionController = (PXGAX12CollectionViewController*)segue.destinationViewController;
        
    }
    else if ([segue.identifier isEqualToString:@"ax12ListSegue"])
    {
        UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
        PXGAX12ListTableViewController* controller = (PXGAX12ListTableViewController*)navController.topViewController;
        controller.delegate = self;
        controller.ax12IdList = [NSMutableArray array];
        for (PXGAX12Data* ax12 in self.self.ax12CollectionController.ax12List)
        {
            [controller.ax12IdList addObject:[NSNumber numberWithInt:ax12.ax12ID]];
        }
    }
}

- (void) ax12:(int)ax12ID addedAtRow:(int)row
{
    [self.ax12CollectionController insertAx12:ax12ID atRow:row];
}

- (void) ax12:(int)ax12ID removedAtRow:(int)row
{
    [self.ax12CollectionController removeAx12:ax12ID atRow:row];
}

- (void) ax12:(int)ax12ID movedFromRow:(int)fromRow toRow:(int)toRow
{
    [self.ax12CollectionController moveAx12:ax12ID fromRow:fromRow toRow:toRow];
}

- (IBAction)speedChanged
{
    int speed = self.sliderSpeed.value;
    self.lblSpeed.text = [NSString stringWithFormat:@"%i%%", speed];
    [[NSUserDefaults standardUserDefaults] setFloat:self.sliderSpeed.value forKey:AX12_MAX_SPEED];
}

- (IBAction)torqueChanged
{
    int torque = self.sliderTorque.value;
    self.lblTorque.text = [NSString stringWithFormat:@"%i%%", torque];
    [[NSUserDefaults standardUserDefaults] setFloat:self.sliderTorque.value forKey:AX12_MAX_TORQUE];
}

@end
