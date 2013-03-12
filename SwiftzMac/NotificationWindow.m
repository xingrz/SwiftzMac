//
//  NotificationWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-11.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "NotificationWindow.h"

@implementation NotificationWindow

@synthesize message;

- (id)init
{
    if (![super initWithWindowNibName:@"NotificationWindow"]) {
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

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    [[self window] setLevel:kCGStatusWindowLevel];
    timer = [NSTimer scheduledTimerWithTimeInterval:5
                                             target:self
                                           selector:@selector(handleTimer:)
                                           userInfo:nil
                                            repeats:NO];
}

- (void)closeWindow:(id)sender
{
    [self setMessage:nil];
    
    [timer invalidate];
    timer = nil;
    
    [self close];
}

- (void)handleTimer:(NSTimer *)theTimer
{
    [self closeWindow:self];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    NSLog(@"mouse entered");
    [timer invalidate];
}

@end
