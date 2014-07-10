//
//  OCAUtilities.m
//  OCAUtilities
//
//  Created by Kevin O'Mara on 12/30/13.
//  Copyright (c) 2012-2013 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAUtilities.h"

@interface OCAUtilities ()

+ (void)globalResignFirstResponder;
+ (void)globalResignFirstResponderRecursively: (UIView*)view;
+ (CGRect)getScreenBoundsForOrientation: (UIDeviceOrientation)orientation;

@end

@implementation OCAUtilities

// =========================================================================================================
#pragma mark - Public class methods
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
+ (void)showAlertWithMessageAndType: (NSString*)theMessage
                          alertType: (NSString*)theType
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: theType
                                                    message: theMessage
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString(@"OK", @"OK")
                                          otherButtonTitles: nil];
    [alert show];
}

//----------------------------------------------------------------------------------------------------------
+ (void)showErrorWithMessage: (NSString*)theMessage
{
    [self showAlertWithMessageAndType: theMessage
                            alertType: NSLocalizedString( @"Error", @"Error")];
}

//----------------------------------------------------------------------------------------------------------
+ (void)showWarningWithMessage: (NSString*)theMessage
{
    [self showAlertWithMessageAndType: theMessage
                            alertType: NSLocalizedString(@"Warning", @"Warning")];
}

//----------------------------------------------------------------------------------------------------------
+ (CGRect)getScreenBoundsForCurrentOrientation
{
    return [self getScreenBoundsForOrientation: [[UIDevice currentDevice] orientation]];
}

//----------------------------------------------------------------------------------------------------------
+ (void)dismissKeyboard
{
    [self globalResignFirstResponder];
}

//----------------------------------------------------------------------------------------------------------
+ (void)offsetTextField: (CGRect)fieldRect
           inScrollView: (UIScrollView *)scrollView
       withNotification: (NSNotification *)aNotification
{
    DLog(/*@"fieldRect=%f, %f, %f, %f, scrollView=%@, aNotification=%@", fieldRect.origin.x, fieldRect.origin.y, fieldRect.size.width, fieldRect.size.height, scrollView, aNotification*/);
    assert( scrollView);
    assert( aNotification);
    
    NSDictionary* info  = [aNotification userInfo];
    // Get the keyboard size, which is always in window coordinates and Portrait
    CGSize kbSize       = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (kbSize.width < kbSize.height) {
        // we must be in landscape, swap width and height
        CGFloat swap    = kbSize.width;
        kbSize.width    = kbSize.height;
        kbSize.height   = swap;
    }
    UIEdgeInsets contentInsets          = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset             = contentInsets;
    scrollView.scrollIndicatorInsets    = contentInsets;
}

//----------------------------------------------------------------------------------------------------------
+ (void)resetTextField: (UIView *)activeField
          inScrollView: (UIScrollView *)scrollView
{
    DLog();
    UIEdgeInsets contentInsets          = UIEdgeInsetsZero;
    scrollView.contentInset             = contentInsets;
    scrollView.scrollIndicatorInsets    = contentInsets;
}

// =========================================================================================================
#pragma mark - Private class methods
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
+ (CGRect)getScreenBoundsForOrientation: (UIDeviceOrientation)orientation
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds; //implicitly in Portrait orientation.
    
    if (orientation == UIDeviceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight)
    {
        CGRect temp;
        temp.size.width     = fullScreenRect.size.height;
        temp.size.height    = fullScreenRect.size.width;
        fullScreenRect      = temp;
    }
    
    return fullScreenRect;
}

//----------------------------------------------------------------------------------------------------------
+ (void)globalResignFirstResponder
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    for (UIView * view in [window subviews]) {
        [self globalResignFirstResponderRecursively: view];
    }
}

//----------------------------------------------------------------------------------------------------------
+ (void)globalResignFirstResponderRecursively: (UIView*) view
{
    // Check to make sure the view can respond to resignFirstResponder
    if ([view respondsToSelector: @selector( resignFirstResponder)]) {
        [view resignFirstResponder];
    }
    for (UIView * subview in [view subviews]) {
        [self globalResignFirstResponderRecursively: subview];
    }
}

//----------------------------------------------------------------------------------------------------------
+ (BOOL)isValidEmailFormat: (NSString *)email
{
    DLog(/*@"checking %@", email*/);
    NSString *regEx = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate *emailMatcher = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regEx];
    
    return [emailMatcher evaluateWithObject: email];
}


@end
