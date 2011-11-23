// Copyright (c) 2008 Loren Brichter
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
//  ABTableViewCell.m
//
//  Created by Loren Brichter
//  Copyright 2008 Loren Brichter. All rights reserved.
//

#import "ABTableViewCell.h"

@implementation ABTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithCustomView:[[[ABTableViewCellView alloc] initWithFrame:CGRectZero] autorelease] reuseIdentifier:reuseIdentifier];
    return self;
}

- (id)initWithCustomView:(ABTableViewCellView *)customView reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self != nil) 
    {
		self.backgroundView = customView;
        self.contentMode = UIViewContentModeRedraw;
    }
	
    return self;
}


- (ABTableViewCellView *)customView
{
    return (ABTableViewCellView *)self.backgroundView;
}

- (void)setSelected:(BOOL)selected {
    [[self customView] setSelected:selected];

	if (selected != self.selected) {
		[self setNeedsDisplay];
	}
	
    [super setSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [[self customView] setSelected:selected];

	if (selected != self.selected) {
		[self setNeedsDisplay];
	}
	
	[super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted {
    [[self customView] setHighlighted:highlighted];

	if (highlighted != self.highlighted) {
		[self setNeedsDisplay];
	}
	
	[super setHighlighted:highlighted];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [[self customView] setHighlighted:highlighted];

	if (highlighted != self.highlighted) {
		[self setNeedsDisplay];
	}
	
	[super setHighlighted:highlighted animated:animated];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];

	[[self customView] setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
	[super setNeedsDisplayInRect:rect];
	[[self customView] setNeedsDisplayInRect:rect];
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
	self.contentView.hidden = YES;
	[self.contentView removeFromSuperview];
    
    self.selectedBackgroundView.hidden = YES;
	[self.selectedBackgroundView removeFromSuperview];
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted selected:(BOOL)selected 
{
	// subclasses should implement this
}

@end

@implementation ABTableViewCellView

@synthesize selected = selected_;
@synthesize highlighted = highlighted_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
	if(self) {
		self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.highlighted = NO;
        self.selected = NO;
	}
	
	return self;
}

- (void)setSelected:(BOOL)selected
{
    selected_ = selected;
}

- (void)setHighlighted:(BOOL)highlighted
{
    highlighted_ = highlighted;
}

- (void)drawRect:(CGRect)rect {
	[(ABTableViewCell *)[self superview] drawContentView:rect highlighted:self.highlighted selected:self.selected];
}

@end