//
//  SALoginResult.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmtiumLoginResult : NSObject {
    BOOL success;
    NSString *message;
    NSString *website;
}

@property BOOL success;
@property NSString *message;
@property NSString *website;

+ (AmtiumLoginResult *)resultWithSuccess:(BOOL)success;
+ (AmtiumLoginResult *)resultWithSuccess:(BOOL)success message:(NSString *)message;
+ (AmtiumLoginResult *)resultWithSuccess:(BOOL)success message:(NSString *)message website:(NSString *)website;

@end
