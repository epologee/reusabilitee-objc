//
//  Created by Eric-Paul Lecluse on 18-11-11.
//

#import "EEGridViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WOWDesignKit.h"

@interface  EEGridViewCell  ()

@property (nonatomic, copy, readwrite) NSString *reuseIdentifier;

@end

@implementation EEGridViewCell

@synthesize reuseIdentifier = reuseIdentifier_;
@synthesize selected = selected_;
@synthesize highlighted = highlighted_;
@synthesize gridPosition = gridPosition_;
@synthesize delegate = delegate_;

+ (id)createOrDequeueFromGridView:(EEGridView *)gridView withFeedback:(BOOL *)created
{
    UITableViewCell *cell = [gridView dequeueReusableCellWithIdentifier:[self description]];
    
    if (cell == nil)
    {
        if (created != NULL) *created = YES;
        cell = [[[self alloc] initWithReuseIdentifier:[self description]] autorelease];
    } else {
        if (created != NULL) *created = NO;
    }
    
    return cell;
}

- (void)dealloc {
    self.reuseIdentifier = nil;
    self.gridPosition = nil;
    
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = YES;
    }
    
    return self;
}

- (void)prepareForReuse
{
    selected_ = NO;
    highlighted_ = NO;
    self.gridPosition = nil;
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    selected_ = selected;
    
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    highlighted_ = highlighted;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self drawRect:rect selected:selected_ highlighted:highlighted_];
}

- (void)drawRect:(CGRect)rect selected:(BOOL)selected highlighted:(BOOL)highlighted
{
    [[[UIColor blueColor] colorWithAlphaComponent:0.5 + (selected ? 0.3 : 0) + (highlighted ? 0.2 : 0)] setFill];
    [[[UIColor blueColor] colorWithAlphaComponent:0.9] setStroke];
    
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
    CGContextStrokeRect(UIGraphicsGetCurrentContext(), rect);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.highlighted = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.highlighted = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.highlighted = NO;
    if (self.selected)
    {
        [self.delegate didSelectGridViewCell:self];
    }
    else
    {
        [self.delegate didSelectGridViewCell:self];
    }
}

@end
