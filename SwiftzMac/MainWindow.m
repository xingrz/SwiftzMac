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
#import "AmtiumLoginResult.h"

#import "SSKeychain.h"
#import "StatisticsAndUpdate.h"

@implementation MainWindow

@synthesize accounts;
@synthesize username;
@synthesize password;

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
    }
    
    return self;
}

- (void)windowDidLoad
{
    // 应用偏好设置
    [self applyPreferences];

    // 加载钥匙串
    if ([appdelegate shouldUseKeychain]) {
        [self willChangeValueForKey:@"accounts"];

        NSMutableArray *result = [[NSMutableArray alloc] init];
        NSArray *keychain = [SSKeychain accountsForService:@"SwiftzMac"];
        if (keychain != nil && [keychain count] > 0) {
            for (NSDictionary *account in keychain) {
                [result addObject:[account objectForKey:@"acct"]];
            }
        }
        accounts = result;

        [self didChangeValueForKey:@"accounts"];

        NSString *theUsername = [appdelegate username];
        if (theUsername == nil) theUsername = [result objectAtIndex:0];
        [self setUsername:theUsername];
    }
}

- (void)applyPreferences
{
    [amtium setServer:[appdelegate server]];
    [amtium setEntry:[appdelegate entry]];
    [amtium setMac:[appdelegate mac]];
    [amtium setIp:[appdelegate ip]];
}

- (void)initialWithAmtium:(Amtium *)amtium didGetServer:(NSString *)server
{
    [appdelegate setServer:server];
    [[self amtium] fetchEntries:@selector(initialWithAmtium:didGetEntries:)];
}

- (void)initialWithAmtium:(Amtium *)amtium didGetEntries:(NSArray *)entries
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
                      initWithMessage:NSLocalizedString(@"MSG_LOGGINGIN", nil)
                      delegate:self
                      didCancelSelector:@selector(loginDidCancel:)];

    [NSApp beginSheet:[spinningWindow window]
       modalForWindow:[self window]
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];

    [self applyPreferences];

    [amtium loginWithUsername:[self username]
                     password:[self password]
             didLoginSelector:@selector(amtium:didLoginWithResult:)];
}

- (void)loginDidCancel:(id)sender
{
    [NSApp endSheet:[spinningWindow window]];
    [spinningWindow close];
    spinningWindow = nil;
}

- (void)amtium:(Amtium *)amtium didLoginWithResult:(AmtiumLoginResult *)result
{
    [NSApp endSheet:[spinningWindow window]];
    [spinningWindow close];
    spinningWindow = nil;

    if ([result success]) {

        // 隐藏主窗口
        [self close];

        // 更新状态栏菜单
        [appdelegate setOnline:YES];

        // 显示消息通知
        [appdelegate showNotification:[result message]];

        // 写入消息记录
        //[appdelegate managedObjectContext]
        
        // 写入钥匙串
        if ([appdelegate shouldUseKeychain]) {
            [SSKeychain setPassword:[self password]
                         forService:@"SwiftzMac"
                            account:[self username]];
        }

        // 检测更新
        NSString *update = [StatisticsAndUpdate checkUpdateWithIdenti:[self username]];
        if (update != nil) {
            NSString *format = NSLocalizedString(@"MSG_UPDATE", nil);
            [appdelegate showUpdate:[NSString stringWithFormat:format, update]];
        }
    } else {
        NSString *title = NSLocalizedString(@"MSG_LOGINFAILED", nil);

        NSAlert *alert = [NSAlert alertWithMessageText:title
                                         defaultButton:NSLocalizedString(@"OK", nil)
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@"%@", [result message]];

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

- (void)amtium:(Amtium *)amtium didCloseWithReason:(NSNumber *)reason
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

- (void)amtium:(Amtium *)amtium didError:(NSError *)error
{
    NSLog(@"error code: %ld", [error code]);
    NSLog(@"%@", error);

    if ([error code] == 0) {
        return; // ignore 0 error
    }

    [appdelegate showMainWindow:self];
    [appdelegate setOnline:NO];

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

- (void)sleep
{
    if (amtium && [amtium online]) {
        sleptWhileOnline = YES;
        [amtium logout:nil];
        [amtium close];
        [appdelegate setOnline:NO];
    } else {
        sleptWhileOnline = NO;
    }
}

- (void)wake
{
    // 什么都不用做，等待网络接通
}

- (void)connect
{
    // 初始化协议类
    amtium = [Amtium amtiumWithDelegate:self
                       didErrorSelector:@selector(amtium:didError:)
                       didCloseSelector:@selector(amtium:didCloseWithReason:)];

    BOOL isInitialUse = [appdelegate initialUse];
    BOOL isIpChanged = ![appdelegate ipManual]
                    && ![[appdelegate ipAddresses] containsObject:[appdelegate ip]];

    if (isInitialUse) {
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

        [amtium searchServer:@selector(initialWithAmtium:didGetServer:)];
    } else if (isIpChanged) {
        // 如果不是手动指定IP且IP不在列表中，说明IP已变更，提示重新设置
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"MSG_IPCHANGED", @"")
                                         defaultButton:NSLocalizedString(@"OK", @"")
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@""];

        [alert runModal];
        [appdelegate showPreferencesWindow:self];
    } else {
        // 应用偏好设置
        [self applyPreferences];

        // 如果是在线时休眠或断开网络，则重新登录
        if (sleptWhileOnline || disconnectedWhileOnline) {
            [amtium loginWithUsername:[self username]
                             password:[self password]
                     didLoginSelector:@selector(wakeWithAmtium:didLoginWithResult:)];
        }
    }
}

- (void)disconnect
{
    if (amtium) {
        disconnectedWhileOnline = [amtium online];
        [amtium close];
        [appdelegate setOnline:NO];
    }
}

- (void)wakeWithAmtium:(Amtium *)amtium didLoginWithResult:(AmtiumLoginResult *)result
{
    if ([result success]) {
        // 更新状态栏菜单
        [appdelegate setOnline:YES];

        // 显示消息通知
        //[appdelegate showNotification:[result message]];

        // 写入消息记录
        //[appdelegate managedObjectContext]
    } else {
        NSString *title = NSLocalizedString(@"MSG_LOGINFAILED", nil);

        NSAlert *alert = [NSAlert alertWithMessageText:title
                                         defaultButton:NSLocalizedString(@"OK", nil)
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@"%@", [result message]];

        [alert beginSheetModalForWindow:[self window]
                          modalDelegate:self
                         didEndSelector:nil
                            contextInfo:nil];
    }
}

- (NSString *)username
{
    return username;
}

- (void)setUsername:(NSString *)theUsername
{
    [self willChangeValueForKey:@"username"];
    username = theUsername;
    [appdelegate setUsername:theUsername];
    [self didChangeValueForKey:@"username"];

    NSError *error = nil;
    NSString *thePassword = [SSKeychain passwordForService:@"SwiftzMac"
                                                   account:theUsername
                                                     error:&error];

    if (error != nil && [error code] != -25300) {
        [appdelegate setShouldUseKeychain:NO];
    }

    [self setPassword:thePassword];
}

@end
