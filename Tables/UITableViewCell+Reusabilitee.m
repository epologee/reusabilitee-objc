//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "UITableViewCell+Reusabilitee.h"


@implementation UITableViewCell (Reusabilitee)

+ (id)createOrDequeueFromTable:(UITableView *)tableView
{
    return [self createOrDequeueFromTable:tableView withStyle:UITableViewCellStyleDefault];
}

+ (id)createOrDequeueFromTable:(UITableView *)tableView feedback:(BOOL *)created
{
    return [self createOrDequeueFromTable:tableView withStyle:UITableViewCellStyleDefault feedback:created];
}

+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style
{
    return [self createOrDequeueFromTable:tableView withStyle:style feedback:NULL];
}

+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style feedback:(BOOL *)created
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self description]];
    
    if (cell == nil)
    {
        if (created != NULL) *created = YES;
        cell = [[[self alloc] initWithStyle:style reuseIdentifier:[self description]] autorelease];
    } else {
        if (created != NULL) *created = NO;
    }
    
    return cell;
}

@end