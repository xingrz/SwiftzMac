//
//  NotificationWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-11.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "NotificationWindow.h"

@implementation NotificationWindow

- (id)init
{
    if (![super initWithWindowNibName:@"NotificationWindow"]) {
        return nil;
    }

    NSLog(@"init noti");

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

- (void)showWindow:(id)sender
{
    NSLog(@"show window");
    [super showWindow:sender];
}

@end
