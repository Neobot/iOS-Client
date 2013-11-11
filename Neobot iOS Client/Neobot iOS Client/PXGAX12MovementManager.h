//
//  PXGAX12MovementManager.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 03/11/2013.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXGAX12MovementManager : NSObject

- (id)initWithFile:(NSString*)fileContent;
- (NSString*)writeToString;

@property (strong, nonatomic) NSMutableArray* groups;

@end

@interface PXGAX12MovementGroup : NSObject

- (id)initWithName:(NSString*)name andIds:(NSMutableArray*)ids;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSMutableArray* movements;
@property (strong, nonatomic) NSMutableArray* ids;

@end

@interface PXGAX12Movement : NSObject

- (id)initWithName:(NSString*)name;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSMutableArray* positions;

@end

@interface PXGAX12MovementSinglePosition : NSObject

- (id)initWithSpeed:(float)speed torque:(float)torque andPositions:(NSArray*)positions;

@property (nonatomic) float speed;
@property (nonatomic) float torque;
@property (strong, nonatomic) NSArray* ax12Positions;

@end