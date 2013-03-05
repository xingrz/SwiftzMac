//
//  Ethernets.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-5.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface NetworkInterface : NSObject {
    NSString *name;
    NSString *localizedDisplayName;
    NSString *hardwareAddress;
    NSArray *ipAddresses;
}

@property NSString *name;
@property NSString *localizedDisplayName;
@property NSString *hardwareAddress;
//@property NSArray *ipAddresses;

+ (NSArray *)getAllInterfaces;

@end
