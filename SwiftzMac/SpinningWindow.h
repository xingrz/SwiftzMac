//
//  PreparingWindow.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-8.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpinningWindow : NSWindowController <NSWindowDelegate>

@property (assign) NSString *message;
@property (assign) id delegate;
@property (assign) SEL didCancelSelector;

@property (weak) IBOutlet NSProgressIndicator *indicator;

- (id)initWithMessage:(NSString *)message
             delegate:(id)delegate
    didCancelSelector:(SEL)selector;

- (IBAction)cancel:(id)sender;

@end
