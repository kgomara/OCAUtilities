//
//  UIFont+OCAUtilities.m
//  OCAUtilities
//
//  Created by Kevin O'Mara on 1/5/14.
//  Copyright (c) 2014 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAUtilities.h"

@implementation UIFont (OCAUtilities)

//----------------------------------------------------------------------------------------------------------
+ (UIFont *)OCAPreferredFontWithTextStyle: (NSString *)aTextStyle
                                    scale: (CGFloat)aScale
{
    UIFontDescriptor *newFontDescriptor = [UIFontDescriptor OCAPreferredFontDescriptorWithTextStyle: aTextStyle
                                                                                              scale: aScale];
    
    return [UIFont fontWithDescriptor: newFontDescriptor
                                 size: newFontDescriptor.pointSize];
}

//----------------------------------------------------------------------------------------------------------
- (NSString *)OCATextStyle
{
    return [self.fontDescriptor OCATextStyle];
}

//----------------------------------------------------------------------------------------------------------
- (UIFont *)OCAFontWithScale: (CGFloat)aScale
{
    return [self fontWithSize: lrint(self.pointSize * aScale)];
}

@end
