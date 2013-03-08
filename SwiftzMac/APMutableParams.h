//
//  APMutableParams.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-9.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APMutableParams : NSObject

- (void)addString:(NSString *)stringValue forKey:(unsigned char)key;
- (void)addString:(NSString *)stringValue length:(unsigned char)length forKey:(unsigned char)key;

- (void)addHexadecimal:(NSString *)hexadecimalValue forKey:(unsigned char)key;

- (void)addUnsignedInt:(unsigned int)unsignedIntValue forKey:(unsigned char)key;

- (void)addUnsignedChar:(unsigned char)unsignedCharValue forKey:(unsigned char)key;

- (void)addBool:(BOOL)boolValue forKey:(unsigned char)key;

- (NSData *)data;

@end
