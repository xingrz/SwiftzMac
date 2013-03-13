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
}

- (IBAction)ok:(id)sender {
    NSLog(@"ok");

    if ([appdelegate ipManual]) {
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"MSG_MANUALIP", @"")
                                         defaultButton:NSLocalizedString(@"MSG_MANUALIP_YES", @"")
                                       alternateButton:NSLocalizedString(@"MSG_MANUALIP_NO", @"")
                                           otherButton:@""
                             informativeTextWithFormat:NSLocalizedString(@"MSG_MANUALIP_DESC", @"")];

        [alert beginSheetModalForWindow:[self window]
                          modalDelegate:self
                         didEndSelector:@selector(manualIpAlertDidEnd:returnCode:contextInfo:)
                            contextInfo:nil];

        return;
    }

    [NSApp endSheet:[self window]];
    [self close];
}

- (void)manualIpAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == NSAlertDefaultReturn) {
        [NSApp endSheet:[self window]];
        [self close];
    }
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
