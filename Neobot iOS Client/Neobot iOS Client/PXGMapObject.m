//
//  PXGMapObject.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 12/08/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGMapObject.h"

@implementation PXGMapObject

- (id)initWithPosition:(PXGRPoint*)position radius:(double)radius andImage:(NSString*)imageName
{
    if ((self = [super init]))
	{
		self.position = position;
        self.radius = radius;
        self.imageName = imageName;
        
        self.selectedImageName = nil;
        self.selectable = NO;
        self.selected = NO;
        
        UIImage* image = [UIImage imageNamed:self.imageName];
        _view = [[UIImageView alloc] initWithImage:image];
        self.view.contentMode = UIViewContentModeScaleAspectFit;
        self.view.userInteractionEnabled = YES;
	}
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    if (selected != _selected && self.selectable)
    {
        if (self.selectedImageName != nil)
        {
            UIImage* image = nil;
            if (selected)
                image = [UIImage imageNamed:self.selectedImageName];
            else
                image = [UIImage imageNamed:self.imageName];
            
            [self.view setImage:image];
        }
        
        _selected = selected;
    }
}

@end
