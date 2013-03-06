//
//  Ethernets.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-5.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "NetworkInterface.h"

@implementation NetworkInterface

@synthesize name, localizedDisplayName, hardwareAddress;

+ (NSArray *)getAllInterfaces
{
	NSArray *interfaces = CFBridgingRelease(SCNetworkInterfaceCopyAll());
	
	NSEnumerator *enumerator = [interfaces objectEnumerator];
	SCNetworkInterfaceRef ni;
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
	while ((ni = CFBridgingRetain([enumerator nextObject]))) {
        NSString *_name = CFBridgingRelease(SCNetworkInterfaceGetBSDName(ni));
		NSString *_localizedDisplayName = CFBridgingRelease(SCNetworkInterfaceGetLocalizedDisplayName(ni));
		NSString *_hardwareAddress = CFBridgingRelease(SCNetworkInterfaceGetHardwareAddressString(ni));
        
        if (_hardwareAddress != nil) {
            NetworkInterface *interface = [[NetworkInterface alloc] init];
            
            interface.name = _name;
            interface.localizedDisplayName = _localizedDisplayName;
            interface.hardwareAddress = _hardwareAddress;
            
            [result addObject:interface];
        }
	}
    
    return result;
}

+ (NSArray *)getAllIpAddresses
{
    NSArray *addresses = [[NSHost currentHost] addresses];
    
    NSEnumerator *enumerator = [addresses objectEnumerator];
    NSString *ip;
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSRegularExpression *ipv4 = [NSRegularExpression regularExpressionWithPattern:@"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"
                                                                          options:0
                                                                            error:nil];
    
    while (ip = [enumerator nextObject]) {
        if ([ip isEqualToString:@"0.0.0.0"]) continue;
        if ([ip isEqualToString:@"127.0.0.1"]) continue;
        
        NSTextCheckingResult *match = [ipv4 firstMatchInString:ip
                                                       options:0
                                                         range:NSMakeRange(0, [ip length])];
        if (!match) continue;
        
        [result addObject:ip];
    }
    
    return result;
}

@end
