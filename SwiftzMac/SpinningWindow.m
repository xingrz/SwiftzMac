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
    if (![super initWithWindowNibName:@"SpinningWindow"]) {
        return nil;
    }

    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithMessage:(NSString *)message
             delegate:(id)delegate
    didCancelSelector:(SEL)selector
{
    self = [self init];
    
    _delegate = delegate;
    _selector = selector;
    _label = message;
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self message] setStringValue:_label];
    [[self indicator] startAnimation:self];
}

- (IBAction)cancel:(id)sender
{
    if (_delegate != nil && [_delegate respondsToSelector:_selector]) {
        [_delegate performSelector:_selector withObject:self];
    }
}

@end
