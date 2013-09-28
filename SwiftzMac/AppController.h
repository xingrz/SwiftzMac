//
//  AppController.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-27.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Amtium.h"

extern NSString * const kSMOnlineChangedNotification;

@class MainWindow;
@class PreferencesWindow;
@class NotificationWindow;
@class UpdateWindow;
@class SpinningWindow;

@class AppDelegate;

@interface AppController : NSObject <AmtiumDelegate, NSUserNotificationCenterDelegate> {
    Amtium *amtium;

    MainWindow *mainWindow;
    PreferencesWindow *preferencesWindow;
    NotificationWindow *notificationWindow;
    UpdateWindow *updateWindow;
    SpinningWindow *spinningWindow;

    AppDelegate *appdelegate;

    BOOL didSleep;
    BOOL didOffline;
}

@property (readonly) Amtium *amtium;
@property (readonly) MainWindow *mainWindow;
@property (readonly) PreferencesWindow *preferencesWindow;
@property (readonly) NotificationWindow *notificationWindow;
@property (readonly) UpdateWindow *updateWindow;

+ (AppController *)sharedController;

- (void)showMain;
- (void)showPreferences;
- (void)showPreferencesWithTab:(id)identifier;
- (void)showNotification:(NSString *)notification;
- (void)showUpdate:(NSString *)update;
- (void)showSpinning:(NSString *)message didCancelSelector:(SEL)selector;
- (void)closeSpinning;

- (void)online;
- (void)offline;

- (void)login;
- (void)logout;
- (void)account;

- (void)sleep;
- (void)wake;

- (void)apply;

@end
