//
//  MainWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "MainWindow.h"

#import "Amtium.h"
#import "AmtiumLoginResult.h"

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
        amtium = [[Amtium alloc] init];
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
    
    AmtiumLoginResult *result = [amtium login:[[self username] stringValue]
                                     password:[[self password] stringValue]];
    
    if ([result success]) {
        [self close];
    } else {
        NSString *message = [result message];
        
        if (message == nil) {
            message = @"Login failed.";
        }
        
        NSAlert *alert = [NSAlert alertWithMessageText:[result message]
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
    [amtium logout];
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

@end
