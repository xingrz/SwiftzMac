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
#import "APMutableParams.h"

@implementation AmtiumPacket

@synthesize action;
@synthesize parameters;

+ (NSData *)dataForInitialization
{
    return [AmtiumEncoder dataWithString:@"info sock ini"];
}

+ (id)packetWithAction:(unsigned char)action
            parameters:(APMutableParams *)parameters
{
    return [[AmtiumPacket alloc] initWithAction:action
                                     parameters:parameters];
}

+ (id)packetWithData:(NSData *)data
{
    return [[AmtiumPacket alloc] initWithData:data];
}

+ (id)packetForGettingServerWithSession:(NSString *)session
                                     ip:(NSString *)ip
                                    mac:(NSString *)mac
{
    APMutableParams *params = [[APMutableParams alloc] init];

    [params addString:session forKey:APFSession];
    [params addString:ip length:16 forKey:APFIp];
    [params addHexadecimal:mac forKey:APFMac];

    return [AmtiumPacket packetWithAction:APAServer parameters:params];
}

+ (AmtiumPacket *)packetForGettingEntiesWithSession:(NSString *)session
                                                mac:(NSString *)mac
{
    APMutableParams *params = [[APMutableParams alloc] init];

    [params addString:session forKey:APFSession];
    [params addHexadecimal:mac forKey:APFMac];

    return [AmtiumPacket packetWithAction:APAEntries parameters:params];
}

+ (AmtiumPacket *)packetForLoggingInWithUsername:(NSString *)username
                                        password:(NSString *)password
                                           entry:(NSString *)entry
                                              ip:(NSString *)ip
                                             mac:(NSString *)mac
                                     dhcpEnabled:(BOOL)dhcpEnabled
                                         version:(NSString *)version
{
    APMutableParams *params = [[APMutableParams alloc] init];

    [params addHexadecimal:mac forKey:APFMac];
    [params addString:username forKey:APFUsername];
    [params addString:password forKey:APFPassword];
    [params addString:ip forKey:APFIp];
    [params addString:entry forKey:APFEntry];
    [params addBool:dhcpEnabled forKey:APFDhcp];
    [params addString:version forKey:APFVersion];

    return [AmtiumPacket packetWithAction:APALogin parameters:params];
}

+ (AmtiumPacket *)packetForBreathingWithSession:(NSString *)session
                                             ip:(NSString *)ip
                                            mac:(NSString *)mac
                                          index:(unsigned int)index
{
    // NOTE: index 是从 0x01000000 起算的，每次递增 3。
    APMutableParams *params = [[APMutableParams alloc] init];

    [params addString:session forKey:APFSession];
    [params addString:ip length:16 forKey:APFIp];
    [params addHexadecimal:mac forKey:APFMac];
    [params addUnsignedInt:index forKey:APFIndex];
    [params addUnsignedInt:0 forKey:APFBlock2A];
    [params addUnsignedInt:0 forKey:APFBlock2B];
    [params addUnsignedInt:0 forKey:APFBlock2C];
    [params addUnsignedInt:0 forKey:APFBlock2D];
    [params addUnsignedInt:0 forKey:APFBlock2E];
    [params addUnsignedInt:0 forKey:APFBlock2F];

    return [AmtiumPacket packetWithAction:APABreath parameters:params];
}

+ (AmtiumPacket *)packetForLoggingOutWithSession:(NSString *)session
                                              ip:(NSString *)ip
                                             mac:(NSString *)mac
                                           index:(unsigned int)index
{
    APMutableParams *params = [[APMutableParams alloc] init];

    [params addString:session forKey:APFSession];
    [params addString:ip length:16 forKey:APFIp];
    [params addHexadecimal:mac forKey:APFMac];
    [params addUnsignedInt:index forKey:APFIndex];
    [params addUnsignedInt:0 forKey:APFBlock2A];
    [params addUnsignedInt:0 forKey:APFBlock2B];
    [params addUnsignedInt:0 forKey:APFBlock2C];
    [params addUnsignedInt:0 forKey:APFBlock2D];
    [params addUnsignedInt:0 forKey:APFBlock2E];
    [params addUnsignedInt:0 forKey:APFBlock2F];

    return [AmtiumPacket packetWithAction:APALogout parameters:params];
}

- (id)initWithAction:(unsigned char)aAction
          parameters:(APMutableParams *)aParameters
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

    // TODO: verify md5 checksum

    NSData *dParams = [data subdataWithRange:NSMakeRange(offset, length - offset)];
    [self setParameters:[APMutableParams paramsWithAction:[self action] data:dParams]];

    return self;
}

- (NSData *)data
{
    NSMutableData *data = [[NSMutableData alloc] init];

    [data setLength:18];

    // adapt to a bug of the server
    if ([self action] == APAConfirmResult) {
        [data increaseLengthBy:3];
    }

    [data appendData:[[self parameters] dataWithAction:[self action]]];

    NSData *dAction = [AmtiumEncoder dataWithUnsignedChar:[self action]];
    NSData *dLength = [AmtiumEncoder dataWithUnsignedChar:(unsigned char)[data length]];

    [data replaceBytesInRange:NSMakeRange(0, 1) withBytes:[dAction bytes]];
    [data replaceBytesInRange:NSMakeRange(1, 1) withBytes:[dLength bytes]];

    unsigned char hash[16];
    CC_MD5([data bytes], (unsigned int)[data length], hash);
    [data replaceBytesInRange:NSMakeRange(2, 16) withBytes:hash];

    return data;
}

- (NSString *)stringForKey:(unsigned char)key
{
    return [parameters stringForKey:key];
}

- (NSArray *)stringArrayForKey:(unsigned char)key
{
    return [parameters stringArrayForKey:key];
}

- (NSString *)hexadecimalForKey:(unsigned char)key
{
    return [parameters hexadecimalForKey:key];
}

- (unsigned int)unsignedIntForKey:(unsigned char)key
{
    return [parameters unsignedIntForKey:key];
}

- (unsigned char)unsignedCharForKey:(unsigned char)key
{
    return [parameters unsignedCharForKey:key];
}

- (BOOL)boolForKey:(unsigned char)key
{
    return [parameters boolForKey:key];
}

- (NSData *)dataForKey:(unsigned char)key
{
    return [parameters dataForKey:key];
}

- (NSArray *)allKeys
{
    return [parameters allKeys];
}

- (BOOL)containsKey:(unsigned char)key
{
    return [parameters containsKey:key];
}

@end
