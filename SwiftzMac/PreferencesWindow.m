//
//  PreferencesWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "PreferencesWindow.h"

NSString * const SMInitialKey = @"InitialFlag";
NSString * const SMServerKey = @"Server";
NSString * const SMEntryKey = @"Entry";
NSString * const SMEntryListKey = @"EntryList";
NSString * const SMInterfaceKey = @"Interface";
NSString * const SMIpKey = @"IP";
NSString * const SMIpManualKey = @"IPManualFlag";
NSString * const SMKeychainKey = @"KeychainFlag";

@implementation PreferencesWindow

- (id)init
{
    if (![super initWithWindowNibName:@"PreferencesWindow"]) {
        return nil;
    }
    
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)ok:(id)sender {
}

- (IBAction)cancel:(id)sender {
}

- (IBAction)restore:(id)sender {
}

- (BOOL)isInitialUse
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:SMInitialKey];
}

- (NSString *)server
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:SMServerKey];
}

- (NSString *)entry
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:SMEntryKey];
}

- (NSArray *)entryList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringArrayForKey:SMEntryListKey];
}

- (NSString *)interface
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:SMInterfaceKey];
}

- (NSString *)ip
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:SMIpKey];
}

- (BOOL)isIpManual
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:SMIpManualKey];
}

- (BOOL)shouldUseKeychain
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:SMKeychainKey];
}

@end
