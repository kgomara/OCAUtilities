//
//  UIFontDescriptor+OCAUtilities.m
//  OCAUtilities
//
//  Created by Kevin O'Mara on 1/5/14.
//  Copyright (c) 2014 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAUtilities.h"

@implementation UIFontDescriptor (OCAUtilities)

//----------------------------------------------------------------------------------------------------------
+ (UIFontDescriptor *)OCAPreferredFontDescriptorWithTextStyle: (NSString *)aTextStyle
                                                        scale: (CGFloat)aScale
{
    UIFontDescriptor *newBaseDescriptor = [self preferredFontDescriptorWithTextStyle: aTextStyle];
    
    return [newBaseDescriptor fontDescriptorWithSize: lrint([newBaseDescriptor pointSize] * aScale)];
}

//----------------------------------------------------------------------------------------------------------
- (NSString *)OCATextStyle
{
    return [self objectForKey: @"NSCTFontUIUsageAttribute"];
}

//----------------------------------------------------------------------------------------------------------
- (UIFontDescriptor *)OCAFontDescriptorWithScale:(CGFloat)aScale
{
    return [self fontDescriptorWithSize: lrint(self.pointSize * aScale)];
}

@end
