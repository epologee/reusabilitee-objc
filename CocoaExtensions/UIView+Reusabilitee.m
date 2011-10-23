//
//  UIView+Reusabilitee.m
//  wowcal
//
//  Created by Eric-Paul Lecluse on 21-10-11.
//  Copyright (c) 2011 PINCH. All rights reserved.
//

#import "UIView+Reusabilitee.h"

@implementation UIView (Reusabilitee)

+ (UIView *)autoresizingViewWithFrame:(CGRect)frame
{
    UIView *view = [[[self alloc] initWithFrame:frame] autorelease];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return view;
}

@end
