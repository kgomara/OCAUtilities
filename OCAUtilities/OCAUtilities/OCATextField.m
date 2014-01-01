//
//  OCATextField.m
//  OCAToolkit
//
//  Created by Sam Soffes on 3/11/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import "OCAUtilities.h"

@interface OCATextField ()

- (void)_initialize;

@end

@implementation OCATextField

// =========================================================================================================
#pragma mark - Accessors
// =========================================================================================================

@synthesize textEdgeInsets          = _textEdgeInsets;
@synthesize clearButtonEdgeInsets   = _clearButtonEdgeInsets;
@synthesize placeholderTextColor    = _placeholderTextColor;

//----------------------------------------------------------------------------------------------------------
- (void)setPlaceholderTextColor: (UIColor *)placeholderTextColor
{
	_placeholderTextColor = placeholderTextColor;
	
	if (!self.text && self.placeholder) {
		[self setNeedsDisplay];
	}
}


// =========================================================================================================
#pragma mark - UIView
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
- (id)initWithCoder: (NSCoder *)aDecoder
{
    if ((self = [super initWithCoder: aDecoder])) {
        [self _initialize];
    }
    return self;
}


//----------------------------------------------------------------------------------------------------------
- (id)initWithFrame: (CGRect)frame
{
    if ((self = [super initWithFrame: frame])) {
        [self _initialize];
    }
    return self;
}


// =========================================================================================================
#pragma mark - UITextField
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
- (CGRect)textRectForBounds: (CGRect)bounds
{
	return UIEdgeInsetsInsetRect( [super textRectForBounds: bounds], _textEdgeInsets);
}


//----------------------------------------------------------------------------------------------------------
- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return [self textRectForBounds: bounds];
}


//----------------------------------------------------------------------------------------------------------
- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
	CGRect rect = [super clearButtonRectForBounds: bounds];
	rect        = CGRectSetY( rect, rect.origin.y + _clearButtonEdgeInsets.top);
    
	return CGRectSetX( rect, rect.origin.x + _clearButtonEdgeInsets.right);
}


//----------------------------------------------------------------------------------------------------------
- (void)drawPlaceholderInRect: (CGRect)rect
{
	if (!_placeholderTextColor) {
		[super drawPlaceholderInRect: rect];
        
		return;
	}
	
    [_placeholderTextColor setFill];
    
    // Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // ...set line break mode
    paragraphStyle.lineBreakMode            = NSLineBreakByTruncatingTail;
    // ...and text alignment
    paragraphStyle.alignment                = self.textAlignment;
    
    NSDictionary *attributes = @{ NSFontAttributeName: self.font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    [self.placeholder drawInRect:rect
                  withAttributes:attributes];
}


// =========================================================================================================
#pragma mark - Private
// =========================================================================================================

//----------------------------------------------------------------------------------------------------------
- (void)_initialize
{
	_textEdgeInsets         = UIEdgeInsetsZero;
	_clearButtonEdgeInsets  = UIEdgeInsetsZero;
}

@end
