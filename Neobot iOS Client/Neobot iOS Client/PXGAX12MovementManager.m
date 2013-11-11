//
//  PXGAX12MovementManager.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 03/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import "PXGAX12MovementManager.h"

#pragma mark Manager
@implementation PXGAX12MovementManager

- (id)initWithFile:(NSString*)fileContent
{
    if ((self = [super init]))
	{
		self.groups = [NSMutableArray array];
        [self readFileContent:fileContent];
	}
    
    return self;
}

- (NSString*)writeToString
{
    NSMutableString* out = [NSMutableString string];
    
    for (PXGAX12MovementGroup* group in self.groups)
	{
        [out appendFormat:@"G;%@;", group.name];
        
        for (NSNumber* ax12Id in group.ids)
        {
            [out appendFormat:@"%i;", [ax12Id intValue]];
        }
		
        [out appendString:@"\n"];
        
        for (PXGAX12Movement* mvt in group.movements)
		{
            [out appendFormat:@"M;%@\n", mvt.name];
            
            for (PXGAX12MovementSinglePosition* singlePos in mvt.positions)
			{
                [out appendString:@"P;"];

                for (NSNumber* pos in singlePos.ax12Positions)
				{
					[out appendFormat:@"%f;", [pos floatValue]];
				}
                
                [out appendFormat:@"%f;%f\n", singlePos.torque, singlePos.speed];
			}
		}
	}
    
    return out;
}

- (void)readFileContent:(NSString*)fileContent
{
    PXGAX12MovementGroup* currentGroup;
	PXGAX12Movement* currentMovement;
    
    NSArray* allLinedStrings = [fileContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString* line in allLinedStrings)
    {
        if ([line hasPrefix:@"#"])
            continue;
        
        NSArray* tokens = [line componentsSeparatedByString:@";"];
        
        NSString* lineType = [tokens objectAtIndex:0];
        if ([lineType isEqualToString:@"G"])
		{
			if (tokens.count >= 2)
			{
				NSString* name = [tokens objectAtIndex:1];
				NSMutableArray* ids = [NSMutableArray array];
                
				for(int i = 2; i < tokens.count; ++i)
				{
					if ([[tokens objectAtIndex:i] length] > 0)
						[ids addObject:[NSNumber numberWithInt:[[tokens objectAtIndex:i] intValue]]];
				}
                
                currentGroup = [[PXGAX12MovementGroup alloc] initWithName:name andIds:ids];
				[self.groups addObject:currentGroup];
			}
		}
		else if ([lineType isEqualToString:@"M"])
		{
			if (tokens.count >= 2)
			{
                NSString* name = [tokens objectAtIndex:1];
                currentMovement = [[PXGAX12Movement alloc] initWithName:name];
                [currentGroup.movements addObject:currentMovement];
			}
		}
		else if ([lineType isEqualToString:@"P"])
		{
            int tokenCount = tokens.count;
			if ([[tokens lastObject] length] == 0)
				--tokenCount;
            
			if (tokenCount >= 3)
			{
				NSMutableArray* positions = [NSMutableArray array];
				for(int i = 1; i < tokenCount - 2; ++i)
				{
					NSString* t = [tokens objectAtIndex:i];
					if (t.length > 0)
					{
                        NSNumber* num = [NSNumber numberWithFloat:[t floatValue]];
                        [positions addObject:num];
					}
				}
                
				float torque = [[tokens objectAtIndex:tokenCount - 2] floatValue];
				float maxSpeed = [[tokens objectAtIndex:tokenCount - 1] floatValue];
                
                PXGAX12MovementSinglePosition* singlePos = [[PXGAX12MovementSinglePosition alloc] initWithSpeed:maxSpeed torque:torque andPositions:positions];
				[currentMovement.positions addObject:singlePos];
			}
		}
    }
}

@end

#pragma mark Group
@implementation PXGAX12MovementGroup

- (id)initWithName:(NSString*)name andIds:(NSMutableArray*)ids
{
    if ((self = [super init]))
	{
		self.movements = [NSMutableArray array];
        self.name = name;
        self.ids = ids;
	}
    
    return self;
}

@end

#pragma mark Movement
@implementation PXGAX12Movement

- (id)initWithName:(NSString*)name
{
    if ((self = [super init]))
	{
		self.positions = [NSMutableArray array];
        self.name = name;
	}
    
    return self;
}

@end

#pragma mark SinglePosition
@implementation PXGAX12MovementSinglePosition

- (id)initWithSpeed:(float)speed torque:(float)torque andPositions:(NSArray*)positions
{
    if ((self = [super init]))
	{
		self.speed = speed;
        self.torque = torque;
        self.ax12Positions = positions;
	}
    
    return self;
}

@end
