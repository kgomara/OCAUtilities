//
//  UIToolBar+OCAUtilities.m
//  LiteratureRack
//
//  Created by KEVIN OMARA on 6/16/12.
//  Copyright (c) 2012 Somnio Solutions, Inc. All rights reserved.
//

#import "OCAUtilities.h"

@implementation UIToolbar (OCAUtilities)

@end

@implementation TransparentToolBar

// ===============================================================================
#pragma mark - Public instance methods
// ===============================================================================

/********************************************************************************/
- (void)drawRect:(CGRect)rect
{
    // HACK to have a transparent toolbar for the NavBar
    // setting toolbar.background = clearColor does not work
}

@end
