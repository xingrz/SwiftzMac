//
//  AmtiumCrypto.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AmtiumCrypto.h"

unsigned char const bs_row[] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
unsigned char const bs_col[] = {0x00, 0x01, 0x08, 0x09, 0x04, 0x05, 0x0c, 0x0d, 0x02, 0x03, 0x0a, 0x0b, 0x06, 0x07, 0x0e, 0x0f};

@implementation AmtiumCrypto

+ (NSData *)encrypt:(NSData *)data
{
    NSUInteger length = [data length];
    unsigned char buffer[length];
    [data getBytes:buffer length:length];

    for (unsigned int i = 0; i < length; i++) {
        unsigned char bl, of, row, col;

        if (buffer[i] % 2 == 0) {
            bl = floorf(buffer[i] / 32);
            of = buffer[i] % 32;
            row = floorf(of / 4);
        } else {
            bl = floorf((buffer[i] - 1) / 32);
            of = (buffer[i] - 1) % 32;
            row = floorf(of / 4) + 8;
        }

        if (of % 4 == 0) {
            col = bl * 2;
        } else {
            col = bl * 2 + 1;
        }

        buffer[i] = bs_row[row] * 16 + bs_col[col];
    }

    return [NSData dataWithBytes:buffer length:length];
}

+ (NSData *)decrypt:(NSData *)data
{
    NSUInteger length = [data length];
    unsigned char buffer[length];
    [data getBytes:buffer length:length];

    for (unsigned int i = 0; i < length; i++) {
        unsigned char c1 = floorf(buffer[i] / 16);
        unsigned char c2 = buffer[i] % 16;
        
        unsigned char row = [self searchRowForValue:c1];
        unsigned char col = [self searchColForValue:c2];

        unsigned char of = (row < 8) ? (row * 4) : ((row - 8) * 4 + 1);
        unsigned char bl = (col % 2 == 0) ? (col * 16) : ((col - 1) * 16 + 2);

        buffer[i] = bl + of;
    }

    return [NSData dataWithBytes:buffer length:length];
}

+ (unsigned char)searchRowForValue:(unsigned char)ch
{
    for (unsigned int i = 0; i < 16; i++) {
        if (bs_row[i] == ch) return i;
    }

    return 0;
}

+ (unsigned char)searchColForValue:(unsigned char)ch
{
    for (unsigned int i = 0; i < 16; i++) {
        if (bs_col[i] == ch) return i;
    }

    return 0;
}

@end
