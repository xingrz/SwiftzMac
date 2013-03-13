//
//  Amtium.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-5.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "Amtium.h"
#import "AmtiumConstants.h"
#import "AmtiumCrypto.h"
#import "AmtiumEncoder.h"
#import "AmtiumPacket.h"

#import "GCDAsyncUdpSocket.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation Amtium

- (id)initWithDelegate:(id)delegate
      didErrorSelector:(SEL)didErrorSelector
      didCloseSelector:(SEL)didCloseSelector
{
    _delegate = delegate;
    _didErrorSelector = didErrorSelector;
    _didCloseSelector = didCloseSelector;

	NSError *error = nil;

    // initialize udp socket for port 3848
    socket3848 = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_current_queue()];
    
    if (![socket3848 bindToPort:3848 error:&error])
	{
		if ([delegate respondsToSelector:didErrorSelector]) {
            @autoreleasepool {
                [delegate performSelector:didErrorSelector withObject:error];
            }
        }
        
        return nil;
	}
    
	if (![socket3848 beginReceiving:&error])
	{
		if ([delegate respondsToSelector:didErrorSelector]) {
            @autoreleasepool {
                [delegate performSelector:didErrorSelector withObject:error];
            }
        }
        
        return nil;
	}

    // initialize udp socket for port 4999
    socket4999 = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_current_queue()];

    if (![socket4999 bindToPort:4999 error:&error])
	{
		if ([delegate respondsToSelector:didErrorSelector]) {
            @autoreleasepool {
                [delegate performSelector:didErrorSelector withObject:error];
            }
        }

        return nil;
	}

	if (![socket4999 beginReceiving:&error])
	{
		if ([delegate respondsToSelector:didErrorSelector]) {
            @autoreleasepool {
                [delegate performSelector:didErrorSelector withObject:error];
            }
        }

        return nil;
	}

    NSData *data = [AmtiumPacket dataForInitialization];
    [socket4999 sendData:data toHost:@"1.1.1.8" port:3850 withTimeout:-1 tag:tag++];

    NSLog(@"init: %@", data);
    
    return [super init];
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
           didEndSelector:(SEL)selector
{
    if (_server == nil) {
        return;
    }

    _didLoginSelector = selector;

    _account = username;
    _index = 0x01000000;
    
    AmtiumPacket *packet = [AmtiumPacket packetForLoggingInWithUsername:username
                                                               password:password
                                                                  entry:_entry
                                                                     ip:_ip
                                                                    mac:_mac
                                                            dhcpEnabled:_dhcpEnabled
                                                                version:@"3.6.5"];

    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:_server port:3848 withTimeout:-1 tag:tag++];

    NSLog(@"login: %@", data);
    /*_online = YES;
    _session = @"1234567890";
    _account = username;
    if ([_delegate respondsToSelector:_didLoginSelector]) {
        @autoreleasepool {
            [_delegate performSelector:_didLoginSelector
                            withObject:[NSNumber numberWithBool:YES]
                            withObject:@"只是测试啦"];
        }
    }*/
}

- (void)logout:(SEL)selector
{
    if (_server == nil) {
        return;
    }
    
    if (_session == nil) {
        return;
    }
    
    _didLogoutSelector = selector;

    [_timer invalidate];
    _timer = nil;

    AmtiumPacket *packet = [AmtiumPacket packetForLoggingOutWithSession:_session
                                                                     ip:_ip
                                                                    mac:_mac
                                                                  index:_index];

    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:_server port:3848 withTimeout:-1 tag:tag++];
    
    NSLog(@"logout: %@", data);
    /*if ([_delegate respondsToSelector:_didLogoutSelector]) {
        @autoreleasepool {
            [_delegate performSelector:_didLogoutSelector];
        }
    }*/
}

- (void)searchServer:(SEL)selector
{
    _didServerSelector = selector;

    NSString *session = @"0000000000";

    AmtiumPacket *packet = [AmtiumPacket packetForGettingServerWithSession:session
                                                                        ip:_ip
                                                                       mac:_mac];

    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:@"1.1.1.8" port:3850 withTimeout:-1 tag:tag++];

    NSLog(@"server: %@", data);
    /*if ([_delegate respondsToSelector:_didServerSelector]) {
        @autoreleasepool {
            [_delegate performSelector:_didServerSelector withObject:@"172.16.1.180"];
        }
    }*/
}

- (void)fetchEntries:(SEL)selector
{
    if (_server == nil) {
        return;
    }
    
    _didEntriesSelector = selector;

    NSString *session = @"0000000000";

    AmtiumPacket *packet = [AmtiumPacket packetForGettingEntiesWithSession:session
                                                                       mac:_mac];

    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:_server port:3848 withTimeout:-1 tag:tag++];
    
    NSLog(@"enties: %@", data);
    /*if ([_delegate respondsToSelector:_didEntriesSelector]) {
        @autoreleasepool {
            [_delegate performSelector:_didEntriesSelector withObject:[NSArray arrayWithObjects:@"internet", @"local", nil]];
        }
    }*/
}

- (void)breath
{
    if (_server == nil) {
        return;
    }
    
    if (_session == nil) {
        return;
    }

    AmtiumPacket *packet = [AmtiumPacket packetForBreathingWithSession:_session
                                                                    ip:_ip
                                                                   mac:_mac
                                                                 index:_index];
    
    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:_server port:3848 withTimeout:-1 tag:tag++];

    NSLog(@"breath: %i", _index);
}

- (BOOL)online
{
    return _online;
}

- (NSString *)account
{
    return _account;
}

- (NSString *)server
{
    return _server;
}

- (void)setServer:(NSString *)server
{
    if (!_online) {
        _server = server;
    }
}

- (NSString *)entry
{
    return _entry;
}

- (void)setEntry:(NSString *)entry
{
    _entry = entry;
}

- (NSString *)mac
{
    return _mac;
}

- (void)setMac:(NSString *)mac
{
    if (!_online) {
        _mac = mac;
    }
}

- (NSString *)ip
{
    return _ip;
}

- (void)setIp:(NSString *)ip
{
    if (!_online) {
        _ip = ip;
    }
}

- (BOOL)dhcpEnabled
{
    return _dhcpEnabled;
}

- (void)setDhcpEnabled:(BOOL)dhcpEnabled
{
    _dhcpEnabled = dhcpEnabled;
}

- (NSString *)website
{
    return _website;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
didSendDataWithTag:(long)tag
{

}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
didNotSendDataWithTag:(long)tag
       dueToError:(NSError *)error
{
    if ([_delegate respondsToSelector:_didErrorSelector]) {
        @autoreleasepool {
            [_delegate performSelector:_didErrorSelector withObject:error];
        }
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSData *decrypted = [AmtiumCrypto decrypt:data];
    NSLog(@"packet: %@", decrypted);

    AmtiumPacket *packet = [AmtiumPacket packetWithData:decrypted];

    unsigned char action = [packet action];
    if (action == APALoginResult) {
        BOOL success = [packet boolForKey:APFSuccess];
        NSString *message = [packet stringForKey:APFMessage];
        
        if (success) {
            _session = [packet stringForKey:APFSession];
            _website = [packet stringForKey:APFWebsite];
            _online = YES;
        } else {
            _session = nil;
            _website = nil;
            _online = NO;
        }

        _timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                  target:self
                                                selector:@selector(breath)
                                                userInfo:nil
                                                 repeats:YES];

        if ([_delegate respondsToSelector:_didLoginSelector]) {
            @autoreleasepool {
                [_delegate performSelector:_didLoginSelector
                                withObject:[NSNumber numberWithBool:success]
                                withObject:message];
            }
        }
    } else if (action == APABreathResult) {
        _index = [packet unsignedIntForKey:APFIndex] + 3;
    } else if (action == APALogoutResult) {
        _session = nil;
        _website = nil;
        _online = NO;

        if ([_delegate respondsToSelector:_didLogoutSelector]) {
            @autoreleasepool {
                [_delegate performSelector:_didLogoutSelector];
            }
        }
    } else if (action == APAEntriesResult) {
        NSArray *entries = [packet stringArrayForKey:APFEntry];

        if ([_delegate respondsToSelector:_didEntriesSelector]) {
            @autoreleasepool {
                [_delegate performSelector:_didEntriesSelector
                                withObject:entries];
            }
        }
    } else if (action == APADisconnect) {
        [_timer invalidate];
        _timer = nil;

        if ([_delegate respondsToSelector:_didCloseSelector]) {
            @autoreleasepool {
                [_delegate performSelector:_didCloseSelector
                                withObject:@""];
            }
        }
    } else if (action == APAConfirmResult) {
        // no need to do anything
    } else if (action == APAServerResult) {
        NSData *serverIp = [packet dataForKey:APFServer];

        unsigned char buffer[4];
        [serverIp getBytes:buffer length:4];

        _server = [NSString stringWithFormat:@"%i.%i.%i.%i", buffer[0], buffer[1], buffer[2], buffer[3]];
        
        if ([_delegate respondsToSelector:_didServerSelector]) {
            @autoreleasepool {
                [_delegate performSelector:_didServerSelector
                                withObject:_server];
            }
        }
    } else {
        // do nothing
    }
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock
                withError:(NSError *)error
{
    [_timer invalidate];
    _timer = nil;
    
    if ([_delegate respondsToSelector:_didErrorSelector]) {
        @autoreleasepool {
            [_delegate performSelector:_didErrorSelector withObject:error];
        }
    }
}

@end
