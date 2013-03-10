//
//  APMutableParams.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-9.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APMutableParams : NSObject {
    NSMutableArray *keys;
    NSMutableArray *values;
}

+ (id)paramsWithAction:(unsigned char)action data:(NSData *)data;

- (id)initWithAction:(unsigned char)action data:(NSData *)data;

- (void)addString:(NSString *)stringValue forKey:(unsigned char)key;
- (void)addString:(NSString *)stringValue length:(unsigned char)length forKey:(unsigned char)key;

- (void)addHexadecimal:(NSString *)hexadecimalValue forKey:(unsigned char)key;

- (void)addUnsignedInt:(unsigned int)unsignedIntValue forKey:(unsigned char)key;

- (void)addUnsignedChar:(unsigned char)unsignedCharValue forKey:(unsigned char)key;

- (void)addBool:(BOOL)boolValue forKey:(unsigned char)key;

- (void)addData:(NSData *)data forKey:(unsigned char)key;

- (NSString *)stringForKey:(unsigned char)key;

- (NSArray *)stringArrayForKey:(unsigned char)key;

- (NSString *)hexadecimalForKey:(unsigned char)key;

- (unsigned int)unsignedIntForKey:(unsigned char)key;

- (unsigned char)unsignedCharForKey:(unsigned char)key;

- (BOOL)boolForKey:(unsigned char)key;

- (NSData *)dataForKey:(unsigned char)key;

- (NSData *)dataWithAction:(unsigned char)action;

- (NSArray *)allKeys;

- (BOOL)containsKey:(unsigned char)key;

@end
