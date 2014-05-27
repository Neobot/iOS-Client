//
//  PXGParametersViewController.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 17/02/2014.
//  Copyright (c) 2014 Pixelgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXGCommInterface.h"
#import "PXGDeplacementTypeTableViewController.h"

@interface PXGParametersViewController : UITableViewController <PXGConnectedViewDelegate, PXGRobotInterfaceDelegate>

@end
