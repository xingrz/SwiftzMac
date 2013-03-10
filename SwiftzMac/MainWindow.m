//
//  MainWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "PreparingWindow.h"

#import "Amtium.h"

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
        
        [appdelegate setInitialUse:NO];
        
        preparingWindow = [[PreparingWindow alloc] init];
        [NSApp beginSheet:[preparingWindow window]
           modalForWindow:[self window]
            modalDelegate:self
           didEndSelector:nil
              contextInfo:nil];

        [amtium searchServer:@selector(initialStepOneWithServer:)];
    } else if (![appdelegate ipManual] && ![[appdelegate ipAddresses] containsObject:[appdelegate ip]]) {
        // 如果不是手动指定IP且IP不在列表中，说明IP已变更，提示重新设置

        [appdelegate showPreferencesWindow:self];
    }
}

- (void)initialStepOneWithServer:(NSString *)server
{
    NSLog(@"got server: %@", server);
    [appdelegate setServer:server];
    [amtium fetchEntries:@selector(initialStepTwoWithEntries:)];
}

- (void)initialStepTwoWithEntries:(NSArray *)entries
{
    [appdelegate setEntries:entries];

    NSString *firstEntry = [entries objectAtIndex:0];
    [appdelegate setEntry:firstEntry];

    [NSApp endSheet:[preparingWindow window]];
    [preparingWindow close];
    preparingWindow = nil;

    [appdelegate showPreferencesWindow:self];
}

- (IBAction)login:(id)sender
{
    NSLog(@"login");
    [amtium loginWithUsername:[[self username] stringValue]
                     password:[[self password] stringValue]
               didEndSelector:@selector(didLoginWithSuccess:message:)];
}

- (void)didLoginWithSuccess:(NSNumber *)success
                    message:(NSString *)message
{
    if ([success boolValue]) {
        [self close];
    } else {
        if (message == nil) {
            message = @"Login failed.";
        }

        NSAlert *alert = [NSAlert alertWithMessageText:message
                                         defaultButton:@"OK"
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@""];

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
}

- (IBAction)account:(id)sender
{
    NSLog(@"show account");
}

- (Amtium *)amtium
{
    return amtium;
}

- (void)amtiumDidClose:(NSNumber *)reason
{
    [amtium logout:nil];
    [appdelegate showMainWindow:self];

    NSAlert *alert = [NSAlert alertWithMessageText:@"Disconnected."
                                     defaultButton:@"OK"
                                   alternateButton:@""
                                       otherButton:@""
                         informativeTextWithFormat:@"Reason code: %@", reason];

    [alert beginSheetModalForWindow:[self window]
                      modalDelegate:self
                     didEndSelector:nil
                        contextInfo:nil];

    // TODO: 自动重新登录
}

- (void)amtiumDidError:(NSError *)error
{
    [amtium logout:nil];
    [appdelegate showMainWindow:self];

    NSAlert *alert = [NSAlert alertWithMessageText:@"An error occured."
                                     defaultButton:@"OK"
                                   alternateButton:@""
                                       otherButton:@""
                         informativeTextWithFormat:@""];

    [alert beginSheetModalForWindow:[self window]
                      modalDelegate:self
                     didEndSelector:nil
                        contextInfo:nil];
}

- (void)windowWillClose:(NSNotification *)notification
{
    NSLog(@"will close");
    if (![amtium online]) {
        [[NSApplication sharedApplication] terminate:self];
    }
}

@end
