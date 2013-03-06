//
//  Amtium.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-5.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AmtiumLoginResult;

@interface Amtium : NSObject {
    BOOL _online;
    NSString *_account;
    NSString *_server;
    NSString *_entry;
    NSString *_mac;
    NSString *_ip;
    BOOL _dhcpEnabled;
}

@property (readonly) BOOL online;
@property (readonly) NSString *account;
@property NSString *server;
@property NSString *entry;
@property NSString *mac;
@property NSString *ip;
@property BOOL dhcpEnabled;

- (AmtiumLoginResult *)login:(NSString *)username password:(NSString *)password;
- (BOOL)logout;
- (NSString *)serverFromRemote;
- (NSArray *)entryListFromRemote;

@end
