//
//  AppDelegate.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppController;

@class MainWindow;
@class PreferencesWindow;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    AppController *appController;
    MainWindow *mainWindow;
    PreferencesWindow *preferencesWindow;
    NSStatusItem *statusItem;
}

@property (weak) IBOutlet NSMenu *statusMenu;

- (IBAction)showMainWindow:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)showAccount:(id)sender;
- (IBAction)logout:(id)sender;

@end
