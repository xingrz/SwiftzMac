//
//  MainWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "SpinningWindow.h"

#import "Amtium.h"
#import "SSKeychain.h"
#import "StatisticsAndUpdate.h"

@implementation MainWindow

- (id)init
{
    if (![super initWithWindowNibName:@"MainWindow"]) {
        return nil;
    }
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        appdelegate = [[NSApplication sharedApplication] delegate];

        amtium = [[Amtium alloc] initWithDelegate:self
                                 didErrorSelector:@selector(amtiumDidError:)
                                 didCloseSelector:@selector(amtiumDidClose:)];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    if ([appdelegate initialUse]) {
        // 如果是初次使用，执行初始化过程

        spinningWindow = [[SpinningWindow alloc]
                          initWithMessage:NSLocalizedString(@"MSG_PREPARING", @"Preparing...")
                          delegate:self
                          didCancelSelector:@selector(initialDidCancel:)];

        [NSApp beginSheet:[spinningWindow window]
           modalForWindow:[self window]
            modalDelegate:self
           didEndSelector:nil
              contextInfo:nil];

        [amtium searchServer:@selector(initialStepOneWithServer:)];
    } else if (![appdelegate ipManual] && ![[appdelegate ipAddresses] containsObject:[appdelegate ip]]) {
        // 如果不是手动指定IP且IP不在列表中，说明IP已变更，提示重新设置
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"MSG_IPCHANGED", @"")
                                         defaultButton:NSLocalizedString(@"OK", @"")
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@""];

        [alert runModal];
        [appdelegate showPreferencesWindow:self];
    } else {
        [self applyPreferences];
        
        if ([appdelegate shouldUseKeychain]) {
            NSArray *accounts = [SSKeychain accountsForService:@"SwiftzMac"];
            if (accounts != nil && [accounts count] > 0) {
                NSDictionary *account = [accounts objectAtIndex:0];

                NSError *keychainError = nil;

                NSString *username = [account objectForKey:@"acct"];
                NSString *password = [SSKeychain passwordForService:@"SwiftzMac"
                                                            account:username
                                                              error:&keychainError];

                if (keychainError != nil) {
                    [appdelegate setShouldUseKeychain:NO];
                }

                [[self username] setStringValue:username];
                [[self password] setStringValue:password];
            }
        }
    }
}

- (void)applyPreferences
{
    [amtium setServer:[appdelegate server]];
    [amtium setEntry:[appdelegate entry]];
    [amtium setMac:[appdelegate mac]];
    [amtium setIp:[appdelegate ip]];
}

- (void)initialStepOneWithServer:(NSString *)server
{
    [appdelegate setServer:server];
    [amtium fetchEntries:@selector(initialStepTwoWithEntries:)];
}

- (void)initialStepTwoWithEntries:(NSArray *)entries
{
    [appdelegate setEntries:entries];

    NSString *firstEntry = [entries objectAtIndex:0];
    [appdelegate setEntry:firstEntry];

    [NSApp endSheet:[spinningWindow window]];
    [spinningWindow close];
    spinningWindow = nil;

    [self applyPreferences];

    [appdelegate setInitialUse:NO];
    [appdelegate showPreferencesWindow:self];
}

- (void)initialDidCancel:(id)sender
{
    [NSApp endSheet:[spinningWindow window]];
    [spinningWindow close];
    spinningWindow = nil;
    
    [[NSApplication sharedApplication] terminate:self];
}

- (IBAction)login:(id)sender
{
    NSLog(@"login");

    spinningWindow = [[SpinningWindow alloc]
                      initWithMessage:NSLocalizedString(@"MSG_LOGGINGIN", @"Logging in...")
                      delegate:self
                      didCancelSelector:@selector(loginDidCancel:)];

    [NSApp beginSheet:[spinningWindow window]
       modalForWindow:[self window]
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];

    [self applyPreferences];

    [amtium loginWithUsername:[[self username] stringValue]
                     password:[[self password] stringValue]
               didEndSelector:@selector(didLoginWithSuccess:message:)];
}

- (void)loginDidCancel:(id)sender
{
    [NSApp endSheet:[spinningWindow window]];
    [spinningWindow close];
    spinningWindow = nil;
}

- (void)didLoginWithSuccess:(NSNumber *)success
                    message:(NSString *)message
{
    [NSApp endSheet:[spinningWindow window]];
    [spinningWindow close];
    spinningWindow = nil;

    if ([success boolValue]) {
        [self close];
        [appdelegate setOnline:YES];
        [appdelegate showNotification:message];

        if ([appdelegate shouldUseKeychain]) {
            [SSKeychain setPassword:[[self password] stringValue]
                         forService:@"SwiftzMac"
                            account:[[self username] stringValue]];
        }

        NSString *update = [StatisticsAndUpdate checkUpdateWithIdenti:[[self username] stringValue]];
        if (update != nil) {
            NSString *format = NSLocalizedString(@"MSG_UPDATE", @"");
            [appdelegate showUpdate:[NSString stringWithFormat:format, update]];
        }
    } else {
        NSString *title = NSLocalizedString(@"MSG_LOGINFAILED", @"Login failed.");

        NSAlert *alert = [NSAlert alertWithMessageText:title
                                         defaultButton:NSLocalizedString(@"OK", @"OK")
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@"%@", message];

        [alert beginSheetModalForWindow:[self window]
                          modalDelegate:self
                         didEndSelector:nil
                            contextInfo:nil];
    }
}

- (IBAction)logout:(id)sender
{
    NSLog(@"logout");
    [amtium logout:nil];
    [appdelegate showMainWindow:sender];
    [appdelegate setOnline:NO];
}

- (IBAction)account:(id)sender
{
    NSLog(@"show account");
    if ([amtium website] != nil) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[amtium website]]];
    }
}

- (Amtium *)amtium
{
    return amtium;
}

- (void)amtiumDidClose:(NSNumber *)reason
{
    [appdelegate showMainWindow:self];
    [appdelegate setOnline:NO];

    NSString *title = NSLocalizedString(@"MSG_DISCONNECTED", nil);
    NSString *message;

    switch ([reason integerValue]) {
        case 0:
            message = NSLocalizedString(@"MSG_DISCONNECTED_0", nil);
            break;

        case 1:
            message = NSLocalizedString(@"MSG_DISCONNECTED_1", nil);
            break;

        case 2:
            message = NSLocalizedString(@"MSG_DISCONNECTED_2", nil);
            break;
            
        default:
            message = [NSString stringWithFormat:NSLocalizedString(@"MSG_DISCONNECTED_UNKNOWN", nil), reason];
            break;
    }

    NSAlert *alert = [NSAlert alertWithMessageText:title
                                     defaultButton:NSLocalizedString(@"OK", nil)
                                   alternateButton:@""
                                       otherButton:@""
                         informativeTextWithFormat:@"%@", message];

    [alert beginSheetModalForWindow:[self window]
                      modalDelegate:self
                     didEndSelector:nil
                        contextInfo:nil];

    // TODO: 自动重新登录
}

- (void)amtiumDidError:(NSError *)error
{
    [appdelegate showMainWindow:self];
    [appdelegate setOnline:NO];

    NSLog(@"error code: %ld", [error code]);
    
    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"MSG_ERROR", nil)
                                     defaultButton:NSLocalizedString(@"OK", nil)
                                   alternateButton:@""
                                       otherButton:@""
                         informativeTextWithFormat:@"%@", [error localizedDescription]];

    [alert beginSheetModalForWindow:[self window]
                      modalDelegate:self
                     didEndSelector:nil
                        contextInfo:nil];
}

- (void)windowWillClose:(NSNotification *)notification
{
    if (![amtium online]) {
        [[NSApplication sharedApplication] terminate:self];
    }
}

@end
