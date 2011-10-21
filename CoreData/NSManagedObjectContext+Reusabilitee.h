//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import <Foundation/Foundation.h>


@interface NSManagedObjectContext (Reusabilitee)

/**
 Saves the context and logs an error message when it fails.
 */
- (NSError *)simpleSave;

/**
 finds or creates a unique NSManagedObject for the given key/value pair.
 */
- (id)uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key;

/**
 find one existing entity for the given key/value pair
 */
- (id)existingEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key;

/**
 finds or creates a unique NSManagedObject for the given key/value pair and gives feedback on whether it existed or not
 */
- (id)uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key existed:(BOOL *)existed;

/**
 fetches all entities of a certain name with a simple sort option.
 */
- (NSArray *)allEntitiesNamed:(NSString *)entityName sortedByKey:(NSString *)sortKey ascending:(BOOL)ascending;

@end
