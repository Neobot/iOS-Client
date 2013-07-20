//
//  PXGLogViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"

@interface PXGLogViewController : UIViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate, PXGServerInterfaceDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void) logMessage:(NSString*)message from:(NSString*)speaker;

@end
