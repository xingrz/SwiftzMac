//
//  AppDelegate.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setAmtium:[Amtium alloc]];
}

- (IBAction)checkRemember:(id)sender {
    if (self.remember.state == 0) {
        self.autologin.state = 0;
    }
}

- (IBAction)checkAutologin:(id)sender {
    if (self.autologin.state == 1) {
        self.remember.state = 1;
    }
}

- (IBAction)login:(id)sender {
    [self.username setHidden:YES];
    [self.password setHidden:YES];
    [self.remember setHidden:YES];
    [self.autologin setHidden:YES];
    [self.login setHidden:YES];
    
    [self.account setHidden:NO];
    [self.loading setHidden:NO];
    [self.logout setHidden:NO];
    
    NSDictionary *result = [self.amtium loginWithUsername:self.username.stringValue
                                                 password:self.password.stringValue];
    
    BOOL success = [[result objectForKey:@"success"] boolValue];
    NSString *message = [result objectForKey:@"message"];
    
    NSLog(@"%@", message);
    
    if (success) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Login Success!"
                                         defaultButton:@"OK"
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@""];
    
        [alert beginSheetModalForWindow:[self window]
                          modalDelegate:self
                         didEndSelector:nil
                            contextInfo:nil];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Login Failed!"
                                         defaultButton:@"OK"
                                       alternateButton:@""
                                           otherButton:@""
                             informativeTextWithFormat:@""];
        
        [alert setInformativeText:message];
        
        [alert beginSheetModalForWindow:[self window]
                          modalDelegate:self
                         didEndSelector:nil
                            contextInfo:nil];
    }
}

- (IBAction)logout:(id)sender {
    [self.account setHidden:YES];
    [self.loading setHidden:YES];
    [self.logout setHidden:YES];
    
    [self.username setHidden:NO];
    [self.password setHidden:NO];
    [self.remember setHidden:NO];
    [self.autologin setHidden:NO];
    [self.login setHidden:NO];
}

@end
