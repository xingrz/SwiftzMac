//
//  MainWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

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
        amtium = [[Amtium alloc] initWithDelegate:self
                                 didErrorSelector:@selector(amtiumDidError:)
                                 didCloseSelector:@selector(amtiumDidClose:)];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)login:(id)sender
{
    NSLog(@"login");
    /*[amtium loginWithUsername:[[self username] stringValue]
                     password:[[self password] stringValue]
               didEndSelector:@selector(didLoginWithSuccess:message:)];

    [amtium searchServer:@selector(didSearchServer:)];*/

    preparingWindow = [[PreparingWindow alloc] init];

    [NSApp beginSheet:[preparingWindow window]
       modalForWindow:[self window]
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];

    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(doTimer)
                                   userInfo:nil
                                    repeats:NO];
    
}

- (void)doTimer
{
    NSLog(@"timer");
    //[[preparingWindow window] orderOut:self];
    [NSApp endSheet:[preparingWindow window]];
    [preparingWindow close];
    preparingWindow = nil;
}

- (void)didSearchServer:(NSString *)server
{
    NSLog(@"%@", server);
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
    [self showWindow:sender];
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
    [self showWindow:nil];
}

- (void)amtiumDidError:(NSError *)error
{
    
}

@end
