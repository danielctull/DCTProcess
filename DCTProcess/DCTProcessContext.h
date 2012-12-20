//
//  DCTProcessContext.h
//  DCTProcess
//
//  Created by Daniel Tull on 20.12.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTProcess.h"

@interface DCTProcessContext : NSObject

- (void)addProcess:(DCTProcess *)process;
- (void)retrieveProcesses:(void(^)(NSArray *downloads))handler;

@end
