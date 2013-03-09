//
//  APMutableParams.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-9.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "APMutableParams.h"
#import "AmtiumEncoder.h"
#import "AmtiumConstants.h"

@implementation APMutableParams

+ (id)paramsWithData:(NSData *)data
{
    return [[APMutableParams alloc] initWithData:data];
}

- (id)init
{
    keys = [[NSMutableArray alloc] init];
    values = [[NSMutableArray alloc] init];
    return [super init];
}

- (id)initWithData:(NSData *)data
{
    self = [self init];

    NSUInteger length = [data length];
    unsigned char buffer[length];
    [data getBytes:buffer length:length];

    unsigned char offset = 0;
    
    while (offset < sizeof(buffer)) {
        unsigned char key = buffer[offset];
        unsigned char length = buffer[offset + 1] - 2;

        // adapt to a bug of the server
        if (key == APFMessage || key == APFSession) {
            length += 2;
        }

        NSNumber *number = [NSNumber numberWithUnsignedChar:key];
        NSData *value = [data subdataWithRange:NSMakeRange(offset + 2, length)];

        if ([keys containsObject:number]) {
            NSUInteger index = [keys indexOfObject:number];
            id object = [values objectAtIndex:index];
            if ([object respondsToSelector:@selector(addObject:)]) {
                [object addObject:value];
            } else {
                NSData *formal = (NSData *)object;
                NSArray *array = [NSArray arrayWithObjects:formal, value, nil];
                [values setObject:array atIndexedSubscript:index];
            }
        } else {
            [keys addObject:number];
            [values addObject:value];
        }
    }

    return self;
}

- (void)addString:(NSString *)stringValue forKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];
    NSData *data = [AmtiumEncoder dataWithString:stringValue];
    
    if ([keys containsObject:number]) {
        NSUInteger index = [keys indexOfObject:number];
        id object = [values objectAtIndex:index];
        if ([object respondsToSelector:@selector(addObject:)]) {
            [object addObject:data];
        } else {
            NSData *formal = (NSData *)object;
            NSArray *array = [NSArray arrayWithObjects:formal, data, nil];
            [values setObject:array atIndexedSubscript:index];
        }
        
    } else {
        [keys addObject:number];
        [values addObject:data];
    }
}

- (void)addString:(NSString *)stringValue length:(unsigned char)length forKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];
    NSData *data = [AmtiumEncoder dataWithString:stringValue length:length];
    
    if ([keys containsObject:number]) {
        NSUInteger index = [keys indexOfObject:number];
        id object = [values objectAtIndex:index];
        if ([object respondsToSelector:@selector(addObject:)]) {
            [object addObject:data];
        } else {
            NSData *formal = (NSData *)object;
            NSArray *array = [NSArray arrayWithObjects:formal, data, nil];
            [values setObject:array atIndexedSubscript:index];
        }

    } else {
        [keys addObject:number];
        [values addObject:data];
    }
}

- (void)addHexadecimal:(NSString *)hexadecimalValue forKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];
    NSData *data = [AmtiumEncoder dataWithHexadecimal:hexadecimalValue];

    if ([keys containsObject:number]) {
        NSUInteger index = [keys indexOfObject:number];
        [values setObject:data atIndexedSubscript:index];
    } else {
        [keys addObject:number];
        [values addObject:data];
    }
}

- (void)addUnsignedInt:(unsigned int)unsignedIntValue forKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];
    NSData *data = [AmtiumEncoder dataWithUnsignedInt:unsignedIntValue];
    
    if ([keys containsObject:number]) {
        NSUInteger index = [keys indexOfObject:number];
        [values setObject:data atIndexedSubscript:index];
    } else {
        [keys addObject:number];
        [values addObject:data];
    }
}

- (void)addUnsignedChar:(unsigned char)unsignedCharValue forKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];
    NSData *data = [AmtiumEncoder dataWithUnsignedChar:unsignedCharValue];

    if ([keys containsObject:number]) {
        NSUInteger index = [keys indexOfObject:number];
        [values setObject:data atIndexedSubscript:index];
    } else {
        [keys addObject:number];
        [values addObject:data];
    }
}

- (void)addBool:(BOOL)boolValue forKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];
    NSData *data = [AmtiumEncoder dataWithBool:boolValue];

    if ([keys containsObject:number]) {
        NSUInteger index = [keys indexOfObject:number];
        [values setObject:data atIndexedSubscript:index];
    } else {
        [keys addObject:number];
        [values addObject:data];
    }
}

-(NSData *)data
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:18];

    for (id number in keys) {
        NSUInteger index = [keys indexOfObject:number];
        id object = [values objectAtIndex:index];

        unsigned char cKey = [(NSNumber *)number unsignedCharValue];
        NSData *dKey = [AmtiumEncoder dataWithUnsignedChar:cKey];

        if ([object respondsToSelector:@selector(objectAtIndex:)]) {
            for (id item in object) {
                NSData *value = (NSData *)item;
                unsigned char cLength = [value length] + 2;

                // adapt to a bug of the server
                if (cKey == APFMessage || cKey == APFSession) {
                    cLength -= 2;
                }

                NSData *dLength = [AmtiumEncoder dataWithUnsignedChar:cLength];

                [data appendData:dKey];
                [data appendData:dLength];
                [data appendData:value];
            }
        } else {
            NSData *value = (NSData *)object;
            unsigned char cLength = [value length] + 2;

            // adapt to a bug of the server
            if (cKey == APFMessage || cKey == APFSession) {
                cLength -= 2;
            }

            NSData *dLength = [AmtiumEncoder dataWithUnsignedChar:cLength];

            [data appendData:dKey];
            [data appendData:dLength];
            [data appendData:value];
        }
    }

    return data;
}

- (NSString *)stringForKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];
    
    if (![keys containsObject:number]) {
        return nil;
    }
    
    NSUInteger index = [keys indexOfObject:number];
    return [AmtiumEncoder stringValue:[values objectAtIndex:index]];
}

- (NSArray *)stringArrayForKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];

    if (![keys containsObject:number]) {
        return nil;
    }

    NSUInteger index = [keys indexOfObject:number];
    id object = [values objectAtIndex:index];

    if (![object respondsToSelector:@selector(objectAtIndex:)]) {
        return nil;
    }

    NSMutableArray *result = [[NSMutableArray alloc] init];

    for (id item in (NSArray *)object) {
        [result addObject:[AmtiumEncoder stringValue:item]];
    }

    return result;
}

- (NSString *)hexadecimalForKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];

    if (![keys containsObject:number]) {
        return nil;
    }

    NSUInteger index = [keys indexOfObject:number];
    return [AmtiumEncoder hexadecimalValue:[values objectAtIndex:index]];
}

- (unsigned int)unsignedIntForKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];

    if (![keys containsObject:number]) {
        return 0;
    }

    NSUInteger index = [keys indexOfObject:number];
    return [AmtiumEncoder unsignedIntValue:[values objectAtIndex:index]];
}

- (unsigned char)unsignedCharForKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];

    if (![keys containsObject:number]) {
        return 0;
    }

    NSUInteger index = [keys indexOfObject:number];
    return [AmtiumEncoder unsignedCharValue:[values objectAtIndex:index]];
}

- (BOOL)boolForKey:(unsigned char)key
{
    NSNumber *number = [NSNumber numberWithUnsignedChar:key];

    if (![keys containsObject:number]) {
        return NO;
    }

    NSUInteger index = [keys indexOfObject:number];
    return [AmtiumEncoder boolValue:[values objectAtIndex:index]];
}

- (NSArray *)allKeys
{
    return keys;
}

- (BOOL)containsKey:(unsigned char)key
{
    return [keys containsObject:[NSNumber numberWithUnsignedChar:key]];
}

@end
