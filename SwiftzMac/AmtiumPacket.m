//
//  AmtiumPacket.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "AmtiumPacket.h"
#import "AmtiumConstants.h"
#import "AmtiumEncoder.h"

@implementation AmtiumPacket

@synthesize action, parameters;

+ (NSData *)dataForInitialization
{
    return [AmtiumEncoder dataWithString:@"info sock ini"];
}

+ (AmtiumPacket *)packetWithData:(NSData *)data
{
    return [[AmtiumPacket alloc] initWithData:data];
}

+ (AmtiumPacket *)packetForGettingServerWithSession:(NSString *)session
                                                 ip:(NSString *)ip
                                                mac:(NSString *)mac
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithString:session],
                          [NSNumber numberWithUnsignedChar:APFSession],
                          
                          [AmtiumEncoder dataWithString:ip length:16],
                          [NSNumber numberWithUnsignedChar:APFIp],
                          
                          [AmtiumEncoder dataWithHexadecimal:mac],
                          [NSNumber numberWithUnsignedChar:APFMac],
                          
                          nil];

    NSLog(@"session: %@", [AmtiumEncoder dataWithString:session]);
    NSLog(@"ip: %@", [AmtiumEncoder dataWithString:ip length:16]);
    NSLog(@"mac: %@", [AmtiumEncoder dataWithHexadecimal:mac]);

    return [[AmtiumPacket alloc] initWithAction:APAServer parameters:dict];
}

+ (AmtiumPacket *)packetForGettingEntiesWithSession:(NSString *)session
                                                mac:(NSString *)mac
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithString:session],
                          [NSNumber numberWithUnsignedChar:APFSession],
                          
                          [AmtiumEncoder dataWithHexadecimal:mac],
                          [NSNumber numberWithUnsignedChar:APFMac],
                          
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APAEntries parameters:dict];
}

+ (AmtiumPacket *)packetForLoggingInWithUsername:(NSString *)username
                                        password:(NSString *)password
                                           entry:(NSString *)entry
                                              ip:(NSString *)ip
                                             mac:(NSString *)mac
                                     dhcpEnabled:(BOOL)dhcpEnabled
                                         version:(NSString *)version
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithHexadecimal:mac],
                          [NSNumber numberWithUnsignedChar:APFMac],
                          
                          [AmtiumEncoder dataWithString:username],
                          [NSNumber numberWithUnsignedChar:APFUsername],
                          
                          [AmtiumEncoder dataWithString:password],
                          [NSNumber numberWithUnsignedChar:APFPassword],
                          
                          [AmtiumEncoder dataWithString:ip],
                          [NSNumber numberWithUnsignedChar:APFIp],
                          
                          [AmtiumEncoder dataWithString:entry],
                          [NSNumber numberWithUnsignedChar:APFEntry],
                          
                          [AmtiumEncoder dataWithBool:dhcpEnabled],
                          [NSNumber numberWithUnsignedChar:APFDhcp],
                          
                          [AmtiumEncoder dataWithString:version],
                          [NSNumber numberWithUnsignedChar:APFVersion],
                          
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APALogin parameters:dict];
}

+ (AmtiumPacket *)packetForBreathingWithSession:(NSString *)session
                                             ip:(NSString *)ip
                                            mac:(NSString *)mac
                                          index:(unsigned int)index
{
    // NOTE: index 是从 0x01000000 起算的，每次递增 3。
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithString:session],
                          [NSNumber numberWithUnsignedChar:APFSession],
                          
                          [AmtiumEncoder dataWithString:ip length:16],
                          [NSNumber numberWithUnsignedChar:APFIp],
                          
                          [AmtiumEncoder dataWithHexadecimal:mac],
                          [NSNumber numberWithUnsignedChar:APFMac],
                          
                          [AmtiumEncoder dataWithUnsignedInt:index],
                          [NSNumber numberWithUnsignedChar:APFIndex],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2A],

                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2B],

                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2C],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2D],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2E],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2F],
                          
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APABreath parameters:dict];
}

+ (AmtiumPacket *)packetForLoggingOutWithSession:(NSString *)session
                                              ip:(NSString *)ip
                                             mac:(NSString *)mac
                                           index:(unsigned int)index
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithString:session],
                          [NSNumber numberWithUnsignedChar:APFSession],
                          
                          [AmtiumEncoder dataWithString:ip length:16],
                          [NSNumber numberWithUnsignedChar:APFIp],
                          
                          [AmtiumEncoder dataWithHexadecimal:mac],
                          [NSNumber numberWithUnsignedChar:APFMac],
                          
                          [AmtiumEncoder dataWithUnsignedInt:index],
                          [NSNumber numberWithUnsignedChar:APFIndex],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2A],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2B],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2C],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2D],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2E],
                          
                          [AmtiumEncoder dataWithUnsignedInt:0],
                          [NSNumber numberWithUnsignedChar:APFBlock2F],
                          
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APALogout parameters:dict];
}

- (id)initWithAction:(unsigned char)aAction
          parameters:(NSDictionary *)aParameters
{
    [self setAction:aAction];
    [self setParameters:aParameters];
    return self;
}

- (id)initWithData:(NSData *)data
{
    NSUInteger length = [data length];
    unsigned char buffer[length];
    [data getBytes:buffer length:length];

    [self setAction:buffer[0]];

    unsigned char offset = 18;
    
    // adapt to a bug of the server
    if ([self action] == APAConfirmResult) {
        offset += 3;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    while (offset < sizeof(buffer)) {
        unsigned char key = buffer[offset];
        unsigned char length = buffer[offset + 1] - 2;

        // adapt to a bug of the server
        if (key == APFMessage || key == APFSession) {
            length += 2;
        }

        NSData *subdata = [data subdataWithRange:NSMakeRange(offset + 2, length)];
        [dict setObject:subdata forKey:[NSNumber numberWithUnsignedChar:key]];
    }

    [self setParameters:dict];
    
    return self;
}

- (NSData *)data
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:18];

    // adapt to a bug of the server
    if ([self action] == APAConfirmResult) {
        [data increaseLengthBy:3];
    }

    NSLog(@"DATA: %i", [self action]);

    NSEnumerator *enumerator = [[self parameters] keyEnumerator];
    id key;

    NSLog(@"%@", [self parameters]);

    while (key = [enumerator nextObject]) {
        unsigned char charKey = [(NSNumber *)key unsignedCharValue];
        
        NSData *dKey = [AmtiumEncoder dataWithUnsignedChar:charKey];
        NSData *dData = [[self parameters] objectForKey:key];

        NSLog(@"key:%@ data:%@", dKey, dData);

        // length of `key` + length of `length` + lenght of `data`
        unsigned char length = [dData length] + 2;

        // adapt to a bug of the server
        if (charKey == APFMessage || charKey == APFSession) {
            length -= 2;
        }
        
        NSData *dLength = [AmtiumEncoder dataWithUnsignedChar:length];

        [data appendData:dKey];
        [data appendData:dLength];
        [data appendData:dData];
    }

    NSData *dAction = [AmtiumEncoder dataWithUnsignedChar:[self action]];
    NSData *dLength = [AmtiumEncoder dataWithUnsignedChar:(unsigned char)[data length]];

    [data replaceBytesInRange:NSMakeRange(0, 1) withBytes:[dAction bytes]];
    [data replaceBytesInRange:NSMakeRange(1, 1) withBytes:[dLength bytes]];

    unsigned char hash[16];
    CC_MD5([data bytes], (unsigned int)[data length], hash);
    [data replaceBytesInRange:NSMakeRange(2, 16) withBytes:hash];

    return data;
}

- (NSString *)stringValueForKey:(unsigned char)key
{
    id object = [[self parameters] objectForKey:[NSNumber numberWithUnsignedChar:key]];
    if (object == nil)
    {
        return nil;
    }

    return [AmtiumEncoder stringValue:object];
}

- (NSString *)hexadecimalValueForKey:(unsigned char)key
{
    id object = [[self parameters] objectForKey:[NSNumber numberWithUnsignedChar:key]];
    if (object == nil)
    {
        return nil;
    }

    return [AmtiumEncoder hexadecimalValue:object];
}

- (unsigned int)unsignedIntValueForKey:(unsigned char)key
{
    id object = [[self parameters] objectForKey:[NSNumber numberWithUnsignedChar:key]];
    if (object == nil)
    {
        return 0;
    }

    return [AmtiumEncoder unsignedIntValue:object];
}

- (unsigned char)unsignedCharValueForKey:(unsigned char)key
{
    id object = [[self parameters] objectForKey:[NSNumber numberWithUnsignedChar:key]];
    if (object == nil)
    {
        return 0;
    }

    return [AmtiumEncoder unsignedCharValue:object];
}

- (BOOL)boolValueForKey:(unsigned char)key
{
    id object = [[self parameters] objectForKey:[NSNumber numberWithUnsignedChar:key]];
    if (object == nil)
    {
        return NO;
    }

    return [AmtiumEncoder boolValue:object];
}

@end
