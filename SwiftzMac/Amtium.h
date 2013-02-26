//
//  Amtium.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Amtium : NSObject

@property NSString *clientIp;
@property NSString *gatewayIp;
@property NSString *clientMac;
@property NSString *version;
@property BOOL isDhcpEnabled;
@property (readonly) BOOL isOnline;
@property (readonly) NSString *website;

- (void)initialize;

- (NSDictionary *)loginWithUsername:(NSString *)username
                        password:(NSString *)password
                           entry:(NSString *)entry;

- (NSDictionary *)loginWithUsername:(NSString *)username
                        password:(NSString *)password;

- (void)logout;

- (NSString *)getServerIp;

- (NSArray *)getEntries;

@end
