//
//  AppDelegate.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"

#import "Amtium.h"
#import "NetworkInterface.h"

#import "MainWindow.h"
#import "PreferencesWindow.h"

@implementation AppDelegate

@synthesize initialUse;
@synthesize server;
@synthesize entry;
@synthesize entries;
@synthesize interface;
@synthesize ip;
@synthesize ipManual;
@synthesize shouldUseKeychain;

+ (void)initialize
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:SMInitialKey];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:SMIpManualKey];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:SMKeychainKey];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // 初始化状态栏菜单
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:[self statusMenu]];
    [statusItem setTitle:@"Swiftz"];
    [statusItem setHighlightMode:YES];

    ipAddresses = [NetworkInterface getAllIpAddresses];
    interfaces = [NetworkInterface getAllInterfaces];

    [self showMainWindow:self];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    Amtium *amtium = [mainWindow amtium];
    
    if ([menuItem action] == @selector(showMainWindow:)) {
        [menuItem setHidden:[amtium online]];
        return YES;
    }
    
    if ([menuItem action] == @selector(logout:)) {
        [menuItem setHidden:![amtium online]];
        return YES;
    }
    
    if ([menuItem action] == @selector(showAccount:)) {
        if ([amtium online]) {
            NSString *account = [[mainWindow amtium] account];
            NSString *title = [NSString stringWithFormat:@"Online: %@", account];
            [menuItem setTitle:title];
            [menuItem setHidden:NO];
        } else {
            [menuItem setHidden:YES];
        }

        return [amtium website] != nil;
    }
    
    return YES;
}

- (MainWindow *)mainWindow
{
    if (!mainWindow) {
        mainWindow = [[MainWindow alloc] init];
    }
    
    return mainWindow;
}

- (PreferencesWindow *)preferencesWindow
{
    if (!preferencesWindow) {
        preferencesWindow = [[PreferencesWindow alloc] init];
    }
    
    return preferencesWindow;
}

- (IBAction)showMainWindow:(id)sender
{
    if (!mainWindow) {
        mainWindow = [[MainWindow alloc] init];
    }

    [NSApp activateIgnoringOtherApps:YES];
    [mainWindow showWindow:self];
}

- (IBAction)showPreferencesWindow:(id)sender
{
    if (!preferencesWindow) {
        preferencesWindow = [[PreferencesWindow alloc] init];
    }

    [NSApp activateIgnoringOtherApps:YES];
    [preferencesWindow showWindow:self];
}

- (IBAction)showAccount:(id)sender
{
    [mainWindow account:sender];
}

- (IBAction)logout:(id)sender
{
    [mainWindow logout:sender];
}

- (BOOL)initialUse
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SMInitialKey];
}

- (void)setInitialUse:(BOOL)_initialUse
{
    [[NSUserDefaults standardUserDefaults] setBool:_initialUse
                                            forKey:SMInitialKey];
}

- (NSString *)server
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:SMServerKey];
}

- (void)setServer:(NSString *)_server
{
    [[NSUserDefaults standardUserDefaults] setObject:_server
                                              forKey:SMServerKey];
}

- (NSString *)entry
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:SMEntryKey];
}

- (void)setEntry:(NSString *)_entry
{
    [[NSUserDefaults standardUserDefaults] setObject:_entry
                                              forKey:SMEntryKey];
}

- (NSArray *)entries
{
    NSLog(@"get entries: %@", [[NSUserDefaults standardUserDefaults] stringArrayForKey:SMEntryListKey]);
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:SMEntryListKey];
}

- (void)setEntries:(NSArray *)_entries
{
    NSLog(@"set entries: %@", _entries);
    [[NSUserDefaults standardUserDefaults] setObject:_entries
                                              forKey:SMEntryListKey];
}

- (NSArray *)ipAddresses
{
    return ipAddresses;
}

- (NSArray *)interfaces
{
    return interfaces;
}

@end
