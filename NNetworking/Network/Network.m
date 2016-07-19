//
//  NetworkHelper.m
//
//  Created by viettel on 7/10/14.
//  Copyright (c) 2014 Nhan Nguyen. All rights reserved.
//

#import "Network.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation Network

static Network *sharedManager = nil;

- (id)init
{
    self = [super init];
    if (self) {
        [self checkNetwork];
    }
    return  self;
}

+ (instancetype)sharedManager {
    @synchronized(self)
    {
        if (sharedManager && [sharedManager isKindOfClass:[self class]]){
            return sharedManager;
        }else{
            sharedManager = [[self alloc] init];
            
            return sharedManager;
        }
    }
}

#pragma Network listener

- (void)checkNetwork
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifierNetworkConnection:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [self notifierNetworkConnection:nil];
}

- (void)notifierNetworkConnection:(NSNotification*) notification
{
    NetworkStatus status = [self.reachability currentReachabilityStatus];
    switch (status) {
        case ReachableViaWiFi:
            _NETWORK_AVAIABLE = YES;
            break;
        case ReachableViaWWAN:
            _NETWORK_AVAIABLE = YES;
            break;
        default:
            _NETWORK_AVAIABLE = NO;
            break;
    }
}

- (BOOL)isNetworkAvaiable
{
    return _NETWORK_AVAIABLE;
}



- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

@end
