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
    NSLog(@"init:");
    if (![super initWithWindowNibName:@"MainWindow"]) {
        NSLog(@"initWithWindowNibName: failed");
        return nil;
    }
    NSLog(@"inited");
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    amtium = [[Amtium alloc] init];
}

- (IBAction)login:(id)sender
{
    NSLog(@"login");
    
    [amtium login:@"1234"
         password:@"5678"];
    
    NSLog(@"account: %@", [amtium account]);
}

- (IBAction)logout:(id)sender
{
    NSLog(@"logout");
    [amtium logout];
}

- (IBAction)account:(id)sender
{
}

- (Amtium *)amtium
{
    return amtium;
}

@end
