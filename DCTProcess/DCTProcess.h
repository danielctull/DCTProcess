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
- (void)addCancellationHandler:(void(^)())cancellationHandler;

- (void)complete;
- (void)addCompletionHandler:(void(^)())completionHandler;

- (void)addSubprocess:(DCTProcess *)subprocess;

@end
