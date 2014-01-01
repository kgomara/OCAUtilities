//
//  UILabel+OCAUtilities.m
//  LiteratureRack
//
//  Created by KEVIN OMARA on 6/16/12.
//  Copyright (c) 2012-2013 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAUtilities.h"

@implementation UILabel (OCAUtilities)		// Category for UILabel

// =========================================================================================================
#pragma mark - Public instance methods
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
- (void)sizeToFitFixedWidth:(NSInteger)fixedWidth
{
    // set the label's width
    self.frame          = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWidth, 0);
    // ...and ensures other settings allow re-sizing
    self.lineBreakMode  = NSLineBreakByWordWrapping;
    self.numberOfLines  = 0;
    
    [self sizeToFit];
}

@end
