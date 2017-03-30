//
//  District+CoreDataProperties.m
//  coreDataDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "District+CoreDataProperties.h"

@implementation District (CoreDataProperties)

+ (NSFetchRequest<District *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"District"];
}

@dynamic code;
@dynamic name;
@dynamic city;

@end
