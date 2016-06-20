//
//  BookLoader.m
//  BookReader
//
//  Created by terababy on 10-8-26.
//  Copyright 2010 terababy. All rights reserved.
//

#import "UserAnalyst.h"
#import "MobClick.h"
#import "CCLocalDataLoader.h"
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <netinet/in.h>
#include <net/if.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <net/if_dl.h>

#define EVENT_UNLOCK_LEVEL @"LevelUser"
#define EVENT_REPLAY_LEVEL @"LevelReplay"
#define EVENT_BROADCAST @"Broad"
#define EVENT_PROMOTION @"Promotion"

@implementation UserAnalyst

+ (void)startWithAppkey:(NSString *)appkey {
    
    [MobClick startWithAppkey:appkey reportPolicy:REALTIME channelId:nil];
    [MobClick checkUpdate];
    [MobClick updateOnlineConfig];
    
    
    NSString * appKey = appkey;
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [UserAnalyst macString];
    NSString * idfa = [UserAnalyst idfaString];
    NSString * idfv = [UserAnalyst idfvString];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
}

+ (void)updateOnlineConfig {
    
    [MobClick updateOnlineConfig];
}

+ (void)playLevel:(int)level {
    
    NSString *levelStr = [NSString stringWithFormat:@"关卡%d", level];
    [MobClick event:EVENT_REPLAY_LEVEL label:levelStr];
    
    NSString *sendKey = [NSString stringWithFormat:@"SentLevelUser%d", level];
    BOOL sent = [[CCLocalDataLoader sharedLoader] boolForKey:sendKey];
    if (!sent) {
        NSString *levelStr = [NSString stringWithFormat:@"关卡%d", level];
        [MobClick event:EVENT_UNLOCK_LEVEL label:levelStr];
        [[CCLocalDataLoader sharedLoader] setBoolValue:TRUE forKey:sendKey];
    }
}

+ (void)broadcast:(NSString*)channel {
    NSString *value = [NSString stringWithFormat:@"%@", channel];
    [MobClick event:EVENT_BROADCAST label:value];
}

+ (void)promotion:(NSString*)toApp {
    NSString *value = [NSString stringWithFormat:@"%@", toApp];
    [MobClick event:EVENT_PROMOTION label:value];
}

+ (bool)isOpenFlag:(NSString*)key {
    NSString *value = [MobClick getConfigParams:key];
    if (value) {
        bool rtn = [value boolValue];
        return rtn;
    }
    return false;
}

+ (int)getIntFlag:(NSString*)key defaultValue:(int)defaultV {
    NSString *value = [MobClick getConfigParams:key];
    if (value) {
        int rtn = [value intValue];
        return rtn;
    }
    return defaultV;
}

+ (NSString*)getOnlineParam:(NSString*)key {
    NSString *value = [MobClick getConfigParams:key];
    return value;
}

- (id)init {
	if (self == [super init]) {
        
	}
	return self;
}

+ (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

+ (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

+ (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}

@end
