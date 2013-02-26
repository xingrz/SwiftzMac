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
    // Insert code here to initialize your application
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
}

- (IBAction)logout:(id)sender {
}

@end
