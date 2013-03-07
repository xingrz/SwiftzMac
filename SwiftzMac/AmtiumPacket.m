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

+ (AmtiumPacket *)packetForGettingServerWithSession:(NSString *)session
                                                 ip:(NSString *)ip
                                                mac:(NSString *)mac
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithString:session],       APFSession,
                          [AmtiumEncoder dataWithString:ip length:16],  APFIp,
                          [AmtiumEncoder dataWithHexadecimal:mac],      APFMac,
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APAServer parameters:dict];
}

+ (AmtiumPacket *)packetForGettingEntiesWithSession:(NSString *)session
                                                mac:(NSString *)mac
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithString:session],   APFSession,
                          [AmtiumEncoder dataWithHexadecimal:mac],  APFMac,
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
                          [AmtiumEncoder dataWithHexadecimal:mac],  APFMac,
                          [AmtiumEncoder dataWithString:username],  APFUsername,
                          [AmtiumEncoder dataWithString:password],  APFPassword,
                          [AmtiumEncoder dataWithString:ip],        APFIp,
                          [AmtiumEncoder dataWithString:entry],     APFEntry,
                          [AmtiumEncoder dataWithBool:dhcpEnabled], APFDhcp,
                          [AmtiumEncoder dataWithString:version],   APFVersion,
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
                          [AmtiumEncoder dataWithString:session],       APFSession,
                          [AmtiumEncoder dataWithString:ip length:16],  APFIp,
                          [AmtiumEncoder dataWithHexadecimal:mac],      APFMac,
                          [AmtiumEncoder dataWithUInt:index],           APFIndex,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2A,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2B,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2C,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2D,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2E,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2F,
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APABreath parameters:dict];
}

+ (AmtiumPacket *)packetForLoggingOutWithSession:(NSString *)session
                                              ip:(NSString *)ip
                                             mac:(NSString *)mac
                                           index:(unsigned int)index
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithString:session],       APFSession,
                          [AmtiumEncoder dataWithString:ip length:16],  APFIp,
                          [AmtiumEncoder dataWithHexadecimal:mac],      APFMac,
                          [AmtiumEncoder dataWithUInt:index],           APFIndex,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2A,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2B,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2C,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2D,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2E,
                          [AmtiumEncoder dataWithUInt:0],               APFBlock2F,
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

    NSEnumerator *enumerator = [[self parameters] keyEnumerator];
    id key;

    while (key = [enumerator nextObject]) {
        unsigned char charKey = (unsigned char)key;
        
        NSData *dKey = [AmtiumEncoder dataWithUChar:charKey];
        NSData *dData = [[self parameters] objectForKey:key];

        // length of `key` + length of `length` + lenght of `data`
        unsigned char length = [dData length] + 2;

        // adapt to a bug of the server
        if (charKey == APFMessage || charKey == APFSession) {
            length -= 2;
        }
        
        NSData *dLength = [AmtiumEncoder dataWithUChar:length];

        [data appendData:dKey];
        [data appendData:dLength];
        [data appendData:dData];
    }

    NSData *dAction = [AmtiumEncoder dataWithUChar:[self action]];
    NSData *dLength = [AmtiumEncoder dataWithUChar:(unsigned char)[data length]];

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
