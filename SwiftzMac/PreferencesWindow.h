//
//  PreferencesWindow.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const SMInitialKey;
extern NSString * const SMServerKey;
extern NSString * const SMEntryKey;
extern NSString * const SMEntryListKey;
extern NSString * const SMInterfaceKey;
extern NSString * const SMIpKey;
extern NSString * const SMIpManualKey;
extern NSString * const SMKeychainKey;
extern NSString * const SMStatusBarKey;
extern NSString * const SMUsernameKey;

@class AppDelegate;

@interface PreferencesWindow : NSWindowController <NSWindowDelegate> {
    AppDelegate *appdelegate;
    NSArray *entries;
    NSArray *interfaces;
    NSArray *ips;
}

- (IBAction)ok:(id)sender;
- (IBAction)restore:(id)sender;

@end
