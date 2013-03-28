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
#import "AmtiumLoginResult.h"

#import "GCDAsyncUdpSocket.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation Amtium

@synthesize delegate;

@synthesize didErrorSelector;
@synthesize didLoginSelector;
@synthesize didBreathSelector;
@synthesize didLogoutSelector;
@synthesize didCloseSelector;
@synthesize didConfirmSelector;
@synthesize didGetEntriesSelector;
@synthesize didGetServerSelector;

@synthesize online;
@synthesize account;
@synthesize website;
@synthesize server;
@synthesize entry;
@synthesize mac;
@synthesize ip;
@synthesize dhcpEnabled;

+ (id)amtiumWithDelegate:(id)theDelegate
        didErrorSelector:(SEL)didError
        didCloseSelector:(SEL)didClose
{
    return [[self alloc] initWithDelegate:theDelegate
                         didErrorSelector:didError
                         didCloseSelector:didClose];
}

- (id)initWithDelegate:(id)theDelegate
      didErrorSelector:(SEL)didError
      didCloseSelector:(SEL)didClose
{
    [self setDelegate:theDelegate];
    [self setDidErrorSelector:didError];
    [self setDidCloseSelector:didClose];

	NSError *error = nil;

    // initialize udp socket for port 3848
    socket3848 = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_current_queue()];
    
    if (![socket3848 bindToPort:3848 error:&error])
	{
        [self performSelector:didErrorSelector onDelegateWithObject:error];
        return nil;
	}
    
	if (![socket3848 beginReceiving:&error])
	{
		[self performSelector:didErrorSelector onDelegateWithObject:error];
        return nil;
	}

    // initialize udp socket for port 4999
    socket4999 = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_current_queue()];

    if (![socket4999 bindToPort:4999 error:&error])
	{
        [self performSelector:didErrorSelector onDelegateWithObject:error];
        return nil;
	}

	if (![socket4999 beginReceiving:&error])
	{
        [self performSelector:didErrorSelector onDelegateWithObject:error];
        return nil;
	}

    NSData *data = [AmtiumPacket dataForInitialization];
    [socket4999 sendData:data toHost:@"1.1.1.8" port:3850 withTimeout:-1 tag:tag++];

    NSLog(@"init: %@", data);

    return [super init];
}

- (void)close
{
    [socket3848 close];
    socket3848 = nil;
    
    [socket4999 close];
    socket4999 = nil;

    [self willChangeValueForKey:@"website"];
    [self willChangeValueForKey:@"online"];

    session = nil;
    website = nil;
    online = NO;

    [self didChangeValueForKey:@"website"];
    [self didChangeValueForKey:@"online"];
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
         didLoginSelector:(SEL)selector
{
    if (server == nil) {
        return;
    }

    [self setDidLoginSelector:selector];

    usernameLogged = username;
    passwordLogged = password;

    index = 0x01000000;

    [self doLogin];
    
    loginCouldRetry = YES;
    loginRetryTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                       target:self
                                                     selector:@selector(loginTimeout:)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)doLogin
{
    AmtiumPacket *packet = [AmtiumPacket packetForLoggingInWithUsername:usernameLogged
                                                               password:passwordLogged
                                                                  entry:entry
                                                                     ip:ip
                                                                    mac:mac
                                                            dhcpEnabled:dhcpEnabled
                                                                version:@"3.6.5"];

    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:server port:3848 withTimeout:-1 tag:tag++];

    NSLog(@"login: %@", data);
}

- (void)loginTimeout:(NSTimer *)aTimer
{
    [loginRetryTimer invalidate];
    loginRetryTimer = nil;
    
    if (loginCouldRetry) {
        [self doLogin];
        loginCouldRetry = NO;
    }
}

- (void)cancelLogin
{
    if (loginRetryTimer != nil) {
        [loginRetryTimer invalidate];
        loginRetryTimer = nil;
    }
}

- (void)logout:(SEL)selector
{
    if (server == nil) {
        return;
    }
    
    if (session == nil) {
        return;
    }
    
    [self setDidLogoutSelector:selector];

    [timer invalidate];
    timer = nil;

    AmtiumPacket *packet = [AmtiumPacket packetForLoggingOutWithSession:session
                                                                     ip:ip
                                                                    mac:mac
                                                                  index:index];

    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:server port:3848 withTimeout:-1 tag:tag++];
    
    NSLog(@"logout: %@", data);
}

- (void)searchServer:(SEL)selector
{
    [self setDidGetServerSelector:selector];

    AmtiumPacket *packet = [AmtiumPacket packetForGettingServerWithSession:@"0000000000"
                                                                        ip:ip
                                                                       mac:mac];

    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:@"1.1.1.8" port:3850 withTimeout:-1 tag:tag++];

    NSLog(@"server: %@", data);
}

- (void)fetchEntries:(SEL)selector
{
    if (server == nil) {
        return;
    }
    
    [self setDidGetEntriesSelector:selector];

    AmtiumPacket *packet = [AmtiumPacket packetForGettingEntiesWithSession:@"0000000000"
                                                                       mac:mac];

    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:server port:3848 withTimeout:-1 tag:tag++];
    
    NSLog(@"enties: %@", data);
}

- (void)breath
{
    if (server == nil) {
        return;
    }
    
    if (session == nil) {
        return;
    }

    AmtiumPacket *packet = [AmtiumPacket packetForBreathingWithSession:session
                                                                    ip:ip
                                                                   mac:mac
                                                                 index:index];
    
    NSData *data = [AmtiumCrypto encrypt:[packet data]];
    [socket3848 sendData:data toHost:server port:3848 withTimeout:-1 tag:tag++];

    NSLog(@"breath: %i", index);
}

- (NSString *)server
{
    return server;
}

- (void)setServer:(NSString *)theServer
{
    if (!online) {
        [self willChangeValueForKey:@"server"];
        server = theServer;
        [self didChangeValueForKey:@"server"];
    }
}

- (NSString *)mac
{
    return mac;
}

- (void)setMac:(NSString *)theMac
{
    if (!online) {
        [self willChangeValueForKey:@"mac"];
        mac = theMac;
        [self didChangeValueForKey:@"mac"];
    }
}

- (NSString *)ip
{
    return ip;
}

- (void)setIp:(NSString *)theIp
{
    if (!online) {
        [self willChangeValueForKey:@"ip"];
        ip = theIp;
        [self didChangeValueForKey:@"ip"];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
didSendDataWithTag:(long)tag
{

}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
didNotSendDataWithTag:(long)tag
       dueToError:(NSError *)error
{
    /*[_timer invalidate];
    _timer = nil;
    _session = nil;
    _website = nil;
    _online = NO;

    if ([_delegate respondsToSelector:_didErrorSelector]) {
        @autoreleasepool {
            [_delegate performSelector:_didErrorSelector withObject:error];
        }
    }*/
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSString *host = nil;
    uint16_t port;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];

    if (!([host isEqualToString:@"1.1.1.8"] || [host isEqualToString:server])) {
        // 抛弃非服务器IP发来的包
        return;
    }

    NSData *decrypted = [AmtiumCrypto decrypt:data];
    AmtiumPacket *packet = [AmtiumPacket packetWithData:decrypted];
    if (packet == nil) {
        // 抛弃解码失败的包
        return;
    }

    unsigned char action = [packet action];
    if (action == APALoginResult) {
        [loginRetryTimer invalidate];
        loginRetryTimer = nil;

        BOOL success = [packet boolForKey:APFSuccess];
        NSString *message = [packet stringForKey:APFMessage];

        AmtiumLoginResult *result = [AmtiumLoginResult result:success withMessage:message];

        [self willChangeValueForKey:@"account"];
        [self willChangeValueForKey:@"website"];
        [self willChangeValueForKey:@"online"];

        if (success) {
            account = usernameLogged;
            session = [packet stringForKey:APFSession];
            website = [packet stringForKey:APFWebsite];
            online = YES;
        } else {
            account = nil;
            session = nil;
            website = nil;
            online = NO;
        }

        [self didChangeValueForKey:@"account"];
        [self didChangeValueForKey:@"website"];
        [self didChangeValueForKey:@"online"];

        timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                 target:self
                                               selector:@selector(breath)
                                               userInfo:nil
                                                repeats:YES];

        [self performSelector:didLoginSelector onDelegateWithObject:result];
    } else if (action == APABreathResult) {
        index = [packet unsignedIntForKey:APFIndex] + 3;
    } else if (action == APALogoutResult) {
        BOOL success = [packet boolForKey:APFSuccess];

        [self willChangeValueForKey:@"website"];
        [self willChangeValueForKey:@"online"];

        session = nil;
        website = nil;
        online = NO;

        [self didChangeValueForKey:@"website"];
        [self didChangeValueForKey:@"online"];

        [self performSelector:didLogoutSelector
         onDelegateWithObject:[NSNumber numberWithBool:success]];
    } else if (action == APAEntriesResult) {
        NSArray *entries = [packet stringArrayForKey:APFEntry];
        [self performSelector:didGetEntriesSelector onDelegateWithObject:entries];
    } else if (action == APADisconnect) {
        [timer invalidate];
        timer = nil;

        unsigned char reason = [packet unsignedCharForKey:APFReason];

        [self performSelector:didCloseSelector
         onDelegateWithObject:[NSNumber numberWithUnsignedChar:reason]];
    } else if (action == APAConfirmResult) {
        // no need to do anything
    } else if (action == APAServerResult) {
        NSData *serverIp = [packet dataForKey:APFServer];

        unsigned char buffer[4];
        [serverIp getBytes:buffer length:4];

        NSString *theServer = [NSString stringWithFormat:@"%i.%i.%i.%i", buffer[0], buffer[1], buffer[2], buffer[3]];

        [self setServer:theServer];
        [self performSelector:didGetServerSelector onDelegateWithObject:theServer];
    } else {
        // do nothing
    }
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock
                withError:(NSError *)error
{
    [timer invalidate];
    timer = nil;
    session = nil;

    [self willChangeValueForKey:@"website"];
    [self willChangeValueForKey:@"online"];
    
    website = nil;
    online = NO;

    [self didChangeValueForKey:@"website"];
    [self didChangeValueForKey:@"online"];

    [self performSelector:didErrorSelector onDelegateWithObject:error];
}

- (void)performSelector:(SEL)selector onDelegateWithObject:(id)object
{
    if ([[self delegate] respondsToSelector:selector]) {
        @autoreleasepool {
            [[self delegate] performSelector:selector
                                  withObject:self
                                  withObject:object];
        }
    }
}

@end
