//
//  PXGMapObject.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 12/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXGRPoint.h"

@interface PXGMapObject : NSObject

- (id)initWithPosition:(PXGRPoint*)position radius:(double)radius andImage:(NSString*)imageName;

@property (strong, nonatomic) PXGRPoint* position;
@property (nonatomic)         double     radius;

@property (strong, nonatomic, readonly)  UIView*    view;

@property (strong, nonatomic) NSString*  imageName;

@property (nonatomic)         BOOL       selectable;
@property (nonatomic)         BOOL       selected;
@property (nonatomic)         BOOL       animatedSelection;
@property (strong, nonatomic) NSString*  selectedImageName;
@property (nonatomic)         double     selectionAnimationSpeed; //radian/s
@property (strong, nonatomic) UIColor*   selectionAnimationColor;
@property (nonatomic)         BOOL       needPositionUpdate;

- (void)setBounds:(CGRect)bounds;
- (void)updateAnimationAtTimeStamp:(CFTimeInterval)timestamp;

@end
