//
//  PreparingWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-8.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "SpinningWindow.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation SpinningWindow

- (id)init
{
    self = [super initWithWindowNibName:@"SpinningWindow"];
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    return self;
}

- (id)initWithMessage:(NSString *)message
             delegate:(id)delegate
    didCancelSelector:(SEL)selector
{
    self = [self init];
    [self setMessage:message];
    [self setDelegate:delegate];
    [self setDidCancelSelector:selector];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self indicator] startAnimation:self];
}

- (IBAction)cancel:(id)sender
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:[self didCancelSelector]]) {
        [[self delegate] performSelector:[self didCancelSelector] withObject:self];
    }
}

@end
