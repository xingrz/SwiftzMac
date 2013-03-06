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

@interface PreferencesWindow : NSWindowController

@property (weak) IBOutlet NSTextField *serverText;
@property (weak) IBOutlet NSPopUpButton *entryPopup;
@property (weak) IBOutlet NSButton *shouldStoreCheckbox;
@property (weak) IBOutlet NSButton *shouldRetryCheckbox;
@property (weak) IBOutlet NSPopUpButton *interfacePopup;
@property (weak) IBOutlet NSComboBox *ipCombo;

- (IBAction)ok:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)restore:(id)sender;

- (BOOL)isInitialUse;
- (NSString *)server;
- (NSString *)entry;
- (NSArray *)entryList;
- (NSString *)interface;
- (NSString *)ip;
- (BOOL)isIpManual;
- (BOOL)shouldUseKeychain;

@end
