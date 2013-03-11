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
#import "NotificationWindow.h"

@implementation AppDelegate

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
    [statusItem setAlternateImage:[NSImage imageNamed:@"statusAlternate.png"]];
    [statusItem setHighlightMode:YES];

    [self setOnline:NO];

    ipAddresses = [NetworkInterface getAllIpAddresses];
    interfaces = [NetworkInterface getAllInterfaces];

    [self showMainWindow:self];
    [self showNotification:@""];
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
            NSString *format = NSLocalizedString(@"MENU_ACCOUNT", @"Online: %@");
            [menuItem setTitle:[NSString stringWithFormat:format, account]];
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

- (void)showNotification:(NSString *)message
{
    if (!notificationWindow) {
        notificationWindow = [[NotificationWindow alloc] init];
    }

    [notificationWindow showWindow:self];
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

    if (mainWindow) {
        [[mainWindow amtium] setServer:_server];
    }
}

- (NSString *)entry
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:SMEntryKey];
}

- (void)setEntry:(NSString *)_entry
{
    [[NSUserDefaults standardUserDefaults] setObject:_entry
                                              forKey:SMEntryKey];

    if (mainWindow) {
        [[mainWindow amtium] setEntry:_entry];
    }
}

- (NSArray *)entries
{
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:SMEntryListKey];
}

- (void)setEntries:(NSArray *)_entries
{
    [[NSUserDefaults standardUserDefaults] setObject:_entries
                                              forKey:SMEntryListKey];
}

- (NSString *)interface
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:SMInterfaceKey];
}

- (void)setInterface:(NSString *)_interface
{
    [[NSUserDefaults standardUserDefaults] setObject:_interface
                                              forKey:SMInterfaceKey];

    if (mainWindow) {
        [[mainWindow amtium] setMac:[self mac]];
    }
}

- (NSString *)ip
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:SMIpKey];
}

- (void)setIp:(NSString *)_ip
{
    [[NSUserDefaults standardUserDefaults] setObject:_ip
                                              forKey:SMIpKey];

    if (mainWindow) {
        [[mainWindow amtium] setIp:_ip];
    }
}

- (NSString *)mac
{
    for (NetworkInterface *ni in interfaces) {
        if ([ni name] == [self interface]) {
            return [ni hardwareAddress];
        }
    }

    return @"000000000000";
}

- (BOOL)ipManual
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SMIpManualKey];
}

- (void)setIpManual:(BOOL)_ipManual
{
    [[NSUserDefaults standardUserDefaults] setBool:_ipManual
                                            forKey:SMIpManualKey];
}

- (BOOL)shouldUseKeychain
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SMKeychainKey];
}

- (void)setShouldUseKeychain:(BOOL)_shouldUseKeychain
{
    [[NSUserDefaults standardUserDefaults] setBool:_shouldUseKeychain
                                            forKey:SMKeychainKey];
}

- (NSArray *)ipAddresses
{
    return ipAddresses;
}

- (NSArray *)interfaces
{
    return interfaces;
}

- (void)setOnline:(BOOL)online
{
    if (online) {
        [statusItem setImage:[NSImage imageNamed:@"status.png"]];
    } else {
        [statusItem setImage:[NSImage imageNamed:@"statusOffline.png"]];
    }
}

@end
