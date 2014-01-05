//
//  UITextField+OCAUtilities.m
//  OCAUtilities
//
//  Created by Kevin O'Mara on 1/5/14.
//  Copyright (c) 2014 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAUtilities.h"

@implementation UITextField (OCAUtilities)

//----------------------------------------------------------------------------------------------------------
- (NSString *)OCATextStyle
{
    return [self.font OCATextStyle];
}

@end
