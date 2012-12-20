//
//  DCTProcessTests.m
//  DCTProcessTests
//
//  Created by Daniel Tull on 20/12/2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "DCTProcessTests.h"
#import <DCTProcess/DCTProcess.h>

@implementation DCTProcessTests

- (void)testExample {

	DCTProcess *process = [[DCTProcess alloc] initWithIdentifier:@"test"];
	__block BOOL completed = NO;
	dispatch_group_t group = dispatch_group_create();
	dispatch_group_enter(group);
	[process observeCompletionOnQueue:NULL handler:^{
		completed = YES;
		dispatch_group_leave(group);
	}];
	[process complete];

	// Wait 2 seconds, should be more than enough time
	dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 2000000000));
	STAssertTrue(completed, @"Process was not completed.");
}

- (void)testSubprocess {

	DCTProcess *process = [[DCTProcess alloc] initWithIdentifier:@"parent"];
	DCTProcess *subprocess = [[DCTProcess alloc] initWithIdentifier:@"child"];
	[process addSubprocess:subprocess];

	DCTProcess *subsubprocess = [[DCTProcess alloc] initWithIdentifier:@"grandchild"];
	[subprocess addSubprocess:subsubprocess];

	__block BOOL completed = NO;
	dispatch_group_t group = dispatch_group_create();
	dispatch_group_enter(group);
	[process observeCompletionOnQueue:NULL handler:^{
		completed = YES;
		dispatch_group_leave(group);
	}];
	[process complete];
	[subprocess complete];
	[subsubprocess complete];

	// Wait 2 seconds, should be more than enough time
	dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 2000000000));
	STAssertTrue(completed, @"Process was not completed.");
}

@end
