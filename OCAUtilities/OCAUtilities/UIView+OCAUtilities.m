//
//  UIView+OCAUtilities.m
//  OCAUtilities
//
//  Created by KEVIN OMARA on 6/16/12.
//  Copyright (c) 2012-2013 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAUtilities.h"


#pragma mark - UIView categories

@implementation UIView (OCAUtilities)

// =========================================================================================================
#pragma mark - Public instance methods
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
- (void)fadeSubViewIn:(UIView*)subView
{
    DLog();
    // fade a view into existence
    subView.alpha = 0.0f;
    [self addSubview:subView];
    [UIView animateWithDuration:3.0f 
                     animations:^(void) {
            subView.alpha = 1.0f;
        }
    ];
}

//----------------------------------------------------------------------------------------------------------
- (void)fadeSubViewOut:(UIView*)subView
{
    DLog();
    // fade a view out of existence
    [UIView animateWithDuration:3.0f 
                     animations:^(void) { 
            subView.alpha = 0.0f;
        } 
                     completion:^(BOOL complete) {
            [subView removeFromSuperview];
        }
     ];
}

//----------------------------------------------------------------------------------------------------------
- (void)centerInView:(UIView *)containingView
{
    DLog();
    CGPoint centerPoint = containingView.center;
    [self setCenter: centerPoint];
}

// Convenience category method to find actual ViewController that contains a view
// Adapted from: http://stackoverflow.com/questions/1340434/get-to-uiviewcontroller-from-uiview-on-iphone

//----------------------------------------------------------------------------------------------------------
- (UIViewController *) containingViewController
{
    DLog();
    UIView *target = self.superview ? self.superview : self;
    
    return (UIViewController *)[target traverseResponderChainForUIViewController];
}

//----------------------------------------------------------------------------------------------------------
- (id) traverseResponderChainForUIViewController
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass: [UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass: [UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end

