//
//  AmtiumEncoder.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AmtiumEncoder.h"

@implementation AmtiumEncoder

+ (NSData *)dataWithString:(NSString *)stringValue
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [stringValue dataUsingEncoding:encoding];
}

+ (NSData *)dataWithString:(NSString *)stringValue length:(unsigned char)length
{
    NSMutableData *data = [NSMutableData dataWithData:[self dataWithString:stringValue]];
    [data setLength:length];
    return data;
}

+ (NSData *)dataWithHexadecimal:(NSString *)hexadecimalValue
{
    NSMutableData *data= [[NSMutableData alloc] init];
    
    for (unsigned int i = 0; i < [hexadecimalValue length] / 2; i++) {
        char chars[3] = { 0x00, 0x00, 0x00 };
        chars[0] = [hexadecimalValue characterAtIndex:(i * 2)];
        chars[1] = [hexadecimalValue characterAtIndex:(i * 2 + 1)];
        
        unsigned char bytes = strtol(chars, NULL, 16);
        
        [data appendBytes:&bytes length:1];
    }

    return data;
}

+ (NSData *)dataWithUnsignedInt:(unsigned int)intValue
{
    unsigned int i = htonl(intValue);
    return [NSData dataWithBytes:&i length:sizeof(i)];
}

+ (NSData *)dataWithUnsignedChar:(unsigned char)charValue
{
    return [NSData dataWithBytes:&charValue length:sizeof(charValue)];
}

+ (NSData *)dataWithBool:(BOOL)boolValue
{
    unsigned char buffer[1];
    buffer[0] = boolValue ? 1 : 0;
    return [NSData dataWithBytes:buffer length:1];
}

+ (NSString *)stringValue:(NSData *)data
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[NSString alloc] initWithData:data encoding:encoding];
}

+ (NSString *)hexadecimalValue:(NSData *)data
{
    NSUInteger length = [data length];
    unsigned char buffer[length];
    [data getBytes:buffer];

    NSMutableString *value = [NSMutableString stringWithCapacity:(length * 2)];

    for (unsigned int i = 0; i < length; i++) {
        [value appendFormat:@"%02x", buffer[i]];
    }

    return value;
}

+ (unsigned int)unsignedIntValue:(NSData *)data
{
    unsigned int result;
    [data getBytes:&result length:sizeof(result)];
    return ntohl(result);
}

+ (unsigned char)unsignedCharValue:(NSData *)data
{
    unsigned char result;
    [data getBytes:&result length:sizeof(result)];
    return result;
}

+ (BOOL)boolValue:(NSData *)data
{
    unsigned char buffer[1];
    [data getBytes:buffer length:1];
    return buffer[0] != 0;
}

@end
