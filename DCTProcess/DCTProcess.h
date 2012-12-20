//
//  DCTProcess.h
//  DCTProcess
//
//  Created by Daniel Tull on 20/12/2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCTProcess : NSObject

- (id)initWithIdentifier:(NSString *)identifier;
@property (readonly, copy) NSString *identifier;
@property (readonly, assign) float progress;

- (void)cancel;
- (void)observeCancellationOnQueue:(dispatch_queue_t)queue handler:(void(^)())handler;

- (void)complete;
- (void)observeCompletionOnQueue:(dispatch_queue_t)queue handler:(void (^)())handler;

- (void)addSubprocess:(DCTProcess *)subprocess;

+ (NSPredicate *)predicateForProcessWithIdentifier:(NSString *)identifier;

@end
