//
//  AppDelegate.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "PreferencesWindow.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self.statusMenu];
    [statusItem setTitle:@"Swiftz"];
    [statusItem setHighlightMode:YES];
    
    [self showMainWindow:self];
}

- (IBAction)showMainWindow:(id)sender
{
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

- (IBAction)login:(id)sender
{
    NSLog(@"login clicked");
    [self.loginMenuItem setHidden:YES];
    [self.logoutMenuItem setHidden:NO];
    [self.accountMenuItem setHidden:NO];
    [self.accountMenuItem setTitle:@"Account: 114033xxxx"];
}

- (IBAction)logout:(id)sender
{
    [self.accountMenuItem setHidden:YES];
    [self.logoutMenuItem setHidden:YES];
    [self.loginMenuItem setHidden:NO];
}

@end
