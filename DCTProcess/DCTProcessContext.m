//
//  DCTProcessContext.m
//  DCTProcess
//
//  Created by Daniel Tull on 20.12.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "DCTProcessContext.h"

@implementation DCTProcessContext {
	NSMutableArray *_processes;
	dispatch_queue_t _queue;
}

- (id)init {
	self = [super init];
	if (!self) return nil;
	_queue = dispatch_queue_create("NAME", DISPATCH_QUEUE_SERIAL);
	dispatch_async(_queue, ^{
		_processes = [NSMutableArray new];
	});
	return self;
}

- (void)addProcess:(DCTProcess *)process {
	dispatch_async(_queue, ^{
		[_processes addObject:process];

		__weak DCTProcess *weakProcess = process;
		NSMutableArray *processes = _processes;

		void (^handler)() = ^{
			if (weakProcess) [processes removeObject:weakProcess];
		};
		[process observeCancellationOnQueue:_queue handler:handler];
		[process observeCompletionOnQueue:_queue handler:handler];
	});
}

- (void)retrieveProcesses:(void(^)(NSArray *downloads))handler {
	dispatch_async(_queue, ^{
		handler([_processes copy]);
	});
}

@end
