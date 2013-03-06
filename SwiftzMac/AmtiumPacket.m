//
//  AmtiumPacket.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AmtiumPacket.h"
#import "AmtiumConstants.h"

@implementation AmtiumPacket

@synthesize action, parameters;

+ (NSData *)dataForInitialization
{
}

+ (AmtiumPacket *)packetForGettingServerWithSession:(NSString *)session
                                                 ip:(NSString *)ip
                                                mac:(NSString *)mac
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          session,  APFSession,
                          ip,       APFIp,
                          mac,      APFMac,
                          nil];
    
    return [[AmtiumPacket alloc] initWithAction:APAServer
                                     parameters:dict];
}

+ (AmtiumPacket *)packetForGettingEntiesWithSession:(NSString *)session
                                                mac:(NSString *)mac
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          session,  APFSession,
                          mac,      APFMac,
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APAEntries
                                     parameters:dict];
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
                          mac,          APFMac,
                          username,     APFUsername,
                          password,     APFPassword,
                          ip,           APFIp,
                          entry,        APFEntry,
                          dhcpEnabled,  APFDhcp,
                          version,      APFVersion,
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APALogin
                                     parameters:dict];
}

+ (AmtiumPacket *)packetForBreathingWithSession:(NSString *)session
                                             ip:(NSString *)ip
                                            mac:(NSString *)mac
                                          index:(unsigned int)index
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          session,  APFSession,
                          ip,       APFIp,
                          mac,      APFMac,
                          index,    APFIndex,
                          0,        APFBlock2A,
                          0,        APFBlock2B,
                          0,        APFBlock2C,
                          0,        APFBlock2D,
                          0,        APFBlock2E,
                          0,        APFBlock2F,
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APABreath
                                     parameters:dict];
}

+ (AmtiumPacket *)packetForLoggingOutWithSession:(NSString *)session
                                              ip:(NSString *)ip
                                             mac:(NSString *)mac
                                           index:(unsigned int)index
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          session,  APFSession,
                          ip,       APFIp,
                          mac,      APFMac,
                          index,    APFIndex,
                          0,        APFBlock2A,
                          0,        APFBlock2B,
                          0,        APFBlock2C,
                          0,        APFBlock2D,
                          0,        APFBlock2E,
                          0,        APFBlock2F,
                          nil];

    return [[AmtiumPacket alloc] initWithAction:APALogout
                                     parameters:dict];
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
    return self;
}

- (NSData *)data
{
}

@end
