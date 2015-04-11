//
//  NSManagedObjectAdditions.m
//  CostNote
//
//  Created by 李 帅 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectAdditions.h"

@implementation NSManagedObject (Additions)

- (id)initWithoutSave {
    NSManagedObjectContext *managedContext = [NSManagedObject managedObjectContext];
    return [self initWithEntity:[NSEntityDescription entityForName:[self.class entityName] inManagedObjectContext:managedContext]
 insertIntoManagedObjectContext:nil];
}
- (void)insert {
    NSManagedObjectContext *managedContext = [NSManagedObject managedObjectContext];
    [managedContext insertObject:self];
}

//插入
+ (id)insertObject {
    NSManagedObjectContext *managedContext = [self managedObjectContext];
	id object = [[self alloc] initWithEntity:[self entity] insertIntoManagedObjectContext:managedContext];
	return object;
}
+ (void)saveContext {
    [LSDataManager saveContext];
}

//查询
+ (id)objectWithKey:(NSString *)key value:(id)value {
    NSFetchRequest *request = [self fetchRequest];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", key, value]];
    return [self objectWithFetchRequest:request];
}
+ (NSArray *)objectsWithKey:(NSString *)key value:(id)value {
    NSFetchRequest *request = [self fetchRequest];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", key, value]];
    return [self objectsWithFetchRequest:request];
}
+ (NSArray *)allObjects {
    NSFetchRequest *request = [self fetchRequest];
    request.fetchBatchSize = 20;
    return [self objectsWithFetchRequest:request];
}

//删除
- (void)deleteFromDatabase {
    [self.managedObjectContext deleteObject:self];
    [NSManagedObject saveContext];
}
+ (void)deleteAllFromDatabase {
    NSArray *allObjects = [self allObjects];
    for (NSManagedObject *object in allObjects) {
        [object deleteFromDatabase];
    }
}

//basic
+ (NSArray *)objectsWithPredicte:(NSPredicate *)predicate {
    NSFetchRequest *request = [self fetchRequest];
    request.predicate = predicate;
    request.fetchBatchSize = 20;
    return [self objectsWithFetchRequest:request];
}
+ (NSArray *)objectsWithFetchRequest:(NSFetchRequest *)fetchRequest {
	NSError* error;
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    NSArray *fetchResults = [managedContext executeFetchRequest:fetchRequest error:&error];
	return fetchResults;
}
+ (id)objectWithFetchRequest:(NSFetchRequest *)fetchRequest {
	[fetchRequest setFetchLimit:1];
	NSArray *objects = [self objectsWithFetchRequest:fetchRequest];
	if ([objects count] == 1) {
		return [objects objectAtIndex:0];
	} 
    return nil;
}


+ (NSEntityDescription *)entity {
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:managedContext];
	return entity;
}
+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}
+ (NSFetchRequest *)fetchRequest {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[self entity]];
	return fetchRequest;
}
+ (NSManagedObjectContext *)managedObjectContext {
    return [LSDataManager sharedManager].managedObjectContext;
}
@end





@interface LSDataManager ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation LSDataManager

static LSDataManager *instance = nil;

+ (LSDataManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LSDataManager alloc] init];
        instance.CoreDataName = [UIDevice coredataName];
    });
    return instance;
}

+ (void)saveContext
{
    if (![[self sharedManager].managedObjectContext save:NULL]) {
        
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil)
        {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator)
    {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",self.CoreDataName]];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil)
    {
        NSString *name = [NSString stringWithFormat:@"%@",self.CoreDataName];
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end


@implementation UIDevice (CoreDataName)
+ (NSString *)coredataName {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    if (info[@"CoreDataName"]) {
        return info[@"CoreDataName"];
    }
    return info[@"CFBundleName"];
}

@end
