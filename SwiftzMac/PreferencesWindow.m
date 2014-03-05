//
//  PreferencesWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"
#import "AppController.h"

#import "AppData.h"

#import "MainWindow.h"
#import "PreferencesWindow.h"

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
    }
    return self;
}

- (void)showWindow:(id)sender
{
    // 艹他个蛋，谁能告诉我为什么 App Delegate 的值变化之后这些文本框的值不会跟着变？！
    if ([self.server.stringValue isEqual: @""] || self.entries.itemTitles.count == 0) {
        [self.server setStringValue:[AppData instance].server];
        [self.entries addItemsWithTitles:[AppData instance].entries];
        //[self.entries setStringValue:appdelegate.entries[0]];
    }
    
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

- (void)showWindow:(id)sender withTabIdentifier:(id)identifier
{
    [self showWindow:sender];
    [self.tab selectTabViewItemWithIdentifier:identifier];
}

- (IBAction)ok:(id)sender {
    if (![[AppData instance].addresses containsObject:[AppData instance].address]) {
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
    [appdelegate apply];
}

- (void)manualIpAlertDidEnd:(NSAlert *)alert
                 returnCode:(NSInteger)returnCode
                contextInfo:(void *)contextInfo
{
    if (returnCode == NSAlertDefaultReturn) {
        [NSApp endSheet:[self window]];
        [self close];
        [appdelegate apply];
    }
}

- (IBAction)restore:(id)sender {
}

@end
