//
//  AmtiumLoginResult.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-14.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AmtiumLoginResult.h"

@implementation AmtiumLoginResult

@synthesize success;
@synthesize message;

+ (id)result:(BOOL)success withMessage:(NSString *)message
{
    return [[self alloc] init:success withMessage:message];
}

- (id)init:(BOOL)isSuccess withMessage:(NSString *)theMessage
{
    self = [self init];
    success = isSuccess;
    message = theMessage;
    return self;
}

@end
