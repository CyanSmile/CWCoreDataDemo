//
//  District+CoreDataProperties.h
//  coreDataDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "District+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface District (CoreDataProperties)

+ (NSFetchRequest<District *> *)fetchRequest;

@property (nonatomic) int64_t code;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) City *city;

@end

NS_ASSUME_NONNULL_END
