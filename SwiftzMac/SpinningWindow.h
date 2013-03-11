//
//  PreparingWindow.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-8.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpinningWindow : NSWindowController <NSWindowDelegate> {
    id _delegate;
    SEL _selector;
    NSString *_label;
}

@property (weak) IBOutlet NSProgressIndicator *indicator;
@property (weak) IBOutlet NSTextField *message;

- (id)initWithMessage:(NSString *)message
             delegate:(id)delegate
    didCancelSelector:(SEL)selector;

- (IBAction)cancel:(id)sender;

@end
