//
//  City+CoreDataProperties.h
//  coreDataDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "City+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest;

@property (nonatomic) int64_t code;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) Prevince *prevince;
@property (nullable, nonatomic, retain) NSSet<District *> *district;

@end

@interface City (CoreDataGeneratedAccessors)

- (void)addDistrictObject:(District *)value;
- (void)removeDistrictObject:(District *)value;
- (void)addDistrict:(NSSet<District *> *)values;
- (void)removeDistrict:(NSSet<District *> *)values;

@end

NS_ASSUME_NONNULL_END
