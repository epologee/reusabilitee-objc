//
//  Created by Eric-Paul Lecluse @ 2011.
//

#import "EEAbstractModel.h"
#import <Foundation/Foundation.h>

@interface EEAbstractModel ()

@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSString *storeFileName;
@property (nonatomic, copy, readwrite) NSString *documentsDirectory;
@property (nonatomic, copy, readwrite) NSString *cachesDirectory;

@end

@implementation EEAbstractModel

@synthesize modelName = modelName_;
@synthesize storeFileName = storeFileName_;
@synthesize mainContext = mainContext_;
@synthesize managedObjectModel = managedObjectModel_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;
@synthesize documentsDirectory = documentsDirectory_;
@synthesize cachesDirectory = cachesDirectory_;

- (id)initWithModelName:(NSString *)modelName storeFileName:(NSString *)storeFileName
{
    self = [super init];
    
    if (self) {
        self.modelName = modelName;
        self.storeFileName = storeFileName;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    
    return self;
}

- (NSURL *)storeURL
{
    return [NSURL fileURLWithPath:[[self documentsDirectory] stringByAppendingPathComponent:self.storeFileName]];
}

- (NSString *)documentsDirectory
{
    if (documentsDirectory_ == nil)
    {
        self.documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
    
	return documentsDirectory_;
}

- (NSString *)cachesDirectory
{
    if (cachesDirectory_ == nil)
    {
        self.cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    
	return cachesDirectory_;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.modelName = nil;
    self.storeFileName = nil;
    self.mainContext = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
    self.documentsDirectory = nil;
    self.cachesDirectory = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Core Data Stack

- (void)resolvePersistentStoreError:(NSError *)error forStoreURL:(NSURL *)storeURL
{
    if (error.code == NSPersistentStoreIncompatibleVersionHashError) 
    {
        DLog(@"The database is incompatible with the model");
    } 
    else 
    {
        DLog(@"Unresolved error attaching the SQLite store to the coordinator, bailing out: %@", error);
    }    

    abort();
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{
    if (persistentStoreCoordinator_ == nil) {
        
        NSError *error = nil;
        NSInteger attempts = 3;
        persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, 
                                 nil];
        
        NSURL *storeURL = self.storeURL;
        while (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error] && --attempts >= 0) {
            [self resolvePersistentStoreError:error forStoreURL:storeURL];
        }
    }
    
    return persistentStoreCoordinator_;
}

- (NSManagedObjectModel *)managedObjectModel 
{
    if (managedObjectModel_ == nil) 
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
        managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    }
    
    return managedObjectModel_;
}

- (NSManagedObjectContext *)newContext 
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    return context;
}

- (NSManagedObjectContext *)mainContext 
{
    if (mainContext_ == nil) {
        self.mainContext = [[self newContext] autorelease];
    }
    
    return mainContext_;
}

- (void)handleContextDidSave:(NSNotification *)saveNotification
{
    // The saveNotification's userInfo dictionary contains three possible keys:
    //
    //  + deleted
    //  + inserted
    //  + updated
    //
    //    DLog(@"Changes: %@", saveNotification.userInfo);
    [self.mainContext mergeChangesFromContextDidSaveNotification:saveNotification];
}

#pragma mark -
#pragma mark File storage

- (BOOL)purgePersistentStore
{
    NSAssert(persistentStoreCoordinator_ == nil, @"In order to purge the persistent store, make sure its coordinator is not yet created.");
    NSError *error = nil;
    BOOL removed = [[NSFileManager defaultManager] removeItemAtURL:self.storeURL error:&error];

    if (removed)
    {
        DLog(@"Removed store at url %@", self.storeURL);
    }
    else
    {
        ELog(@"Could not delete store at url %@ due to: %@", self.storeURL, error);
    }
    
    return removed;
}

@end

@implementation NSManagedObjectContext (Concurrency)

- (NSArray *)existingObjectsWithIDs:(NSArray *)objectIDs
{
    NSError *error = nil;
    NSArray *objects = [self existingObjectsWithIDs:objectIDs error:&error];
    if (objects == nil)
    {
        ELog(@"Could not get all existing objects: %@", error);
    }
    
    return objects;
}

- (NSArray *)existingObjectsWithIDs:(NSArray *)objectIDs error:(NSError **)error
{
    NSMutableArray *entities = [NSMutableArray array];

    @try {
        for (NSManagedObjectID *objectID in objectIDs) {
            // existingObjectWithID might return nil if it can't find the objectID, but if you're not prepared for this,
            // don't use this method but write your own. 
            [entities addObject:[self existingObjectWithID:objectID error:error]];
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    return entities;
}

@end

@implementation NSArray (KeyValueProgramming)

- (NSArray *)arrayFromObjectsAtKey:(NSString *)key
{
    NSMutableArray *objectsAtKey = [NSMutableArray array];
    for (id value in self) {
        [objectsAtKey addObject:[value valueForKey:key]];
    }
    return objectsAtKey;
}

@end