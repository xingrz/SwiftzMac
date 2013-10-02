//
//  PreferencesWindow.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppDelegate;

@interface PreferencesWindow : NSWindowController <NSWindowDelegate> {
    AppDelegate *appdelegate;
}

@property (weak) IBOutlet NSTabView *tab;
@property (weak) IBOutlet NSTextField *server;
@property (weak) IBOutlet NSPopUpButton *entries;

- (IBAction)ok:(id)sender;
- (IBAction)restore:(id)sender;

- (void)showWindow:(id)sender
 withTabIdentifier:(id)identifier;

@end
