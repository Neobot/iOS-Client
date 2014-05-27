//
//  PXGOptionsViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 08/09/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGOptionsViewController.h"
#import "PXGParametersKeys.h"

@interface PXGOptionsViewController ()

@end

@implementation PXGOptionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.followFingerSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:FOLLOW_THE_FINGER]];

    int delayInMs = [[NSUserDefaults standardUserDefaults] doubleForKey:FOLLOW_THE_FINGER_DELAY] * 1000.0;
    [self.followFingerDelaySlider setValue:delayInMs];
    [self.lblFollowFingerDelay setText:[NSString stringWithFormat:@"%i ms", delayInMs]];
    
    [self setLabelForMovement:[[NSUserDefaults standardUserDefaults] integerForKey:MOVEMENT_TYPE]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"deplacementTypeSegue"])
    {
        PXGDeplacementTypeTableViewController* controller = (PXGDeplacementTypeTableViewController*)segue.destinationViewController;
        controller.delegate = self;
    }
}

- (IBAction)followFingerChanged:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:FOLLOW_THE_FINGER];
}

- (IBAction)followFingerDelayChanged:(UISlider *)sender
{
    [self.lblFollowFingerDelay setText:[NSString stringWithFormat:@"%i ms", (int)sender.value]];
    [[NSUserDefaults standardUserDefaults] setDouble:sender.value/1000.0 forKey:FOLLOW_THE_FINGER_DELAY];
}

- (void)movementTypeSelected:(PXGAsservType)value
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:MOVEMENT_TYPE];
    [self setLabelForMovement:value];
}

- (void)setLabelForMovement:(PXGAsservType)mvt
{
    NSString* str;
    switch (mvt)
    {
        case TURN_THEN_MOVE: str=@"TURN THEN MOVE"; break;
        case TURN_AND_MOVE: str=@"TURN AND MOVE"; break;
        case TURN_ONLY: str=@"TURN ONLY"; break;
        case MOVE_ONLY: str=@"MOVE ONLY"; break;
            
        default:
            str=@"Unknown";
            break;
    }
    
    self.lblDeplacementType.text = str;
}


@end
