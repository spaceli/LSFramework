//
//  NSManagedObjectAdditions.h
//  CostNote
//
//  Created by 李 帅 on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface NSManagedObject (Additions)


+ (NSString *)entityName;

- (id)initWithoutSave;
- (void)insert;

//插入
+ (id)insertObject;
+ (void)saveContext;

//查询
+ (id)objectWithKey:(NSString *)key value:(id)value;
+ (NSArray *)objectsWithKey:(NSString *)key value:(id)value;
+ (NSArray *)allObjects;

//删除
- (void)deleteFromDatabase;
+ (void)deleteAllFromDatabase;

//basic
+ (NSArray *)objectsWithPredicte:(NSPredicate *)predicate;
+ (NSArray *)objectsWithFetchRequest:(NSFetchRequest *)fetchRequest;
+ (id)objectWithFetchRequest:(NSFetchRequest *)fetchRequest;

+ (NSEntityDescription *)entity;
+ (NSFetchRequest *)fetchRequest;
+ (NSManagedObjectContext *)managedObjectContext;

@end





@interface LSDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,copy)NSString *CoreDataName;//CoreData文件名,须在info.plist里增加一项：CoreDataName. 默认取项目名称

+ (LSDataManager *)sharedManager;

+ (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

@interface UIDevice (CoreDataName)
+ (NSString *)coredataName;
@end