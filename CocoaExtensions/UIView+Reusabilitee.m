//
//  UIView+Reusabilitee.m
//  wowcal
//
//  Created by Eric-Paul Lecluse on 21-10-11.
//  Copyright (c) 2011 PINCH. All rights reserved.
//

#import "UIView+Reusabilitee.h"

@implementation UIView (Reusabilitee)

+ (id)autoresizingViewWithFrame:(CGRect)frame
{
    return [self viewWithFrame:frame autoresizing:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

+ (id)viewWithFrame:(CGRect)frame autoresizing:(UIViewAutoresizing)mask
{
    UIView *view = [[[self alloc] initWithFrame:frame] autorelease];
    view.autoresizingMask = mask;
    return view;
}

- (BOOL)pointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *subview in self.subviews) {
        CGPoint localPoint = point;
        localPoint.x -= subview.frame.origin.x;
        localPoint.y -= subview.frame.origin.y;
        
        if ([subview pointInside:localPoint withEvent:event])
        {
            return YES;
        }
    }
    
    return NO;
}

@end
