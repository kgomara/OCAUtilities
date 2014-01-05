//
//  OCAUtilities.h
//  OCAUtilities
//
//  Created by Kevin O'Mara on 12/30/13.
//  Copyright (c) 2012-2013 O'Mara Consulting Associates. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


#ifndef OCAGlobalMacros_h           // Namespace guard

#define OCAGlobalMacros_h

// =========================================================================================================
#pragma mark - Logging Macros
// =========================================================================================================

/*
 * Modified from this stackoverflow: http://stackoverflow.com/questions/969130/how-to-print-out-the-method-name-and-line-number-and-conditionally-disable-nslog
 */

/**
 Logging macros. The are 3 versions - DLog, ALog, and ELog with the first letter signifying
 Debug only, Always log, and Error (specifically NSError).
 
 All the log macros display class, method, and line. This can result in "wide" messages,
 but I find knowing the exact method and line number invaluable. If at all possible, get
 a 24" monitor - definitely worth the money.
 
 Usage:
 DLog() - I tend to pepper my code heavily with DLog's - for example, I start almost every method
 with DLog(), sometimes displaying the method's signature parameters. That has the advantage
 of leaving a detailed breadcrumb trail, but the disadvantage of filling the console with messages
 you may not be interested in at the moment. It works for me, but everybody has their own logging
 style.
 
 The key thing with DLog() is those messages are NOT compiled into your shipping product. That's
 important because NSLog writes to the console (on disk) which is an expensive operation from both
 a performance and power consumption perspective. You can use DLog() liberally and not worry about
 impacting your customer's experience.
 
 ALog() - These log messages will remain in your shipping product (the Release schemes have
 DEBUG undefined). I use these for non-NSError error conditions that I hope never occur in a shipping
 product - but if they do occur I want to know about it. For example, I use ALog in didReceiveMemoryWarning,
 and in switch statements that have a case for each expected input, my default is typically:
 default: {
 ALog(@"Unexpected foo=%@", bar);
 break;
 }
 
 ELog() - These are specifically designed to handle NSError objects. These messages also remain in your
 shipping product by default. I find it extraordinarly handy to see the exact method and line displayed
 with the rest of the NSError information.
 */

//----------------------------------------------------------------------------------------------------------
#ifdef DEBUG
#   define DLog(_fmt, ...) NSLog((@"%s [Line %d] " _fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// ALog always display output regardless of the DEBUG setting.
//----------------------------------------------------------------------------------------------------------
#define ALog(_fmt, ...) NSLog((@"%s [Line %d] " _fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// ELog always displays output regardless of the DEBUG setting.
// Elog accepts an NSError object and logs the detailed information. This may seem redundant
// for many system errors, but the macro will display the Class, method name, and line number.
//----------------------------------------------------------------------------------------------------------
#define ELog(_error, _fmt, ...)                                                                                             \
do {                                                                                                                        \
    NSLog(@"%s [Line %d] [Error %@] " _fmt, __PRETTY_FUNCTION__, __LINE__,  [_error localizedDescription], ##__VA_ARGS__);  \
    NSArray* detailedErrors = [[_error userInfo] objectForKey:NSDetailedErrorsKey];                                         \
    if (detailedErrors != nil && [detailedErrors count] > 0) {                                                              \
        for (NSError* detailedError in detailedErrors) {                                                                    \
            NSLog(@"  DetailedError: %@", [detailedError userInfo]);                                                        \
        }                                                                                                                   \
    }                                                                                                                       \
    else {                                                                                                                  \
        NSLog(@"  %@", [_error userInfo]);                                                                                  \
    }                                                                                                                       \
} while(0)

// =========================================================================================================
#pragma mark - Miscellaneous macros
// =========================================================================================================

/**
 isEmpty is used to determine if an object is "empty". Depending on the context, you might have an NSString variable that
 can be “nil” when not set in one place OR an empty string in another. Sometimes either nil or empty strings are acceptable
 “NULL” values.
 */
//----------------------------------------------------------------------------------------------------------
static inline BOOL isEmpty(id anObject) {
    return anObject == nil                                                                      ||
        [anObject isKindOfClass:[NSNull class]]                                                 ||
        ([anObject respondsToSelector:@selector(length)] && [(NSData *)anObject length] == 0)   ||
        ([anObject respondsToSelector:@selector(count)]  && [(NSArray *)anObject count] == 0);
}


/**
 RGB color from hex  - e.g., 0xffffff, macro
 */
//----------------------------------------------------------------------------------------------------------
#define UIColorFromRGB(rgbValue) [UIColor                   \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0   \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0             \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/*
 RGB color from hex  - e.g., 0xffffff, macro with alpha
 */
//----------------------------------------------------------------------------------------------------------
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor        \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0   \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0             \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#endif

// =========================================================================================================
#pragma mark - General Utilities
// =========================================================================================================


/**
 General utility routines
 
 Most of the methods are Category Extensions.
 
 For convenience, this header also includes 3 macros that "extend" NSLog.
 
 They all use other Cocoa macros to display method names and line numbers on NSLog statements.
 
 - DLog is useful for general Debugging. For release builds they compile out.
 - ALog is similar to DLog, but they Always Log.
 - ELog is a special version that knows how to parse an NSError (to a limited extent). Like ALog, they Always Log.
 
 */
@interface OCAUtilities : NSObject

/**
 Display an alert message to the user
 @param theMessage The message to display
 @param theType Alert type to display (typically, Information, Warning, Error)
 */
//----------------------------------------------------------------------------------------------------------
+ (void)showAlertWithMessageAndType:(NSString*)theMessage
                          alertType:(NSString*)theType;

/**
 Display an alert message to the user indicating Error
 @param theMessage The message to display
 */
//----------------------------------------------------------------------------------------------------------
+ (void)showErrorWithMessage:(NSString*)theMessage;

/**
 Display an alert message for the user indicating Warning
 @param theMessage The message to display
 */
//----------------------------------------------------------------------------------------------------------
+ (void)showWarningWithMessage:(NSString*)theMessage;

/**
 Dismisses the Keyboard
 Calls resignFirstResponder (safely) on the UIView and all its subViews recursively.
 
 Performance is linear with respect to the number of subViews. Do not use this method
 if the number of subViews may be large.
 */
//----------------------------------------------------------------------------------------------------------
+ (void)dismissKeyboard;

/**
 Offsets a UITextField or UITextView if hidden when the keyboard is shown
 
 This routine follows Apple's recommendations here:
 http://developer.apple.com/library/ios/#DOCUMENTATION/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
 
 There are several steps to use this routine but the pattern is simple enough:
 
 1. Register (and remove) yourself for keyboard notifications - recommended to do this in viewWillAppear and viewWillDisappear
 2. If you have multiple UITextFields and/or UITextViews, keep track of which is "active" - typically a global updated in textFieldDidBeginEditing. Note that UITextView seems to get its notification after textViewDidBeginEditing, so figure out a way to deal with that.
 3. Invoke this method in your keyboardWasShown delegate. See the note about converting to the scrollView's coordinate system.
 4. Invoke resetTextField:inScrollView in your keyboardWillHide delegate
 
 NOTE - if the textField/View is in a subview of the scrollView, you'll need to translate it's coordinates into the scrollView's. For example:
 
 `CGRect fieldRect = [self convertRect: activeField.frame
 toView: scrollView];
 CGPoint scrollOffset = [OCAUtilities offsetTextField: fieldRect
 inScrollViews: scrollView
 withNotification: myKeyboardNotification];`
 
 
 @param fieldRect        The CGRect of UITextField or UITextView to expose, in the scrollView's coordinate system.
 @param scrollView       The UIScrollView containing the activeField
 @param aNotification    The NSNotification object
 */
//----------------------------------------------------------------------------------------------------------
+ (void)offsetTextField: (CGRect)fieldRect
           inScrollView: (UIScrollView *)scrollView
       withNotification: (NSNotification *)aNotification;

/**
 Resets a UITextField or UITextView to its original position after editing (using keyboard)
 
 see offsetTextField:inScrollView:withNotification for more information
 
 @param activeField      The UITextField or UITextView to expose
 @param scrollView       The UIScrollView containing the activeField
 */
//----------------------------------------------------------------------------------------------------------
+ (void)resetTextField: (UIView *)activeField
          inScrollView: (UIScrollView *)scrollView;

/**
 Gets screen bounds allowing for device orientation
 
 UIScreen bounds are always in Portrait mode. This routine swaps H + W if Landscape.
 @return Oriented CGRect
 */
//----------------------------------------------------------------------------------------------------------
+ (CGRect)getScreenBoundsForCurrentOrientation;

/**
 Examines the string to determine if it is formatted like an email address - e.g., name@domain
 @param email The string to validate
 @return YES if the string appears to be formatted correctly, NO otherwise
 */
//----------------------------------------------------------------------------------------------------------
+ (BOOL)isValidEmailFormat: (NSString *)email;

@end

// =========================================================================================================
#pragma mark - Convenience categories for NSDate
// =========================================================================================================

@interface NSDate (OCAUtilities)

/**
 Returns the localized date formatted as requested
 @param dateStyle Desired date style for the returned string
 @param timeStyle Desired time style for the returned string
 @return Date formatted per the requested style
 */
//----------------------------------------------------------------------------------------------------------
- (NSString *)dateStringWithDateStyle: (NSDateFormatterStyle)dateStyle
                         andTimeStyle: (NSDateFormatterStyle)timeStyle;

/**
 Returns a localized formatted string of the time difference to secondDate
 
 The string will show "a few seconds ago", minutes, hours, or days appropriately
 @param secondDate the later date
 @return formatted string representing the time difference between the two dates
 */
//----------------------------------------------------------------------------------------------------------
- (NSString *)formattedTimeToDate: (NSDate *)secondDate;

/**
 Returns the current date and time in GMT
 
 @return NSDate representing the current GMT
 */
//----------------------------------------------------------------------------------------------------------
+ (NSDate *)currentGMTDate;

@end


// =========================================================================================================
#pragma mark - Convenience methods add to UIView
// =========================================================================================================

@interface UIView (OCAUtilities)

/**
 Fades a UIView into visibility
 @param subView UIView to appear
 */
//----------------------------------------------------------------------------------------------------------
- (void)fadeSubViewIn:(UIView*)subView;

/**
 Fades a UIView out of visibility
 @param subView UIView to disappear
 */
//----------------------------------------------------------------------------------------------------------
- (void)fadeSubViewOut:(UIView*)subView;

/** Centers a view inside a containing UIView
 @param containingView the UIView in which to center this view
 */
//----------------------------------------------------------------------------------------------------------
- (void)centerInView: (UIView *)containingView;

/**
 Finds the parent view controller
 @return the parent view controller if successful, nil otherwise
 */
//----------------------------------------------------------------------------------------------------------
- (UIViewController *) containingViewController;

/**
 Traverses the Responder chain looking for UIViewControllers
 @return A UIViewController if successful, nil otherwise
 */
//----------------------------------------------------------------------------------------------------------
- (id) traverseResponderChainForUIViewController;

@end


// =========================================================================================================
#pragma mark - Convenience Categories added to NSString
// =========================================================================================================

@interface NSString (OCAUtilities)

/**
 Creates a 32-digit hex-value of a NSString
 @return MD5 hash of the string
 */
//----------------------------------------------------------------------------------------------------------
- (NSString *)MD5Hash;

/**
 Validates RFC3339 Date String
 Ambiously named. Make more robust as issues are identified
 @return an validated RFC3339 date if successful, nil otherwise
 */
- (NSString *)getRFC3339String;

@end

// =========================================================================================================
#pragma mark - Drawing Utilities
// =========================================================================================================

#ifndef OCADRAWINGUTILITIES
#define OCADRAWINGUTILITIES

///-----------------------------------
/// @name Degree and Radian Conversion
///-----------------------------------

/**
 A macro that converts a number from degress to radians.
 
 @param d number in degrees
 @return The number converted to radians.
 */
//----------------------------------------------------------------------------------------------------------
#define DEGREES_TO_RADIANS(d) ((d) * 0.0174532925199432958f)

/**
 A macro that converts a number from radians to degrees.
 
 @param r number in radians
 @return The number converted to degrees.
 */
//----------------------------------------------------------------------------------------------------------
#define RADIANS_TO_DEGREES(r) ((r) * 57.29577951308232f)

#endif

/**
 Limits a float to the `min` or `max` value. The float is between `min` and `max` it will be returned unchanged.
 
 @param f The float to limit.
 @param min The minumum value for the float.
 @param max The minumum value for the float.
 @return A float limited to the `min` or `max` value.
 */
//----------------------------------------------------------------------------------------------------------
extern CGFloat OCAFLimit(CGFloat f, CGFloat min, CGFloat max);


///-----------------------------
/// @name Rectangle Manipulation
///-----------------------------

//----------------------------------------------------------------------------------------------------------
extern CGRect CGRectSetX(CGRect rect, CGFloat x);
extern CGRect CGRectSetY(CGRect rect, CGFloat y);
extern CGRect CGRectSetWidth(CGRect rect, CGFloat width);
extern CGRect CGRectSetHeight(CGRect rect, CGFloat height);
extern CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);
extern CGRect CGRectSetSize(CGRect rect, CGSize size);
extern CGRect CGRectSetZeroOrigin(CGRect rect);
extern CGRect CGRectSetZeroSize(CGRect rect);
extern CGSize CGSizeAspectScaleToSize(CGSize size, CGSize toSize);
extern CGRect CGRectAddPoint(CGRect rect, CGPoint point);


///---------------------------------
/// @name Drawing Rounded Rectangles
///---------------------------------

//----------------------------------------------------------------------------------------------------------
extern void OCADrawRoundedRect(CGContextRef context, CGRect rect, CGFloat cornerRadius);


///-------------------------
/// @name Creating Gradients
///-------------------------

//----------------------------------------------------------------------------------------------------------
extern CGGradientRef OCACreateGradientWithColors(NSArray *colors);
extern CGGradientRef OCACreateGradientWithColorsAndLocations(NSArray *colors, NSArray *locations);


///------------------------
/// @name Drawing Gradients
///------------------------

//----------------------------------------------------------------------------------------------------------
extern void OCADrawGradientInRect(CGContextRef context, CGGradientRef gradient, CGRect rect);

// =========================================================================================================
#pragma mark - Convenience Categories added to UILabel
// =========================================================================================================

@interface UILabel (OCAUtilities)

/**
 Sizes a UILabel to fit a desired width
 
 Side-Effects:
 Sets lineBreakMode to UILineBreakModeWordWrap
 Sets numberOfLines to 0
 
 @param fixedWidth Desired width
 */
//----------------------------------------------------------------------------------------------------------
- (void)sizeToFitFixedWidth:(NSInteger)fixedWidth;

/**
 Text Style to use with UITextKit dynamic fonts
 */
- (NSString *)OCATextStyle;

@end


// =========================================================================================================
#pragma mark - Simple UITextField subclass to adds text insets.
// =========================================================================================================

@interface OCATextField : UITextField

///------------------------------------
/// @name Accessing the Text Attributes
///------------------------------------

/**
 The color of the placeholder text.
 
 This property applies to the entire placeholder text string. The default value for this property is set by the system.
 Setting this property to `nil` will use the system placeholder text color.
 
 The default value is `nil`.
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;


///------------------------------
/// @name Drawing and Positioning
///------------------------------

/**
 The inset or outset margins for the edges of the text content drawing rectangle.
 
 Use this property to resize and reposition the effective drawing rectangle for the text content. You can specify a
 different value for each of the four insets (top, left, bottom, right). A positive value shrinks, or insets, that
 edge—moving it closer to the center of the button. A negative value expands, or outsets, that edge. Use the
 `UIEdgeInsetsMake` function to construct a value for this property.
 
 The default value is `UIEdgeInsetsZero`.
 */
@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;

/**
 The inset or outset margins for the edges of the clear button drawing rectangle.
 
 Use this property to resize and reposition the effective drawing rectangle for the clear button content. You can
 specify a different value for each of the four insets (top, left, bottom, right), but only the top and right insets are
 respected. A positive value will move the clear button farther away from the top right corner. Use the
 `UIEdgeInsetsMake` function to construct a value for this property.
 
 The default value is `UIEdgeInsetsZero`.
 */
@property (nonatomic, assign) UIEdgeInsets clearButtonEdgeInsets;

@end

// =========================================================================================================
#pragma mark - Convenience methods added to UIToolbar
// =========================================================================================================

@interface UIToolbar (OCAUtilities)

@end

/**
 Sub-class of UIToolbar to allow transparency
 */
@interface TransparentToolBar : UIToolbar

/**
 Override's UITToolbar drawRect to not draw anything
 @param rect Rect to draw
 */
//----------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect;

@end


// =========================================================================================================
#pragma mark - Convenience Categories added to UIImage
// =========================================================================================================

@interface UIImage (OCAUtilities)

/**
 Make an image from a UIView
 @param view UIView to image
 @return Image if successful, nil otherwise
 */
//----------------------------------------------------------------------------------------------------------
+ (UIImage*)imageFromView: (UIView*)view;

/**
 Make an image from a UIView, scaled to a CGSize
 @param view UIView to image
 @param newSize Desired new size
 @return Scaled image if successful, nil otherwise
 */
//----------------------------------------------------------------------------------------------------------
+ (UIImage*)imageFromView: (UIView*)view
             scaledToSize: (CGSize)newSize;

/**
 Re-size a UIImage
 @param image UIImage to re-size
 @param newSize Desired new size
 @return Scaled image if successful, nil otherwise
 */
//----------------------------------------------------------------------------------------------------------
+ (UIImage*)imageWithImage: (UIImage*)image
              scaledToSize: (CGSize)newSize;

@end


// =========================================================================================================
#pragma mark - Convenience methods add to UIViewController
// =========================================================================================================

#define kSemiModalAnimationDuration   0.5

@interface UIViewController (OCAUtilities)

/**
 Presents a UIViewController with a kick-back animation
 @param vc UIViewController to animate
 */
//----------------------------------------------------------------------------------------------------------
-(void)presentSemiViewController: (UIViewController*)vc;

/**
 Presents a UIView with a kick-back animation
 @param vc UIViewController to animate
 */
//----------------------------------------------------------------------------------------------------------
-(void)presentSemiView: (UIView*)vc;

/**
 Dissmisses a SemiModalView
 */
//----------------------------------------------------------------------------------------------------------
-(void)dismissSemiModalView;

@end

@interface UIStoryboard (OCAUtilities)

+ (UIStoryboard *)main_iPhoneStoryboard;
+ (UIStoryboard *)main_iPadStoryboard;

@end

/*
 These categories are taken from the TextKitDemo code provided by Apple
 and are covered by their license agreement, which follows:
 
 File: UIFont+TextKitDemo.h
 Abstract:
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 */

@interface UIFont (OCAUtilities)

+ (UIFont *)OCAPreferredFontWithTextStyle: (NSString *)aTextStyle
                                    scale: (CGFloat)aScale;

- (NSString *)OCATextStyle;

- (UIFont *)OCAFontWithScale:(CGFloat)fontScale;

@end

@interface UIFontDescriptor (OCAUtilities)

+ (UIFontDescriptor *)OCAPreferredFontDescriptorWithTextStyle: (NSString *)aTextStyle
                                                        scale: (CGFloat)aScale;

- (NSString *)OCATextStyle;

- (UIFontDescriptor *)OCAFontDescriptorWithScale: (CGFloat)aScale;

@end

@interface UITextView (OCAUtilities)

- (NSString *)OCATextStyle;

@end


@interface UITextField (OCAExtensions)

- (NSString *)OCATextStyle;

@end


/*
 End of TextKitDemo code from Apple
 */


