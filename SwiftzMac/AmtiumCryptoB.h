//
//  AmtiumCryptoB.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-4-7.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmtiumCryptoB : NSObject

+ (NSData *)encrypt:(NSData *)data;
+ (NSData *)decrypt:(NSData *)data;

@end
