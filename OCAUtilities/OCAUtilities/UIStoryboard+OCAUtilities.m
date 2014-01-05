//
//  UIStoryboard+OCAUtilities.m
//  OCAUtilities
//
//  Created by Kevin O'Mara on 1/5/14.
//  Copyright (c) 2014 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAUtilities.h"

@implementation UIStoryboard (OCAUtilities)

//----------------------------------------------------------------------------------------------------------
+ (UIStoryboard *)main_iPhoneStoryboard
{
    return [UIStoryboard storyboardWithName: @"Main_iPhone"
                                     bundle: nil];
}

//----------------------------------------------------------------------------------------------------------
+ (UIStoryboard *)main_iPadStoryboard
{
    return [UIStoryboard storyboardWithName: @"Main_iPad"
                                     bundle: nil];
}

@end
