//
//  AppDelegate.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"

#import "Amtium.h"

#import "MainWindow.h"
#import "PreferencesWindow.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:[self statusMenu]];
    [statusItem setTitle:@"Swiftz"];
    [statusItem setHighlightMode:YES];
    
    [self showMainWindow:self];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if ([menuItem action] == @selector(showMainWindow:)) {
        [menuItem setHidden:[[mainWindow amtium] isOnline]];
    }
    
    if ([menuItem action] == @selector(logout:)) {
        [menuItem setHidden:![[mainWindow amtium] isOnline]];
    }
    
    if ([menuItem action] == @selector(showAccount:)) {
        [menuItem setHidden:![[mainWindow amtium] isOnline]];
        if ([[mainWindow amtium] isOnline]) {
            [menuItem setTitle:[[mainWindow amtium] account]];
        }
    }
    
    return YES;
}

- (IBAction)showMainWindow:(id)sender
{
    NSLog(@"showMainWindow:");
    if (!mainWindow) {
        mainWindow = [[MainWindow alloc] init];
    }
    
    [mainWindow showWindow:self];
}

- (IBAction)showPreferencesWindow:(id)sender
{
    if (!preferencesWindow) {
        preferencesWindow = [[PreferencesWindow alloc] init];
    }
    
    [preferencesWindow showWindow:self];
}

- (IBAction)showAccount:(id)sender
{
}

- (IBAction)logout:(id)sender
{
    [mainWindow logout:sender];
}

@end
