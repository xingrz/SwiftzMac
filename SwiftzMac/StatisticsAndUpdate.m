//
//  StatisticsAndUpdate.m
//  SwiftzMac
//
//  Created by XiNGRZ on 13-3-13.
//  Copyright (c) 2013年 XiNGRZ. All rights reserved.
//

#import "StatisticsAndUpdate.h"

@implementation StatisticsAndUpdate

+ (NSString *)checkUpdateWithIdenti:(NSString *)identi
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *url = [NSString stringWithFormat:@"http://swiftz.sinaapp.com/update.php?ver=%@&id=%@", version, identi];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSHTTPURLResponse *response = nil;

    NSError *error = nil;

    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];

    if ([response statusCode] == 200) {
        NSString *update = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (![version isEqualToString:update]) {
            return update;
        }
    }

    return nil;
}

@end
