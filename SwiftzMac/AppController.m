//
//  AppController.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-27.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppController.h"

#import "Amtium.h"
#import "AmtiumLoginResult.h"

#import "MainWindow.h"
#import "PreferencesWindow.h"
#import "NotificationWindow.h"
#import "UpdateWindow.h"
#import "MessagesWindow.h"
#import "SpinningWindow.h"

#import "AppDelegate.h"

#import "StatisticsAndUpdate.h"

@implementation AppController

static AppController *controller = nil;

@synthesize amtium;
@synthesize mainWindow;
@synthesize preferencesWindow;
@synthesize notificationWindow;
@synthesize updateWindow;
@synthesize messagesWinodw;

+ (AppController *)sharedController
{
    if (controller == nil) {
        controller = [[super allocWithZone:NULL] init];
    }

    return controller;
}

+ (id)alloc
{
    return [self sharedController];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedController];
}

- (id)init
{
    appdelegate = [[NSApplication sharedApplication] delegate];

    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    return [super init];
}

- (void)showMain
{
    [NSApp activateIgnoringOtherApps:YES];
    [[self mainWindow] showWindow:self];
}

- (void)showPreferences
{
    [NSApp activateIgnoringOtherApps:YES];
    [[self preferencesWindow] showWindow:self];
}

- (void)showNotification:(NSString *)notification
{
    NSUserNotification *userNotification = [[NSUserNotification alloc] init];
    [userNotification setTitle:NSLocalizedString(@"MSG_LOGGEDIN", nil)];
    [userNotification setInformativeText:notification];
    [userNotification setHasActionButton:NO];

    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:userNotification];
}

- (void)showUpdate:(NSString *)update
{
    [NSApp activateIgnoringOtherApps:YES];
    [[self updateWindow] setUpdate:update];
    [[self updateWindow] showWindow:self];
    /*NSUserNotification *userNotification = [[NSUserNotification alloc] init];
    [userNotification setTitle:@"Update Avaliable"];
    [userNotification setInformativeText:update];
    [userNotification setHasActionButton:YES];
    [userNotification setActionButtonTitle:@"Update"];

    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:userNotification];*/
}

- (void)showSpinning:(NSString *)message didCancelSelector:(SEL)selector
{
    spinningWindow = [[SpinningWindow alloc] initWithMessage:message
                                                    delegate:self
                                           didCancelSelector:selector];
    
    [NSApp beginSheet:[spinningWindow window]
       modalForWindow:[mainWindow window]
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];
}

- (void)closeSpinning
{
    [NSApp endSheet:[spinningWindow window]];
    [spinningWindow close];
    spinningWindow = nil;
}

- (Amtium *)amtium
{
    return amtium;
}

- (MainWindow *)mainWindow
{
    if (mainWindow == nil) {
        mainWindow = [[MainWindow alloc] init];
    }

    return mainWindow;
}

- (PreferencesWindow *)preferencesWindow
{
    if (preferencesWindow == nil) {
        preferencesWindow = [[PreferencesWindow alloc] init];
    }

    return preferencesWindow;
}

- (NotificationWindow *)notificationWindow
{
    if (notificationWindow == nil) {
        notificationWindow = [[NotificationWindow alloc] init];
    }

    return notificationWindow;
}

- (UpdateWindow *)updateWindow
{
    if (updateWindow == nil) {
        updateWindow = [[UpdateWindow alloc] init];
    }

    return updateWindow;
}

- (MessagesWindow *)messagesWinodw
{
    if (messagesWindow == nil) {
        messagesWindow = [[MessagesWindow alloc] init];
    }

    return messagesWindow;
}

- (void)apply
{
    [amtium setServer:[appdelegate server]];
    [amtium setEntry:[appdelegate entry]];
    [amtium setMac:[appdelegate mac]];
    [amtium setIp:[appdelegate ip]];
}

- (void)online
{
    amtium = [Amtium amtiumWithDelegate:self
                       didErrorSelector:@selector(amtium:didError:)
                       didCloseSelector:@selector(amtium:didCloseWithReason:)];

    BOOL isFirstRun = [appdelegate initialUse];
    BOOL ipDidChange = ![appdelegate ipManual] && ![[appdelegate ipAddresses] containsObject:[appdelegate ip]];

    if (isFirstRun) {
        NSString *preparing = NSLocalizedString(@"MSG_PREPARING", nil);
        [self showSpinning:preparing didCancelSelector:@selector(firstRunDidCancel:)];
        
        [amtium searchServer:@selector(firstRunWithAmtium:didGetServer:)];
    } else if (ipDidChange) {
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"MSG_IPCHANGED", nil)
                                         defaultButton:NSLocalizedString(@"OK", nil)
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@""];
        [alert runModal];
        
        [self showPreferences];
    } else {
        [self apply];
        
        if (didOffline || didSleep) {
            didOffline = NO;
            didSleep = NO;

            [amtium loginWithUsername:[mainWindow username]
                             password:[mainWindow password]
                     didLoginSelector:@selector(resumeWithAmtium:didLoginWithResult:)];
        }
    }
}

- (void)offline
{
    if (amtium != nil) {
        if ([amtium online]) {
            didOffline = YES;
        }
        
        [amtium close];
        
        [appdelegate setOnline:NO];
    }
}

- (void)login
{
    didOffline = NO;
    didSleep = NO;

    NSString *loggingIn = NSLocalizedString(@"MSG_LOGGINGIN", nil);
    [self showSpinning:loggingIn didCancelSelector:@selector(loginDidCancel:)];

    [amtium loginWithUsername:[mainWindow username]
                     password:[mainWindow password]
             didLoginSelector:@selector(amtium:didLoginWithResult:)];
}

- (void)logout
{
    [amtium logout:nil];
    [self showMain];
    [appdelegate setOnline:NO];
}

- (void)account
{
    if ([amtium website] != nil) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[amtium website]]];
    }
}

- (void)sleep
{
    if (amtium != nil) {
        if ([amtium online]) {
            didSleep = YES;
        }

        [amtium logout:nil];
        [amtium close];
        
        [appdelegate setOnline:NO];
    }
}

- (void)wake
{
    // 什么都不用做，等待网络接通
}

- (void)checkUpdate
{
    NSString *update = [StatisticsAndUpdate checkUpdateWithIdenti:[mainWindow username]];
    if (update != nil) {
        NSString *format = NSLocalizedString(@"MSG_UPDATE", nil);
        [self showUpdate:[NSString stringWithFormat:format, update]];
    }
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification
{
    /*if ([notification hasActionButton])
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://xingrz.github.com/SwiftzMac"]];*/
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)loginDidCancel:(id)sender
{
    [amtium cancelLogin];
    [self closeSpinning];
}

- (void)firstRunDidCancel:(id)sender
{
    [self closeSpinning];
    [[NSApplication sharedApplication] terminate:self];
}

- (void)firstRunWithAmtium:(Amtium *)aAmtium didGetServer:(NSString *)server
{
    [appdelegate setServer:server];
    [amtium fetchEntries:@selector(firstRunWithAmtium:didGetEntries:)];
}

- (void)firstRunWithAmtium:(Amtium *)aAmtium didGetEntries:(NSArray *)entries
{
    [appdelegate setEntries:entries];
    [appdelegate setEntry:[entries objectAtIndex:0]];
    [appdelegate setInitialUse:NO];

    [self closeSpinning];
    [self apply];
    [self showPreferences];
}

- (void)amtium:(Amtium *)aAmtium didError:(NSError *)error
{
    if ([error code] == 0) {
        return; // ignore 0
    }

    [self showMain];
    [appdelegate setOnline:NO];

    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"MSG_ERROR", nil)
                                     defaultButton:NSLocalizedString(@"OK", nil)
                                   alternateButton:@""
                                       otherButton:@""
                         informativeTextWithFormat:@"%@", [error localizedDescription]];

    [alert beginSheetModalForWindow:[mainWindow window]
                      modalDelegate:self
                     didEndSelector:nil
                        contextInfo:nil];
}

- (void)amtium:(Amtium *)aAmtium didCloseWithReason:(NSNumber *)reason
{
    [self showMain];
    [appdelegate setOnline:NO];

    NSString *title = NSLocalizedString(@"MSG_DISCONNECTED", nil);
    NSString *message;

    switch ([reason integerValue]) {
        case 0:
            message = NSLocalizedString(@"MSG_DISCONNECTED_0", nil);
            break;

        case 1:
            message = NSLocalizedString(@"MSG_DISCONNECTED_1", nil);
            break;

        case 2:
            message = NSLocalizedString(@"MSG_DISCONNECTED_2", nil);
            break;

        default:
            message = [NSString stringWithFormat:NSLocalizedString(@"MSG_DISCONNECTED_UNKNOWN", nil), reason];
            break;
    }

    NSAlert *alert = [NSAlert alertWithMessageText:title
                                     defaultButton:NSLocalizedString(@"OK", nil)
                                   alternateButton:@""
                                       otherButton:@""
                         informativeTextWithFormat:@"%@", message];

    [alert beginSheetModalForWindow:[mainWindow window]
                      modalDelegate:self
                     didEndSelector:nil
                        contextInfo:nil];
}

- (void)amtium:(Amtium *)aAmtium didLoginWithResult:(AmtiumLoginResult *)result
{
    [self closeSpinning];

    if ([result success]) {
        // 隐藏主窗口
        [mainWindow close];

        // 更新状态栏菜单
        [appdelegate setOnline:YES];

        // 显示通知
        [self showNotification:[result message]];

        // 检查更新
        [self checkUpdate];
    } else {
        NSString *title = NSLocalizedString(@"MSG_LOGINFAILED", nil);

        NSAlert *alert = [NSAlert alertWithMessageText:title
                                         defaultButton:NSLocalizedString(@"OK", nil)
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@"%@", [result message]];

        [alert beginSheetModalForWindow:[mainWindow window]
                          modalDelegate:self
                         didEndSelector:nil
                            contextInfo:nil];
    }
}

- (void)resumeWithAmtium:(Amtium *)aAmtium didLoginWithResult:(AmtiumLoginResult *)result
{
    if ([result success]) {
        // 更新状态栏菜单
        [appdelegate setOnline:YES];

        // 显示通知
        [self showNotification:[result message]];

        // 检查更新
        [self checkUpdate];
    } else {
        [self showMain];
    }
}

@end
