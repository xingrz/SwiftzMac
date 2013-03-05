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
    
    return (NSArray *)result;
}

@end
