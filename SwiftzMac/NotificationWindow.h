//
//  NotificationWindow.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-11.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppDelegate;

@interface NotificationWindow : NSWindowController <NSWindowDelegate> {
    AppDelegate *appdelegate;
    NSTimer *timer;
}

@property NSString *message;

- (IBAction)closeWindow:(id)sender;

@end
