//
//  AmtiumLoginResult.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-14.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmtiumLoginResult : NSObject

@property (readonly) BOOL success;
@property (readonly) NSString *message;

+ (id)result:(BOOL)success withMessage:(NSString *)message;
- (id)init:(BOOL)success withMessage:(NSString *)message;

@end
