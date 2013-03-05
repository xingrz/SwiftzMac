//
//  Amtium.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-5.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Amtium : NSObject {
    BOOL online;
    NSString *account;
}

- (BOOL)login:(NSString *)username password:(NSString *)password;
- (BOOL)logout;
- (BOOL)isOnline;
- (NSString *)account;

@end
