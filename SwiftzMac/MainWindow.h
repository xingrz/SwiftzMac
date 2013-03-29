//
//  MainWindow.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppDelegate;
@class SpinningWindow;

@interface MainWindow : NSWindowController <NSWindowDelegate> {
    SpinningWindow *spinningWindow;
    AppDelegate *appdelegate;
}

@property (readonly) NSArray *accounts;
@property (readwrite, copy) NSString *username;
@property (readwrite, copy) NSString *password;

- (IBAction)login:(id)sender;

@end
