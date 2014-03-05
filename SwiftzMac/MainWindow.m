//
//  MainWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"
#import "AppController.h"

#import "AppData.h"

#import "MainWindow.h"
#import "SpinningWindow.h"

#import "SSKeychain.h"

@implementation MainWindow

@synthesize accounts;
@synthesize username;
@synthesize password;

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    appdelegate = [[NSApplication sharedApplication] delegate];
    self = [super initWithWindow:window];
    return self;
}

- (void)windowDidLoad
{
    // 加载钥匙串
    if ([[AppData instance] shouldUseKeychain]) {
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

        NSString *theUsername = [AppData instance].username;
        if (theUsername == nil) theUsername = [result objectAtIndex:0];
        [self setUsername:theUsername];
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    if (![[[AppController sharedController] amtium] online]) {
        [[NSApplication sharedApplication] terminate:self];
    }
}

- (void)login:(id)sender
{
    if ([[AppData instance] shouldUseKeychain]) {
        [SSKeychain setPassword:[self password]
                     forService:@"SwiftzMac"
                        account:[self username]];
    }

    [[AppController sharedController] login];
}

- (NSString *)username
{
    return username;
}

- (void)setUsername:(NSString *)theUsername
{
    [self willChangeValueForKey:@"username"];
    username = theUsername;
    [[AppData instance] setUsername:theUsername];
    [self didChangeValueForKey:@"username"];

    NSString *thePassword = [SSKeychain passwordForService:@"SwiftzMac"
                                                   account:theUsername];

    [self setPassword:thePassword];
}

@end
