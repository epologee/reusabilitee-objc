//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import <Foundation/Foundation.h>

/**
 To take care of the everlasting dequeue or create problem when retrieving cells in a UITableView,
 this category provides some convenience methods on any UITableViewCell.
 */
@interface UITableViewCell (Reusabilitee)

/**
 Shorter version of `createOrDequeueFromTable:withStyle:feedback:`, if you don't need any specifics.
 */
+ (id)createOrDequeueFromTable:(UITableView *)tableView;

/**
 Shorter version of `createOrDequeueFromTable:withStyle:feedback:`, if you want to know if the cell was dequeued or created.
 */
+ (id)createOrDequeueFromTable:(UITableView *)tableView feedback:(BOOL *)created;

/**
 Shorter version of `createOrDequeueFromTable:withStyle:feedback:`, without the feedback pointer.
 */
+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style;

/**
 This is the mother of the other category methods.
 
 @param tableView provide the table view to dequeue a cell from
 @param style provide the style to use when creating new cells
 @param feedback pointer for later reference. This value will receive YES when the cell was newly created, and NO when it was dequeued.
 */
+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style feedback:(BOOL *)created;

@end
