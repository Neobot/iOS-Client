//
//  PXGListChoiceViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/02/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGListChoiceViewControllerDelegate <NSObject>
- (void) didSelectChoice:(NSString*)string;
@end

@interface PXGListChoiceViewController : UIViewController

@property (nonatomic, strong) NSArray* choices;
@property (weak, nonatomic) id<PXGListChoiceViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)onDone:(id)sender;
- (void)setValue:(NSString*)value;

@end
