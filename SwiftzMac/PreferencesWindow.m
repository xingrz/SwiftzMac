//
//  PreferencesWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "PreferencesWindow.h"

@interface PreferencesWindow ()

@end

@implementation PreferencesWindow

- (id)init
{
    if (![super initWithWindowNibName:@"PreferencesWindow"]) {
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

- (IBAction)ok:(id)sender {
}

- (IBAction)cancel:(id)sender {
}

- (IBAction)restore:(id)sender {
}

@end
