//
//  Prevince+CoreDataProperties.h
//  coreDataDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "Prevince+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Prevince (CoreDataProperties)

+ (NSFetchRequest<Prevince *> *)fetchRequest;

@property (nonatomic) int64_t code;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<City *> *city;

@end

@interface Prevince (CoreDataGeneratedAccessors)

- (void)addCityObject:(City *)value;
- (void)removeCityObject:(City *)value;
- (void)addCity:(NSSet<City *> *)values;
- (void)removeCity:(NSSet<City *> *)values;

@end

NS_ASSUME_NONNULL_END
