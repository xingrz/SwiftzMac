//
//  AppDelegate.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"

#import "AppController.h"

#import "Amtium.h"
#import "NetworkInterface.h"
#import "SSKeychain.h"
#import "Reachability.h"

#import "MainWindow.h"
#import "PreferencesWindow.h"
#import "NotificationWindow.h"
#import "UpdateWindow.h"
#import "MessagesWindow.h"

@implementation AppDelegate

- (id)init
{
    self = [super init];

    controller = [AppController sharedController];

    // 注册默认设定
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

    [defaults setObject:[NSNumber numberWithBool:YES] forKey:SMInitialKey];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:SMIpManualKey];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:SMKeychainKey];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:SMStatusBarKey];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    // 注册睡眠通知
    NSNotificationCenter *notification = [[NSWorkspace sharedWorkspace] notificationCenter];
    [notification addObserver:self
                     selector:@selector(workspaceWillSleep:)
                         name:NSWorkspaceWillSleepNotification
                       object:nil];
    [notification addObserver:self
                     selector:@selector(workspaceDidWake:)
                         name:NSWorkspaceDidWakeNotification
                       object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    // 监听网络连通性
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability setReachableOnWWAN:NO];
    [reachability startNotifier];

    return self;
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

    [controller showMain];

    if ([reachability currentReachabilityStatus] != NotReachable) {
        [self determineNetwork];
        [controller online];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    if ([[[AppController sharedController] amtium] online]) {
        [[[AppController sharedController] amtium] logout:nil];
    }
}

- (void)workspaceWillSleep:(NSNotification *)aNotification
{
    [controller sleep];
}

- (void)workspaceDidWake:(NSNotification *)aNotification
{
    [controller wake];
}

- (void)reachabilityChanged:(NSNotification *)aNotification
{
    if ([reachability currentReachabilityStatus] == NotReachable) {
        [controller offline];
    } else {
        [self determineNetwork];
        [controller online];
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    Amtium *amtium = [controller amtium];
    
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
            NSString *account = [amtium account];
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

- (void)determineNetwork
{
    [self willChangeValueForKey:@"ipAddresses"];
    ipAddresses = [NetworkInterface getAllIpAddresses];
    [self didChangeValueForKey:@"ipAddresses"];

    [self willChangeValueForKey:@"interfaces"];
    interfaces = [NetworkInterface getAllInterfaces];
    [self didChangeValueForKey:@"interfaces"];
}

- (void)showNotification:(NSString *)message
{
    NSUserNotification *userNotification = [[NSUserNotification alloc] init];
    [userNotification setTitle:NSLocalizedString(@"MSG_LOGGEDIN", nil)];
    [userNotification setInformativeText:message];
    [userNotification setHasActionButton:NO];

    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:userNotification];
}

- (void)showMainWindow:(id)sender
{
    [controller showMain];
}

- (void)showPreferencesWindow:(id)sender
{
    [controller showPreferences];
}

- (IBAction)showAccount:(id)sender
{
    [controller account];
}

- (void)showMessagesWindow:(id)sender
{
    // ...
}

- (IBAction)logout:(id)sender
{
    [controller logout];
}

- (BOOL)initialUse
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SMInitialKey];
}

- (void)setInitialUse:(BOOL)_initialUse
{
    [self willChangeValueForKey:@"initialUse"];
    
    [[NSUserDefaults standardUserDefaults] setBool:_initialUse
                                            forKey:SMInitialKey];

    [self didChangeValueForKey:@"initialUse"];
}

- (NSString *)username
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:SMUsernameKey];
}

- (void)setUsername:(NSString *)_username
{
    [self willChangeValueForKey:@"username"];

    [[NSUserDefaults standardUserDefaults] setObject:_username
                                              forKey:SMUsernameKey];

    [self didChangeValueForKey:@"username"];
}

- (NSString *)server
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:SMServerKey];
}

- (void)setServer:(NSString *)_server
{
    [self willChangeValueForKey:@"server"];

    [[NSUserDefaults standardUserDefaults] setObject:_server
                                              forKey:SMServerKey];

    [self didChangeValueForKey:@"server"];

    [[controller amtium] setServer:_server];
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
    [self willChangeValueForKey:@"entry"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_entry
                                              forKey:SMEntryKey];

    [self didChangeValueForKey:@"entry"];

    [[controller amtium] setEntry:_entry];
}

- (NSArray *)entries
{
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:SMEntryListKey];
}

- (void)setEntries:(NSArray *)_entries
{
    [self willChangeValueForKey:@"entries"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_entries
                                              forKey:SMEntryListKey];

    [self didChangeValueForKey:@"entries"];
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
    [self willChangeValueForKey:@"interface"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_interface
                                              forKey:SMInterfaceKey];
    
    [self didChangeValueForKey:@"interface"];
    
    [[controller amtium] setMac:[self mac]];
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
    [self willChangeValueForKey:@"ip"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_ip
                                              forKey:SMIpKey];
    
    [self didChangeValueForKey:@"ip"];

    [self willChangeValueForKey:@"ipManual"];

    [[NSUserDefaults standardUserDefaults] setBool:![ipAddresses containsObject:_ip]
                                            forKey:SMIpManualKey];

    [self didChangeValueForKey:@"ipManual"];
    
    [[controller amtium] setIp:_ip];
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
    [self willChangeValueForKey:@"shouldUseKeychain"];
    
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

    [self didChangeValueForKey:@"shouldUseKeychain"];
}

- (BOOL)shouldShowStatusBarMenu
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SMStatusBarKey];
}

- (void)setShouldShowStatusBarMenu:(BOOL)_shouldShowStatusBarMenu
{
    [self willChangeValueForKey:@"shouldShowStatusBarMenu"];
    
    [[NSUserDefaults standardUserDefaults] setBool:_shouldShowStatusBarMenu
                                            forKey:SMStatusBarKey];

    [self didChangeValueForKey:@"shouldShowStatusBarMenu"];
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
        [statusItem setToolTip:[[controller amtium] account]];
    } else {
        [statusItem setImage:[NSImage imageNamed:@"statusOffline.png"]];
        [statusItem setToolTip:nil];
    }
}

@end
