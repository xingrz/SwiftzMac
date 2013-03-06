//
//  Amtium.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-5.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "Amtium.h"

#import "AmtiumLoginResult.h"

@implementation Amtium

- (AmtiumLoginResult *)login:(NSString *)username password:(NSString *)password
{
    if ([password isEqualToString:@"1234"]) {
        _account = username;
        _online = YES;
        return [AmtiumLoginResult resultWithSuccess:YES];
    } else {
        return [AmtiumLoginResult resultWithSuccess:NO message:@"测试用的密码是 1234 啦"];
    }
}

- (BOOL)logout
{
    _online = NO;
    return YES;
}

- (NSString *)serverFromRemote
{
    return @"172.16.1.180";
}

- (NSArray *)entryListFromRemote
{
    return [NSArray arrayWithObjects:@"internet", @"local", nil];
}

- (BOOL)online
{
    return _online;
}

- (NSString *)account
{
    return _account;
}

- (NSString *)server
{
    return _server;
}

- (void)setServer:(NSString *)server
{
    // ...
}

- (NSString *)entry
{
    return _entry;
}

- (void)setEntry:(NSString *)entry
{
    _entry = entry;
}

- (NSString *)mac
{
    return _mac;
}

- (void)setMac:(NSString *)mac
{
    // ...
}

- (NSString *)ip
{
    return _ip;
}

- (void)setIp:(NSString *)ip
{
    // ...
}

- (BOOL)dhcpEnabled
{
    return _dhcpEnabled;
}

- (void)setDhcpEnabled:(BOOL)dhcpEnabled
{
    _dhcpEnabled = dhcpEnabled;
}

@end
