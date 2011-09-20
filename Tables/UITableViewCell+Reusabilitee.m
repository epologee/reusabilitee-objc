//
//  UITableViewCell+Convenience.m
//
//  Created by Eric-Paul Lecluse on 19-06-11.
//  Copyright 2011 epologee. All rights reserved.
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