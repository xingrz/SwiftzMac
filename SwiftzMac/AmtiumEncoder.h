//
//  AmtiumEncoder.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmtiumEncoder : NSObject

+ (NSData *)dataWithString:(NSString *)stringValue;
+ (NSData *)dataWithString:(NSString *)stringValue length:(unsigned char)length;

+ (NSData *)dataWithHexadecimal:(NSString *)hexadecimalValue;

+ (NSData *)dataWithUnsignedInt:(unsigned int)intValue;

+ (NSData *)dataWithUnsignedChar:(unsigned char)charValue;

+ (NSData *)dataWithBool:(BOOL)boolValue;

+ (NSString *)stringValue:(NSData *)data;

+ (NSString *)hexadecimalValue:(NSData *)data;

+ (unsigned int)unsignedIntValue:(NSData *)data;

+ (unsigned char)unsignedCharValue:(NSData *)data;

+ (BOOL)boolValue:(NSData *)data;

@end
