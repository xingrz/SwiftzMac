//
//  AppDelegate.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Amtium.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSComboBox *username;
@property (weak) IBOutlet NSSecureTextField *password;
@property (weak) IBOutlet NSButton *remember;
@property (weak) IBOutlet NSButton *autologin;
@property (weak) IBOutlet NSTextField *account;
@property (weak) IBOutlet NSProgressIndicator *loading;
@property (weak) IBOutlet NSButton *login;
@property (weak) IBOutlet NSButton *logout;

@property Amtium *amtium;

- (IBAction)checkRemember:(id)sender;
- (IBAction)checkAutologin:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;

@end
