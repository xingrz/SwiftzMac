//
//  AppDelegate.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindow;
@class PreferencesWindow;
@class NotificationWindow;
@class UpdateWindow;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    MainWindow *mainWindow;
    PreferencesWindow *preferencesWindow;
    NotificationWindow *notificationWindow;
    UpdateWindow *updateWindow;
    NSStatusItem *statusItem;
    NSArray *ipAddresses;
    NSArray *interfaces;
}

@property (weak) IBOutlet NSMenu *statusMenu;

@property (readonly) MainWindow *mainWindow;
@property (readonly) PreferencesWindow *preferencesWindow;

@property BOOL initialUse;
@property NSString *server;
@property NSString *entry;
@property NSArray *entries;
@property NSString *interface;
@property NSString *ip;
@property (readonly) NSString *mac;
@property (readonly) BOOL ipManual;
@property BOOL shouldUseKeychain;
@property (readonly) NSArray *ipAddresses;
@property (readonly) NSArray *interfaces;

- (IBAction)showMainWindow:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;
- (void)showNotification:(NSString *)message;
- (void)showUpdate:(NSString *)update;
- (IBAction)showAccount:(id)sender;
- (IBAction)logout:(id)sender;

- (void)showNotification:(NSString *)message;
- (void)setOnline:(BOOL)online;

@end
