//
//  LC_UDID.m
//  LCFramework

//  Created by Megan ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-17.
//  Copyright (c) 2017年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "LC_UDID.h"
#import "LC_Keychain.h"

#define KEY_CHAIN_ADDRESS @"LC_UDID"

static NSString * sUUID = nil;

@implementation LC_UDID

+ (NSString *) UDID
{
    if (sUUID) {
        return sUUID;
    }
    
    NSString * udid = [LC_UDID UDIDFromKeyChain];
    
    if (!udid) {
        
        //NSString * sysVersion = [UIDevice currentDevice].systemVersion;
        
        //float version = [sysVersion floatValue];
        
        //if (version >= 6.0) {
          //  udid = [LC_UDID UDIDFromIOS6Later];
        //}
        //else{
            udid = [LC_UDID UDIDFromIOS6Before];
        //}
        
        [LC_UDID setUDIDToKeyChain:udid];
    }

    sUUID = udid;
    
    return udid;
}

+(NSString *) UDIDFromIOS6Later
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+(NSString *) UDIDFromIOS6Before
{
    return [self uuid];
}

+(NSString *) UDIDFromKeyChain
{
    return [LC_Keychain objectForKey:KEY_CHAIN_ADDRESS];
}

+(void) setUDIDToKeyChain:(NSString *)udid
{
    [LC_Keychain setObject:udid forKey:KEY_CHAIN_ADDRESS];
}

+ (NSString *) uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}


@end
