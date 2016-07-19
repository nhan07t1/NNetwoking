//
//  NetworkHelper
//
//  Created by viettel on 7/10/14.
//  Copyright (c) 2014 Nhan Nguyen. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AFNetworking.h"

#define REQUEST_TYPE_GET 1
#define REQUEST_TYPE_HEAD 3
#define REQUEST_TYPE_POST 5
#define REQUEST_TYPE_PUT 7
#define REQUEST_TYPE_PATCH 9
#define REQUEST_TYPE_DELETE 11

@interface Network: NSObject
    @property (nonatomic, strong) Reachability *reachability;
    @property (readonly, nonatomic) BOOL NETWORK_AVAIABLE;

- (BOOL)isNetworkAvaiable;
- (NSString *)getIPAddress;
+ (instancetype)sharedManager;
@end
