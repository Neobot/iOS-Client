//
//  PXGLogViewController.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGLogViewController.h"

@interface PXGLogViewController ()

@end

@implementation PXGLogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[PXGCommInterface sharedInstance] registerConnectedViewDelegate:self];
    [[PXGCommInterface sharedInstance] registerRobotInterfaceDelegate:self];
    [[PXGCommInterface sharedInstance] registerServerInterfaceDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logMessage:(NSString*)message from:(NSString*)speaker
{
    NSString* currentText = self.textView.text;
    self.textView.text = [NSString stringWithFormat:@"%@%@: \"%@\"\n", currentText, speaker, message];
}

- (void)didReceiveLog:(NSString*) text
{
    [self logMessage:text from:@"Robot"];
}

- (void)didReceiveServerAnnouncement:(NSString*) message
{
    [self logMessage:message from:@"Server"];
}

@end
