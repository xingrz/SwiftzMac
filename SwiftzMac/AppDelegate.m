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
    // 加载用户配置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self setInitialUse:[defaults boolForKey:SMInitialKey]];
    [self setServer:[defaults stringForKey:SMServerKey]];
    [self setEntry:[defaults stringForKey:SMEntryKey]];
    [self setEntries:[defaults stringArrayForKey:SMEntryListKey]];
    [self setInterface:[defaults stringForKey:SMInterfaceKey]];
    [self setIp:[defaults stringForKey:SMIpKey]];
    [self setIpManual:[defaults boolForKey:SMIpManualKey]];
    [self setShouldUseKeychain:[defaults boolForKey:SMKeychainKey]];

    // 初始化状态栏菜单
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:[self statusMenu]];
    [statusItem setTitle:@"Swiftz"];
    [statusItem setHighlightMode:YES];

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
    
    //[preferencesWindow showWindow:self];

    if (mainWindow && [[mainWindow window] isVisible]) {
        [NSApp beginSheet:[preferencesWindow window]
           modalForWindow:[mainWindow window]
            modalDelegate:self
           didEndSelector:nil
              contextInfo:nil];
    } else {
        [preferencesWindow showWindow:self];
    }
}

- (IBAction)showAccount:(id)sender
{
    [mainWindow account:sender];
}

- (IBAction)logout:(id)sender
{
    [mainWindow logout:sender];
}

@end
