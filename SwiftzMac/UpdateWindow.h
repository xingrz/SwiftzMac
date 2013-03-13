//
//  UpdateWindow.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-13.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UpdateWindow : NSWindowController <NSWindowDelegate>

@property NSString *update;

- (IBAction)go:(id)sender;
- (IBAction)ignore:(id)sender;

@end
