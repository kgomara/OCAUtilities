//
//  UIImage+OCAUtilities.m
//  OCAUtilities
//
//  Created by KEVIN OMARA on 6/16/12.
//  Copyright (c) 2012-2013 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAUtilities.h"

@implementation UIImage (OCAUtilities)

// =========================================================================================================
#pragma mark - Public class methods
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
+ (UIImage*)imageFromView: (UIView*)view
{
    DLog();
    [self beginImageContextWithSize: [view bounds].size];
    
    // Save the view's current Hidden state
    BOOL hidden = [view isHidden];
    // ...and make sure it's visible (can't image if hidden)
    [view setHidden: NO];
    // render the view into an image
    [[view layer] renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [self endImageContext];
    // Restore Hidden state
    [view setHidden: hidden];
    
    return image;
}

//----------------------------------------------------------------------------------------------------------
+ (UIImage*)imageFromView: (UIView*)view
             scaledToSize: (CGSize)newSize
{
    DLog();
    // Get the image at its natural size
    UIImage *image = [self imageFromView: view];
    if ([view bounds].size.width  != newSize.width ||
        [view bounds].size.height != newSize.height) {
        // ...scale if the desired size is different
        image = [self imageWithImage: image 
                        scaledToSize: newSize];
    }
    
    return image;
}

//----------------------------------------------------------------------------------------------------------
+ (UIImage*)imageWithImage: (UIImage*)image
              scaledToSize: (CGSize)newSize
{
    DLog(/*@"newSize=%f, %f", newSize.width, newSize.height*/);
    [self beginImageContextWithSize: newSize];
    // Draw the image at the desired size
    [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    [self endImageContext];
    
    return newImage;
}

// =========================================================================================================
#pragma mark - Private class methods
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
+ (void)beginImageContextWithSize: (CGSize)size
{
    DLog();
    // Determine if the device is Hi-res
    if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            // ...and scale accordingly
            UIGraphicsBeginImageContextWithOptions(size, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
}

//----------------------------------------------------------------------------------------------------------
+ (void)endImageContext
{
    UIGraphicsEndImageContext();
}

@end
