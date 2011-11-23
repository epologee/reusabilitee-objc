//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "EESingleton.h"

@interface EEAbstractModel : EESingleton
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) NSManagedObjectContext *mainContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 For storage guidelines in the iCloud era, see: https://developer.apple.com/icloud/documentation/data-storage/
 */
@property (nonatomic, copy, readonly) NSString *documentsDirectory;
@property (nonatomic, copy, readonly) NSString *cachesDirectory;
@property (nonatomic, copy, readonly) NSURL *storeURL;
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSString *storeFileName;

/**
 Designated initializer. Call this one from your concrete `init` method.
 @param modelName is the name of your .momd file without the extension. Example: @"CDModel"
 @param storeFileName is the name of the SQLite backing store. It will be stored in the application documents directory. Example: @"CDStore.db"
 */
- (id)initWithModelName:(NSString *)modelName storeFileName:(NSString *)storeFileName;

/**
 Override and implement this method if you want to prevent your app from aborting when adding the store to the model doesn't work. 
 */
- (void)resolvePersistentStoreError:(NSError *)error forStoreURL:(NSURL *)storeURL;
- (NSManagedObjectContext *)newContext;
- (void)handleContextDidSave:(NSNotification *)saveNotification;
- (BOOL)purgePersistentStore;

@end

@interface NSManagedObjectContext (Concurrency)

- (NSArray *)existingObjectsWithIDs:(NSArray *)objectIDs;
- (NSArray *)existingObjectsWithIDs:(NSArray *)objectIDs error:(NSError **)error;

@end

@interface NSArray (KeyValueProgramming)

- (NSArray *)arrayFromObjectsAtKey:(NSString *)key;

@end