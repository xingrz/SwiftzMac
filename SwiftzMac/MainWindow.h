//
//  MainWindow.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppDelegate;
@class PreparingWindow;
@class Amtium;

@interface MainWindow : NSWindowController {
    Amtium *amtium;
    PreparingWindow *preparingWindow;
    AppDelegate *appdelegate;
}

@property (weak) IBOutlet NSTextField *username;
@property (weak) IBOutlet NSSecureTextField *password;

- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)account:(id)sender;

- (Amtium *)amtium;

@end
