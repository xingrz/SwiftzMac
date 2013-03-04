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

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    MainWindow *mainWindow;
    PreferencesWindow *preferencesWindow;
    NSStatusItem *statusItem;
}

@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSMenuItem *accountMenuItem;
@property (weak) IBOutlet NSMenuItem *logoutMenuItem;
@property (weak) IBOutlet NSMenuItem *loginMenuItem;

- (IBAction)showMainWindow:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;

- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;

@end
