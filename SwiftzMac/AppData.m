//
//  AppData.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-10-2.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "AppData.h"

#import "NetworkInterface.h"

NSString * const SMInitialKey = @"InitialFlag";
NSString * const SMServerKey = @"Server";
NSString * const SMEntryKey = @"Entry";
NSString * const SMEntryListKey = @"EntryList";
NSString * const SMInterfaceKey = @"Interface";
NSString * const SMIpKey = @"IP";
NSString * const SMIpManualKey = @"IPManualFlag";
NSString * const SMKeychainKey = @"KeychainFlag";
NSString * const SMStatusBarKey = @"StatusBarFlag";
NSString * const SMUsernameKey = @"Username";

@implementation AppData

+ (AppData *)instance {
    static AppData *instance;
    
    @synchronized(self) {
        if (!instance) {
            instance = [[super alloc] init];
        }
    }
    
    return instance;
}

- (id)init {
    _defaults = [NSUserDefaults standardUserDefaults];
    return [super init];
}

@synthesize firstrun;

@synthesize entries;
@synthesize addresses;
@synthesize interfaces;

@synthesize allowManualIp;
@synthesize mac;

@synthesize username;
@synthesize server;
@synthesize entry;
@synthesize interface;
@synthesize address;

@synthesize shouldUseKeychain;
@synthesize shouldShowStatusBarMenu;

- (BOOL)firstrun {
    return [_defaults boolForKey:SMInitialKey];
}

- (NSArray *)entries {
    return _entries;
}

- (void)setEntries:(NSArray *)entries {
    [self willChangeValueForKey:@"entries"];
    [_defaults setObject:entries forKey:SMEntryListKey];
    [self didChangeValueForKey:@"entries"];
}

- (NSArray *)addresses {
    return _addresses;
}

- (NSArray *)interfaces {
    return _interfaces;
}

- (BOOL)allowManualIp {
    return [_defaults boolForKey:SMIpManualKey];
}

- (NSString *)mac {
    for (NetworkInterface *intf in _interfaces) {
        if ([[intf name] isEqualToString:[self interface]]) {
            return [intf hardwareAddress];
        }
    }
    
    return @"000000000000";
}

- (NSString *)username {
    return [_defaults stringForKey:SMUsernameKey];
}

- (void)setUsername:(NSString *)_username {
    [self willChangeValueForKey:@"username"];
    [_defaults setObject:_username forKey:SMUsernameKey];
    [self didChangeValueForKey:@"username"];
}


@end
