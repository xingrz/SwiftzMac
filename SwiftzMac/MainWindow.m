//
//  MainWindow.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-4.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "MainWindow.h"

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
    
    [amtium login:[[self username] stringValue]
         password:[[self password] stringValue]];
    
    [self close];
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
