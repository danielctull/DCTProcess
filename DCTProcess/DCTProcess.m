//
//  DCTProcess.m
//  DCTProcess
//
//  Created by Daniel Tull on 20/12/2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "DCTProcess.h"

@interface DCTProcess ()
@property (readwrite, assign) float progress;
@end

@implementation DCTProcess {
	dispatch_group_t _completionGroup;
	dispatch_group_t _cancellationGroup;
	dispatch_queue_t _queue;
	NSUInteger _amountOfProcesses;
	NSUInteger _amountOfCompletedProcesses;
}

- (id)initWithIdentifier:(NSString *)identifier {
	self = [self init];
	if (!self) return nil;

	_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);

	_cancellationGroup = dispatch_group_create();
	_completionGroup = dispatch_group_create();

	dispatch_group_enter(_cancellationGroup);
	[self _enterCompletion];
	_identifier = [identifier copy];

	return self;
}

- (void)cancel {
	dispatch_group_leave(_cancellationGroup);
}

- (void)complete {
	[self _leaveCompletion];
}

- (void)_enterCompletion {
	_amountOfProcesses++;
	dispatch_group_enter(_completionGroup);
	[self _updateProgress];
}

- (void)_leaveCompletion {
	_amountOfCompletedProcesses++;
	dispatch_group_leave(_completionGroup);
	[self _updateProgress];
}

- (void)_updateProgress {
	dispatch_async(dispatch_get_main_queue(), ^{
		self.progress = (float)(_amountOfCompletedProcesses / _amountOfProcesses);
	});
}

- (void)observeCompletionOnQueue:(dispatch_queue_t)queue handler:(void (^)())handler {
	if (queue == NULL) queue = _queue;
	dispatch_group_notify(_completionGroup, queue, handler);
}

- (void)observeCancellationOnQueue:(dispatch_queue_t)queue handler:(void(^)())handler {
	if (queue == NULL) queue = _queue;
	dispatch_group_notify(_cancellationGroup, queue, handler);
}

- (void)addSubprocess:(DCTProcess *)subprocess {

	__weak DCTProcess *weakSelf = self;
	__weak DCTProcess *weakSubprocess = subprocess;

	[self observeCancellationOnQueue:_queue handler:^{
		[weakSubprocess cancel];
	}];

	[self _enterCompletion];
	[subprocess observeCompletionOnQueue:_queue handler:^{
		[weakSelf _leaveCompletion];
	}];
}

+ (NSPredicate *)predicateForProcessWithIdentifier:(NSString *)identifier {
	return [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; identifier = %@>", NSStringFromClass([self class]), self, self.identifier];
}

@end
