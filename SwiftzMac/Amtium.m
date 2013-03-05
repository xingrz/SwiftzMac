//
//  Amtium.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-5.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "Amtium.h"

@implementation Amtium

- (BOOL)login:(NSString *)username password:(NSString *)password
{
    account = username;
    online = YES;
    return YES;
}

- (BOOL)logout
{
    online = NO;
    return YES;
}

- (BOOL)isOnline
{
    return online;
}

- (NSString *)account
{
    //NSLog(account);
    return account;
    //return @"account";
}

@end
