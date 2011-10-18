//
//  FastCell.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "FastCell.h"

@interface ContentView : UIView
@end

@implementation ContentView

- (void)drawRect:(CGRect)r
{
	[(FastCell*)[self superview] drawContentView:r];
}

@end

@implementation FastCell

@synthesize backView=backView_;
@synthesize contentView=contentView_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self addSubview:self.backView];
		[self addSubview:self.contentView];
    }
    return self;
}

- (UIView *)backView
{
    if (backView_ == nil)
    {
        self.backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        backView_.opaque = YES;
    }
    
    return backView_;
}

- (UIView *)ivarContentView
{
    return contentView_;
}
- (UIView *)contentView
{
    if (contentView_ == nil)
    {
        self.contentView = [[[ContentView alloc] initWithFrame:CGRectZero] autorelease];
        contentView_.opaque = YES;
    }
    
    return contentView_;
}

- (void)dealloc {
	self.backView = nil;
    self.contentView = nil;

	[super dealloc];
}

- (void)setFrame:(CGRect)f {
	[super setFrame:f];
	CGRect b = [self bounds];
	b.size.height -= 1; // leave room for the seperator line
	
    [self.backView setFrame:b];
	[self.contentView setFrame:b];
    [self setNeedsDisplay];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
    [self.backView setNeedsDisplay];
	[self.contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r {
	// subclasses should implement this, unless they override the contentView getter with a custom subclass.
}

@end
