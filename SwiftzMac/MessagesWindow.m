//
//  MessagesWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-14.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "MessagesWindow.h"

@implementation MessagesWindow

- (id)init
{
    if (![super initWithWindowNibName:@"MessagesWindow"]) {
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
    [[NSApp delegate] managedObjectContext];
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
