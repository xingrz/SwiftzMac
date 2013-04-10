//
//  AmtiumCryptoB.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-4-7.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AmtiumCryptoB.h"

unsigned char const bs_row_b[] = {
    0x00, 0x01,
    0x08, 0x09,
    0x04, 0x05,
    0x0c, 0x0d,
    0x02, 0x03,
    0x0a, 0x0b,
    0x06, 0x07,
    0x0e, 0x0f
};

unsigned char const bs_col_b[] = {
    0x00, 0x01,
    0x04, 0x05,
    0x02, 0x03,
    0x06, 0x07,
    0x08, 0x09,
    0x0c, 0x0d,
    0x0a, 0x0b,
    0x0e, 0x0f
};

@implementation AmtiumCryptoB

+ (NSData *)encrypt:(NSData *)data
{
    NSUInteger length = [data length];
    unsigned char buffer[length];
    [data getBytes:buffer length:length];

    for (unsigned int i = 0; i < length; i++) {
        unsigned char bl_row, bl_col;
        unsigned int row, col;

        unsigned char c1 = floorf(buffer[i] / 16);
        unsigned char c2 = buffer[i] % 16;

        if (c1 < 8) {
            bl_row = floorf(c1 / 2) * 4;
            bl_col = (c1 % 2) * 4;
        } else {
            bl_row = floorf((c1 - 8) / 2) * 4;
            bl_col = (c1 % 2 + 2) * 4;
        }

        if (c2 % 2 == 0) {
            row = bl_row + floorf(c2 / 8) * 2;
            col = bl_col + (c2 % 8) / 2;
        } else {
            row = bl_row + floorf(c2 / 8) * 2 + 1;
            col = bl_col + ((c2 - 1) % 8) / 2;
        }

        buffer[i] = bs_row_b[row] * 16 + bs_col_b[col];
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

        unsigned char b1 = floorf(row / 4) * 2 + floorf(col / 4);
        if (col >= 8) b1 += 6;

        unsigned char b2 = col % 4 * 2 + row % 2;
        if (row % 4 >= 2) b2 += 8;

        buffer[i] = b1 * 16 + b2;
    }

    return [NSData dataWithBytes:buffer length:length];
}

+ (unsigned char)searchRowForValue:(unsigned char)ch
{
    for (unsigned int i = 0; i < 16; i++) {
        if (bs_row_b[i] == ch) return i;
    }

    return 0;
}

+ (unsigned char)searchColForValue:(unsigned char)ch
{
    for (unsigned int i = 0; i < 16; i++) {
        if (bs_col_b[i] == ch) return i;
    }

    return 0;
}

@end
