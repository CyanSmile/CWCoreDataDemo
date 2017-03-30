//
//  City+CoreDataProperties.m
//  coreDataDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "City+CoreDataProperties.h"

@implementation City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"City"];
}

@dynamic code;
@dynamic name;
@dynamic prevince;
@dynamic district;

@end
