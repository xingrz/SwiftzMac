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
    NSArray *entries;
    NSString *server;
    Reachability *reachability;
}

@property (weak) IBOutlet NSMenu *statusMenu;

- (IBAction)showMainWindow:(id)sender;
- (IBAction)showGeneralSettings:(id)sender;
- (IBAction)showNetworkSettings:(id)sender;
- (IBAction)showAccount:(id)sender;
- (IBAction)logout:(id)sender;

- (void)apply;

@end
