//
//  UIView+Reusabilitee.h
//  wowcal
//
//  Created by Eric-Paul Lecluse on 21-10-11.
//

#import <UIKit/UIKit.h>

@interface UIView (Reusabilitee)

+ (id)autoresizingViewWithFrame:(CGRect)frame;

+ (id)viewWithFrame:(CGRect)frame autoresizing:(UIViewAutoresizing)mask;

/**
 Use this method inside a UIView's `pointInside:withEvent:` method to determine
 whether the point clicked belongs to any of the subviews, instead of merely hittesting
 the superview's frame.
 */
- (BOOL)pointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event;

@end
