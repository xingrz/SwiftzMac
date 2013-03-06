//
//  AmtiumPacket.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

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
    index += 0x01000000;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithString:session],           APFSession,
                          [AmtiumEncoder dataWithString:ip length:16],      APFIp,
                          [AmtiumEncoder dataWithHexadecimal:mac],          APFMac,
                          [AmtiumEncoder dataWithNumber:index length:4],    APFIndex,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2A,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2B,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2C,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2D,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2E,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2F,
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APABreath parameters:dict];
}

+ (AmtiumPacket *)packetForLoggingOutWithSession:(NSString *)session
                                              ip:(NSString *)ip
                                             mac:(NSString *)mac
                                           index:(unsigned int)index
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AmtiumEncoder dataWithString:session],           APFSession,
                          [AmtiumEncoder dataWithString:ip length:16],      APFIp,
                          [AmtiumEncoder dataWithHexadecimal:mac],          APFMac,
                          [AmtiumEncoder dataWithNumber:index length:4],    APFIndex,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2A,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2B,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2C,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2D,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2E,
                          [AmtiumEncoder dataWithNumber:0 length:4],        APFBlock2F,
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APALogout parameters:dict];
}

- (id)initWithAction:(char)aAction
          parameters:(NSDictionary *)aParameters
{
    [self setAction:aAction];
    [self setParameters:aParameters];
    return self;
}

- (id)initWithData:(NSData *)data
{
    // ...
    return self;
}

- (NSData *)data
{
    NSMutableData *data = [[NSMutableData alloc] init];
    // ...
    return data;
}

@end
