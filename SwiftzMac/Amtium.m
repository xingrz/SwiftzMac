//
//  Amtium.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-2-26.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "Amtium.h"

@implementation Amtium

- (void)initialize {
    
}

- (NSDictionary *)loginWithUsername:(NSString *)username
                        password:(NSString *)password
                           entry:(NSString *)entry {
    
    BOOL success = (username == password);
    NSString *message = username;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:success]   , @"success",
                message                             , @"message",
                nil];
}

- (NSDictionary *)loginWithUsername:(NSString *)username
                        password:(NSString *)password {
    return [self loginWithUsername:username
                          password:password
                             entry:@"internet"];
}

- (void)logout {
    
}

- (NSString *)getServerIp {
    return @"172.16.1.180";
}

- (NSArray *)getEntries {
    return [NSArray arrayWithObjects:@"internet", @"local", nil];
}

@end
