//
//  AmtiumCrypto.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmtiumCrypto : NSObject

+ (NSData *)encrypt:(NSData *)data;
+ (NSData *)decrypt:(NSData *)data;

@end
