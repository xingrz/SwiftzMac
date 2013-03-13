//
//  UpdateWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-13.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "UpdateWindow.h"

@implementation UpdateWindow

@synthesize update;

- (id)init
{
    if (![super initWithWindowNibName:@"UpdateWindow"]) {
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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)go:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://xingrz.github.com/SwiftzMac"]];
    [self close];
}

- (IBAction)ignore:(id)sender {
    [self close];
}
@end
