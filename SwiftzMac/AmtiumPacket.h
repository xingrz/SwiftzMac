//
//  AmtiumPacket.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-6.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APMutableParams;

@interface AmtiumPacket : NSObject

@property unsigned char action;
@property APMutableParams *parameters;

+ (NSData *)dataForInitialization;

+ (id)packetWithAction:(unsigned char)action
            parameters:(APMutableParams *)parameters;

+ (id)packetWithData:(NSData *)data;

+ (id)packetForGettingServerWithSession:(NSString *)session
                                     ip:(NSString *)ip
                                    mac:(NSString *)mac;

+ (id)packetForGettingEntiesWithSession:(NSString *)session
                                    mac:(NSString *)mac;

+ (id)packetForLoggingInWithUsername:(NSString *)username
                            password:(NSString *)password
                               entry:(NSString *)entry
                                  ip:(NSString *)ip
                                 mac:(NSString *)mac
                         dhcpEnabled:(BOOL)dhcpEnabled
                             version:(NSString *)version;

+ (id)packetForBreathingWithSession:(NSString *)session
                                 ip:(NSString *)ip
                                mac:(NSString *)mac
                              index:(unsigned int)index;

+ (id)packetForLoggingOutWithSession:(NSString *)session
                                  ip:(NSString *)ip
                                 mac:(NSString *)mac
                               index:(unsigned int)index;

- (id)initWithAction:(unsigned char)action
          parameters:(APMutableParams *)parameters;

- (id)initWithData:(NSData *)data;

- (NSData *)data;

- (NSString *)stringForKey:(unsigned char)key;

- (NSArray *)stringArrayForKey:(unsigned char)key;

- (NSString *)hexadecimalForKey:(unsigned char)key;

- (unsigned int)unsignedIntForKey:(unsigned char)key;

- (unsigned char)unsignedCharForKey:(unsigned char)key;

- (BOOL)boolForKey:(unsigned char)key;

- (NSArray *)allKeys;

- (BOOL)containsKey:(unsigned char)key;

@end
