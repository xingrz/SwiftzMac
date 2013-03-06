//
//  SALoginResult.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AmtiumLoginResult.h"

@implementation AmtiumLoginResult

@synthesize success, message, website;

+ (AmtiumLoginResult *)resultWithSuccess:(BOOL)success
{
    AmtiumLoginResult *result = [[AmtiumLoginResult alloc] init];
    [result setSuccess:success];
    return result;
}

+ (AmtiumLoginResult *)resultWithSuccess:(BOOL)success
                                 message:(NSString *)message
{
    AmtiumLoginResult *result = [[AmtiumLoginResult alloc] init];
    [result setSuccess:success];
    [result setMessage:message];
    return result;
}

+ (AmtiumLoginResult *)resultWithSuccess:(BOOL)success
                                 message:(NSString *)message
                                 website:(NSString *)website
{
    AmtiumLoginResult *result = [[AmtiumLoginResult alloc] init];
    [result setSuccess:success];
    [result setMessage:message];
    [result setWebsite:website];
    return result;
}

@end
