//
//  PreferencesWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"
#import "AppController.h"
#import "MainWindow.h"
#import "PreferencesWindow.h"

NSString * const SMInitialKey = @"InitialFlag";
NSString * const SMServerKey = @"Server";
NSString * const SMEntryKey = @"Entry";
NSString * const SMEntryListKey = @"EntryList";
NSString * const SMInterfaceKey = @"Interface";
NSString * const SMIpKey = @"IP";
NSString * const SMIpManualKey = @"IPManualFlag";
NSString * const SMKeychainKey = @"KeychainFlag";
NSString * const SMStatusBarKey = @"StatusBarFlag";
NSString * const SMUsernameKey = @"Username";

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
    MainWindow *mainWinodw = [[AppController sharedController] mainWindow];
    
    if (mainWinodw != nil && [[mainWinodw window] isVisible]) {
        [NSApp beginSheet:[self window]
           modalForWindow:[mainWinodw window]
            modalDelegate:self
           didEndSelector:nil
              contextInfo:nil];
    } else {
        [super showWindow:sender];
    }
}

- (IBAction)ok:(id)sender {
    if ([appdelegate ipManual]) {
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"MSG_MANUALIP", nil)
                                         defaultButton:NSLocalizedString(@"MSG_MANUALIP_YES", nil)
                                       alternateButton:NSLocalizedString(@"MSG_MANUALIP_NO", nil)
                                           otherButton:@""
                             informativeTextWithFormat:NSLocalizedString(@"MSG_MANUALIP_DESC", nil)];

        [alert beginSheetModalForWindow:[self window]
                          modalDelegate:self
                         didEndSelector:@selector(manualIpAlertDidEnd:returnCode:contextInfo:)
                            contextInfo:nil];

        return;
    }

    [NSApp endSheet:[self window]];
    [self close];
}

- (void)manualIpAlertDidEnd:(NSAlert *)alert
                 returnCode:(NSInteger)returnCode
                contextInfo:(void *)contextInfo
{
    if (returnCode == NSAlertDefaultReturn) {
        [NSApp endSheet:[self window]];
        [self close];
    }
}

- (IBAction)restore:(id)sender {
}

@end
