//
//  AmtiumPacket.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmtiumPacket : NSObject

@property unsigned char action;
@property NSDictionary *parameters;

+ (NSData *)dataForInitialization;

+ (AmtiumPacket *)packetForGettingServerWithSession:(NSString *)session
                                                 ip:(NSString *)ip
                                                mac:(NSString *)mac;

+ (AmtiumPacket *)packetForGettingEntiesWithSession:(NSString *)session
                                                mac:(NSString *)mac;

+ (AmtiumPacket *)packetForLoggingInWithUsername:(NSString *)username
                                        password:(NSString *)password
                                           entry:(NSString *)entry
                                              ip:(NSString *)ip
                                             mac:(NSString *)mac
                                     dhcpEnabled:(BOOL)dhcpEnabled
                                         version:(NSString *)version;

+ (AmtiumPacket *)packetForBreathingWithSession:(NSString *)session
                                             ip:(NSString *)ip
                                            mac:(NSString *)mac
                                          index:(unsigned int)index;

+ (AmtiumPacket *)packetForLoggingOutWithSession:(NSString *)session
                                              ip:(NSString *)ip
                                             mac:(NSString *)mac
                                           index:(unsigned int)index;

- (id)initWithAction:(unsigned char)action
          parameters:(NSDictionary *)parameters;

- (id)initWithData:(NSData *)data;

- (NSData *)data;

@end
