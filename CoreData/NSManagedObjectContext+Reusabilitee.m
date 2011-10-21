//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "NSManagedObjectContext+Reusabilitee.h"

@implementation NSManagedObjectContext (Reusabilitee)

- (NSError *)simpleSave
{
    NSError *error = nil;

    if ([self save:&error]) {
        DLog(@"Context saved.");
        return nil;
    }

    ELog(@"Error saving context due to %i: \"%@\" with user info: %@", error.code, [error.userInfo objectForKey:NSLocalizedDescriptionKey], error.userInfo);
    return error;
}

- (id)uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key 
{
    BOOL existed = NO;
    NSManagedObject* result = [self uniqueEntityForName:name withValue:value forKey:key existed:&existed];
    return result;
}

- (id)uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key existed:(BOOL *)existed
{
    NSManagedObject *entity = [self existingEntityForName:name withValue:value forKey:key];
    
    if (entity == nil) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
        [entity setValue:value forKey:key];
        *existed = NO;
    } else {
        *existed = YES;
    }
    
    return entity;
}

- (id)existingEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key 
{
    if (value == nil || [@"" isEqualToString:[value description]]) 
	{
        return nil;
    }
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];    
    request.entity = [NSEntityDescription entityForName:name inManagedObjectContext:self];
    request.predicate = [NSPredicate predicateWithFormat:[key stringByAppendingString:@" == %@"], value];
    request.fetchLimit = 1;
    NSArray *result = [self executeFetchRequest:request error:nil];
    
    return [result lastObject];
}

- (NSArray *)allEntitiesNamed:(NSString *)entityName sortedByKey:(NSString *)sortKey ascending:(BOOL)ascending
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [request setEntity:entity];
    
    NSSortDescriptor *sortByKey = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByKey]];
    
    NSError *error = nil;
    NSArray *result = [self executeFetchRequest:request error:&error];
    
    [request release];
    
    if (result == nil) {
        DLog(@"Failed to fetch entities named '%@' due to: %@", entityName, error);
    }
    
    return result;
}

@end
