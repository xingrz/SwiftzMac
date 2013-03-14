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
#import "SSKeychain.h"

#import "MainWindow.h"
#import "PreferencesWindow.h"
#import "NotificationWindow.h"
#import "UpdateWindow.h"

@implementation AppDelegate

+ (void)initialize
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:SMInitialKey];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:SMIpManualKey];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:SMKeychainKey];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:SMStatusBarKey];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if ([self shouldShowStatusBarMenu]) {
        statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        [statusItem setMenu:[self statusMenu]];
        [statusItem setAlternateImage:[NSImage imageNamed:@"statusAlternate.png"]];
        [statusItem setHighlightMode:YES];
        [self setOnline:NO];
    }

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
            NSString *format = NSLocalizedString(@"MENU_ACCOUNT", nil);
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
    [NSApp activateIgnoringOtherApps:YES];
    [[self mainWindow] showWindow:self];
}

- (IBAction)showPreferencesWindow:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [[self preferencesWindow] showWindow:self];
}

- (void)showNotification:(NSString *)message
{
    if (!notificationWindow) {
        notificationWindow = [[NotificationWindow alloc] init];
    }

    [notificationWindow setMessage:message];
    [notificationWindow showWindow:self];
}

- (void)showUpdate:(NSString *)update
{
    if (!updateWindow) {
        updateWindow = [[UpdateWindow alloc] init];
    }

    [NSApp activateIgnoringOtherApps:YES];
    [updateWindow setUpdate:update];
    [updateWindow showWindow:self];
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
    NSString *theEntry = [[NSUserDefaults standardUserDefaults] stringForKey:SMEntryKey];
    if (theEntry == nil) {
        if ([self entries] != nil) {
            theEntry = [[self entries] objectAtIndex:0];
        }
    }
    
    return theEntry;
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
    NSString *theInterface = [[NSUserDefaults standardUserDefaults] stringForKey:SMInterfaceKey];
    if (theInterface == nil) {
        theInterface = [[[self interfaces] objectAtIndex:0] name];
        [self setInterface:theInterface];
    }

    return theInterface;
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
    NSString *theIp = [[NSUserDefaults standardUserDefaults] stringForKey:SMIpKey];
    if (theIp == nil) {
        theIp = [[self ipAddresses] objectAtIndex:0];
        [self setIp:theIp];
    }

    return theIp;
}

- (void)setIp:(NSString *)_ip
{
    [[NSUserDefaults standardUserDefaults] setObject:_ip
                                              forKey:SMIpKey];

    [[NSUserDefaults standardUserDefaults] setBool:![ipAddresses containsObject:_ip]
                                            forKey:SMIpManualKey];
    
    if (mainWindow) {
        [[mainWindow amtium] setIp:_ip];
    }
}

- (NSString *)mac
{
    for (NetworkInterface *ni in interfaces) {
        if ([[ni name] isEqualToString:[self interface]]) {
            return [ni hardwareAddress];
        }
    }

    return @"000000000000";
}

- (BOOL)ipManual
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SMIpManualKey];
}

- (BOOL)shouldUseKeychain
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SMKeychainKey];
}

- (void)setShouldUseKeychain:(BOOL)_shouldUseKeychain
{
    [[NSUserDefaults standardUserDefaults] setBool:_shouldUseKeychain
                                            forKey:SMKeychainKey];

    if (!_shouldUseKeychain) {
        NSArray *accounts = [SSKeychain accountsForService:@"SwiftzMac"];
        if (accounts != nil && [accounts count] > 0) {
            for (NSDictionary *account in accounts) {
                [SSKeychain deletePasswordForService:@"SwiftzMac" account:[account objectForKey:@"acct"]];
            }
        }
    }
}

- (BOOL)shouldShowStatusBarMenu
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SMStatusBarKey];
}

- (void)setShouldShowStatusBarMenu:(BOOL)_shouldShowStatusBarMenu
{
    [[NSUserDefaults standardUserDefaults] setBool:_shouldShowStatusBarMenu
                                            forKey:SMStatusBarKey];
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
        [statusItem setToolTip:[[[self mainWindow] amtium] account]];
    } else {
        [statusItem setImage:[NSImage imageNamed:@"statusOffline.png"]];
        [statusItem setToolTip:nil];
    }
}

@end
