//
//  AppDelegate.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NotificationWindow;
@class UpdateWindow;
@class MessagesWindow;
@class Reachability;

@class AppController;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    AppController *controller;

    NSStatusItem *statusItem;
    NSArray *ipAddresses;
    NSArray *interfaces;
    Reachability *reachability;
}

@property (weak) IBOutlet NSMenu *statusMenu;

@property BOOL initialUse;
@property NSString *username;
@property NSString *server;
@property NSString *entry;
@property NSArray *entries;
@property NSString *interface;
@property NSString *ip;
@property (readonly) NSString *mac;
@property (readonly) BOOL ipManual;
@property BOOL shouldUseKeychain;
@property BOOL shouldShowStatusBarMenu;
@property (readonly) NSArray *ipAddresses;
@property (readonly) NSArray *interfaces;

- (IBAction)showMainWindow:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)showAccount:(id)sender;
- (IBAction)showMessagesWindow:(id)sender;
- (IBAction)logout:(id)sender;

- (void)setOnline:(BOOL)online;

@end
