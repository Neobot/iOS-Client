//
//  PXGCommProtocol.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 16/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "PXGNetworkDelegates.h"

@interface PXGCommProtocol : NSObject

- (id)init;
- (void) addDelegate: (id<PXGProtocolDelegate>)delegate;
- (void) removeDelegate: (id<PXGProtocolDelegate>)delegate;

@property (strong, nonatomic) GCDAsyncSocket *socket;

@end