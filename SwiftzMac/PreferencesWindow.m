//
//  PreferencesWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "PreferencesWindow.h"

#import "NetworkInterface.h"

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
        appdelegate = [[NSApplication sharedApplication] delegate];

        entries = [appdelegate entries];
        interfaces = [appdelegate interfaces];
        ips = [appdelegate ipAddresses];
    }
    return self;
}

- (void)showWindow:(id)sender
{
    if ([appdelegate mainWindow] && [[[appdelegate mainWindow] window] isVisible]) {
        [NSApp beginSheet:[[appdelegate preferencesWindow] window]
           modalForWindow:[[appdelegate mainWindow] window]
            modalDelegate:self
           didEndSelector:nil
              contextInfo:nil];
    } else {
        [super showWindow:sender];
    }

    NSLog(@"%@", [appdelegate entries]);

    [[self serverText] setStringValue:[appdelegate server]];
    //[[self entryPopup] setTitle:[appdelegate entry]];

    /*if ([appdelegate ip]) {
        [[self ipCombo] setObjectValue:[appdelegate ip]];
    } else {
        [[self ipCombo] selectItemAtIndex:0];
    }*/
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    //[[self entryPopup] addItemsWithTitles:[appdelegate entries]];
    
    //[[self ipCombo] addItemsWithObjectValues:[appdelegate ipAddresses]];
    

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)ok:(id)sender {
    NSLog(@"ok");

    //[appdelegate setServer:[[self serverText] stringValue]];
    //[appdelegate setEntry:[[self entryPopup] stringValue]];

    //[appdelegate setInterface:@""];

    //[appdelegate setIp:[[self ipCombo] stringValue]];
    //[appdelegate setIpManual:![[appdelegate ipAddresses] containsObject:[appdelegate ip]]];

    [NSApp endSheet:[self window]];
    [self close];
}

- (IBAction)cancel:(id)sender {
    NSLog(@"cancel");
    [NSApp endSheet:[self window]];
    [self close];
}

- (IBAction)restore:(id)sender {
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    NSLog(@"%@", [appDelegate entry]);
}

@end
