//
//  PreferencesWindow.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindow : NSWindowController

@property (weak) IBOutlet NSTextField *server;
@property (weak) IBOutlet NSPopUpButton *entry;
@property (weak) IBOutlet NSButton *shouldStore;
@property (weak) IBOutlet NSButton *shouldRetry;
@property (strong) IBOutlet NSWindow *interface;
@property (strong) IBOutlet NSWindow *ip;

- (IBAction)ok:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)restore:(id)sender;

@end
