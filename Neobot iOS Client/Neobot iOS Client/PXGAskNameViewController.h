//
//  PXGAskNameViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 08/12/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGAskNameViewControllerProtocol <NSObject>

- (void) newNameSelected:(NSString*)name;

@end

@interface PXGAskNameViewController : UITableViewController

@property (weak, nonatomic) id<PXGAskNameViewControllerProtocol> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtName;

- (IBAction)onDone:(id)sender;

- (void)setObjectName:(NSString*)name;
- (void)setDefaultName:(NSString*)defaultName;

@end
