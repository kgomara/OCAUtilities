//
//  UIViewController+OCAUtilities.m
//  UIViewController+OCAUtilities
//
//  Created by Kent Nguyen on 2/5/12.
//  Renamed and modified by Kevin O'Mara 6/28/2012
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "OCAUtilities.h"

@implementation UIViewController (OCAUtilities)

// =========================================================================================================
#pragma mark - Private Instance methods
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
-(UIView*)parentTarget
{
    DLog(/*@"self=%@", self.class*/);
    // To make it work with UINav & UITabbar as well
    UIViewController *target = self;
    
    while (target.parentViewController != nil) {
        // Walk the chain of parentViewControllers until we get to the root of the chain
        target = target.parentViewController;
    }
    
    return target.view;
}

//----------------------------------------------------------------------------------------------------------
-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward
{
    DLog();
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34    = 1.0/-900;
    t1        = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1        = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34    = t1.m34;
    t2        = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
    t2        = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath: @"transform"];
    animation.toValue             = [NSValue valueWithCATransform3D:t1];
    animation.duration            = kSemiModalAnimationDuration/2;
    animation.fillMode            = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2      = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue                = [NSValue valueWithCATransform3D: (_forward ? t2 : CATransform3DIdentity)];
    animation2.beginTime              = animation.duration;
    animation2.duration               = animation.duration;
    animation2.fillMode               = kCAFillModeForwards;
    animation2.removedOnCompletion    = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
    
    CAAnimationGroup *group   = [CAAnimationGroup animation];
    group.fillMode            = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration: animation.duration*2];
    [group setAnimations: [NSArray arrayWithObjects: animation, animation2, nil]];
    
    return group;
}

//----------------------------------------------------------------------------------------------------------
-(void)presentSemiViewController: (UIViewController*)vc
{
    DLog(/*@"vc.class=%@", vc.class*/);
    [self presentSemiView: vc.view];
}

//----------------------------------------------------------------------------------------------------------
-(void)presentSemiView: (UIView*)destinationView
{
    // Determine target
    UIView * sourceView = [self parentTarget];
    DLog(/*@"self.class=%@, destinationView=%@, sourceView=%@", self.class, destinationView.class, sourceView.class*/);
    if (![sourceView.subviews containsObject: destinationView]) {
        // Calulate all frames
        UIInterfaceOrientation orientation = [self interfaceOrientation];
        CGRect destinationFrame = destinationView.frame;
        CGRect sourceFrame      = sourceView.frame;
        CGRect insetFrame;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            insetFrame  = CGRectMake(0, sourceFrame.size.width-destinationFrame.size.width, sourceFrame.size.height, destinationFrame.size.width);
        } else {
            insetFrame  = CGRectMake(0, sourceFrame.size.height-destinationFrame.size.height, sourceFrame.size.width, destinationFrame.size.height);
        }
        CGRect overlayFrame = CGRectMake(0, 0, sourceFrame.size.width, sourceFrame.size.height-destinationFrame.size.height);
        
        // Add semi overlay
        UIView *overlay = [[UIView alloc] initWithFrame: sourceView.bounds];
        overlay.backgroundColor = [UIColor blackColor];
        
        // Take screenshot and scale
        UIGraphicsBeginImageContext( self.view.bounds.size);
        [self.view.layer renderInContext: UIGraphicsGetCurrentContext()];
        UIImage *sourceImage  = UIGraphicsGetImageFromCurrentImageContext();
        UIImageView *screenShotImageView = [[UIImageView alloc] initWithImage: sourceImage];
        // HACK - the above renderInContext gets the correct screen image,
        // ...the below seems to be necessary to get the controller hierarchy to work...
        [sourceView.layer renderInContext: UIGraphicsGetCurrentContext()];
        [overlay addSubview: screenShotImageView];
        [sourceView  addSubview: overlay];
        
        // Dismiss button
        // Don't use UITapGestureRecognizer to avoid complex handling
        UIButton *dismissButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [dismissButton addTarget: self 
                          action: @selector( dismissSemiModalView) 
                forControlEvents: UIControlEventTouchUpInside];
        dismissButton.backgroundColor   = [UIColor clearColor];
        dismissButton.frame             = overlayFrame;
        [overlay addSubview: dismissButton];
        
        // Begin overlay animation
        [screenShotImageView.layer addAnimation: [self animationGroupForward:YES] 
                                         forKey: @"pushedBackAnimation"];
        [UIView animateWithDuration: kSemiModalAnimationDuration 
                         animations: ^{
            screenShotImageView.alpha = 0.5;
        }];
        
        // Present view animated        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            destinationView.frame = CGRectMake(0, sourceFrame.size.width, sourceFrame.size.height, destinationFrame.size.width);
        } else {
            destinationView.frame = CGRectMake(0, sourceFrame.size.height, sourceFrame.size.width, destinationFrame.size.height);
        }
        [sourceView addSubview: destinationView];
        destinationView.layer.shadowColor    = [[UIColor blackColor] CGColor];
        destinationView.layer.shadowOffset   = CGSizeMake(0, -2);
        destinationView.layer.shadowRadius   = 5.0;
        destinationView.layer.shadowOpacity  = 0.8;
        [UIView animateWithDuration: kSemiModalAnimationDuration 
                         animations: ^{
            destinationView.frame = insetFrame;
        }];
    }
}

//----------------------------------------------------------------------------------------------------------
-(void)dismissSemiModalView
{
    DLog();
    UIView *target  = [self parentTarget];
    UIView *modal   = [target.subviews objectAtIndex: target.subviews.count-1];
    UIView *overlay = [target.subviews objectAtIndex: target.subviews.count-2];
    [UIView animateWithDuration: kSemiModalAnimationDuration
                     animations: ^{
        modal.frame = CGRectMake(0, target.frame.size.height, modal.frame.size.width, modal.frame.size.height);
    } completion: ^(BOOL finished) {
        [overlay removeFromSuperview];
        [modal removeFromSuperview];
    }];
    
    // Begin overlay animation
    UIImageView *ss = (UIImageView*)[overlay.subviews objectAtIndex: 0];
    [ss.layer addAnimation: [self animationGroupForward: NO] 
                    forKey: @"bringForwardAnimation"];
    [UIView animateWithDuration: kSemiModalAnimationDuration 
                     animations: ^{
        ss.alpha = 1;
    }];
}

@end

