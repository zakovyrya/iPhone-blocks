//
//  TaskCell.m
//  iPhoneBlocks
//
//  Created by Vyacheslav Zakovyrya on 1/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TaskCell.h"


@implementation TaskCell

@synthesize activity, label;

- (void)dealloc {
    self.activity = nil;
    self.label = nil;
    
    [super dealloc];
}

@end
