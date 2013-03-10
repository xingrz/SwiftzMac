//
//  Amtium.h
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-5.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDAsyncUdpSocket.h"

@interface Amtium : NSObject<GCDAsyncUdpSocketDelegate> {
    BOOL _online;
    NSString *_account;
    
    NSString *_server;
    NSString *_entry;   
    NSString *_mac;
    NSString *_ip;
    BOOL _dhcpEnabled;
    
    NSString *_session;
    NSString *_website;
    unsigned int _index;
    NSTimer *_timer;
    
    GCDAsyncUdpSocket *socket3848;
    GCDAsyncUdpSocket *socket4999;
    long tag;
    
    id _delegate;
    
    SEL _didErrorSelector;
    SEL _didLoginSelector;
    SEL _didBreathSelector;
    SEL _didLogoutSelector;
    SEL _didEntriesSelector;
    SEL _didCloseSelector;
    SEL _didConfirmSelector;
    SEL _didServerSelector;
}

@property (readonly) BOOL online;
@property (readonly) NSString *account;
@property (readonly) NSString *website;
@property NSString *server;
@property NSString *entry;
@property NSString *mac;
@property NSString *ip;
@property BOOL dhcpEnabled;

- (id)initWithDelegate:(id)delegate
      didErrorSelector:(SEL)didErrorSelector
      didCloseSelector:(SEL)didCloseSelector;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
           didEndSelector:(SEL)selector;

- (void)logout:(SEL)selector;

- (void)searchServer:(SEL)selector;

- (void)fetchEntries:(SEL)selector;

@end
