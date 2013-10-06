//
//  PXGAddAX12ViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 06/10/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PXGAddAX12ViewControllerDelegate <NSObject>
- (void)ax12Added:(int)ax12ID;
@end


@interface PXGAddAX12ViewController : UIViewController

- (IBAction)done:(id)sender;
@property (weak, nonatomic) id<PXGAddAX12ViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end
