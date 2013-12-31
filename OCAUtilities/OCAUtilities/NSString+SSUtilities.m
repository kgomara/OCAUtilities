//
//  NSString+OCAUtilities.m
//  LiteratureRack
//
//  Created by KEVIN OMARA on 6/20/12.
//  Copyright (c) 2012 Somnio Solutions, Inc. All rights reserved.
//

#import "OCAUtilities.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (OCAUtilities)

/********************************************************************************/
- (NSString *)MD5Hash
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x", md5Buffer[i]];
    
    return output;
}

/********************************************************************************/
- (NSString *)getRFC3339String
{
    DLog();
    
    NSString *theDate   = self;
    NSRange colon       = [self rangeOfString: @":"
                                      options: NSBackwardsSearch];
    if (colon.location != NSNotFound) {
        theDate = [theDate stringByReplacingCharactersInRange: colon
                                                   withString: @""];
    }
    
    return theDate;
}



@end
