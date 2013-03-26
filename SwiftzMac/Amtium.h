//
//  Amtium.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-5.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDAsyncUdpSocket.h"

@class AmtiumLoginResult;

@interface Amtium : NSObject<GCDAsyncUdpSocketDelegate> {
    NSString *session;
    unsigned int index;
    NSTimer *timer;

    NSTimer *loginRetryTimer;
    BOOL loginCouldRetry;

    NSString *usernameLogged;
    NSString *passwordLogged;

    GCDAsyncUdpSocket *socket3848;
    GCDAsyncUdpSocket *socket4999;
    long tag;
}

@property (readwrite, assign) id delegate;

@property (readwrite, assign) SEL didErrorSelector;
@property (readwrite, assign) SEL didLoginSelector;
@property (readwrite, assign) SEL didBreathSelector;
@property (readwrite, assign) SEL didLogoutSelector;
@property (readwrite, assign) SEL didCloseSelector;
@property (readwrite, assign) SEL didConfirmSelector;
@property (readwrite, assign) SEL didGetEntriesSelector;
@property (readwrite, assign) SEL didGetServerSelector;

@property (readonly) BOOL online;
@property (readonly) NSString *account;
@property (readonly) NSString *website;
@property (readwrite, copy) NSString *server;
@property (readwrite, copy) NSString *entry;
@property (readwrite, copy) NSString *mac;
@property (readwrite, copy) NSString *ip;
@property (readwrite, assign) BOOL dhcpEnabled;

+ (id)amtiumWithDelegate:(id)theDelegate
        didErrorSelector:(SEL)didError
        didCloseSelector:(SEL)didClose;

- (id)initWithDelegate:(id)theDelegate
      didErrorSelector:(SEL)didError
      didCloseSelector:(SEL)didClose;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
         didLoginSelector:(SEL)selector;

- (void)logout:(SEL)selector;

- (void)searchServer:(SEL)selector;

- (void)fetchEntries:(SEL)selector;

- (void)close;

@end

@protocol AmtiumDelegate
@optional

- (void)amtium:(Amtium *)amtium didError:(NSError *)error;
- (void)amtium:(Amtium *)amtium didCloseWithReason:(NSNumber *)reason;
- (void)amtium:(Amtium *)amtium didLoginWithResult:(AmtiumLoginResult *)result;
- (void)amtium:(Amtium *)amtium didLogout:(NSNumber *)success;
- (void)amtium:(Amtium *)amtium didGetEntries:(NSArray *)entries;
- (void)amtium:(Amtium *)amtium didGetServer:(NSString *)server;

@end
