//
//  PreparingWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-8.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "PreparingWindow.h"

@interface PreparingWindow ()

@end

@implementation PreparingWindow

- (id)init
{
    if (![super initWithWindowNibName:@"PreparingWindow"]) {
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

- (void)windowDidLoad
{
    [super windowDidLoad];

    [[self indicator] startAnimation:self];
}

@end
