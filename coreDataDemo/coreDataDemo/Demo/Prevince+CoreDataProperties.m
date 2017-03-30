//
//  Prevince+CoreDataProperties.m
//  coreDataDemo
//
//  Created by wangcyan on 16/12/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "Prevince+CoreDataProperties.h"

@implementation Prevince (CoreDataProperties)

+ (NSFetchRequest<Prevince *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Prevince"];
}

@dynamic code;
@dynamic name;
@dynamic city;

@end
