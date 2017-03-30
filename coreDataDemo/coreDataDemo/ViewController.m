//
//  ViewController.m
//  coreDataDemo
//
//  Created by wangcyan on 16/12/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

/* 相关文章http://www.cocoachina.com/ios/20160802/17260.html*/

/*
 * NSManagedObjectContext : 托管对象上下文，进行数据操作时大多都是和这个类打交道。
 * NSManagedObjectModel : 托管对象模型，一个托管对象模型关联一个模型文件(.xcdatamodeld)，存储着数据库的数据结构
 * NSPersistentStoreCoordinator : 持久化存储协调器，负责协调存储区和上下文之间的关系。
 * NSManagedObject : 托管对象类，所有CoreData中的托管对象都必须继承自当前类，根据实体创建托管对象类文件。
 */

#import "ViewController.h"
#import "District+CoreDataClass.h"
#import "City+CoreDataClass.h"
#import "Prevince+CoreDataClass.h"

@interface ViewController ()
{
    NSManagedObjectContext *_context;
    NSManagedObjectModel *_model;
    NSPersistentStoreCoordinator *_coordinator;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#pragma mark -- 1、模型文件操作
    /*
     *1.1 创建模型文件，后缀名为.xcdatamodeld。创建模型文件之后，可以在其内部进行添加实体等操作(用于表示数据库文件的数据结构)
     *1.2 添加实体(表示数据库文件中的表结构)，添加实体后需要通过实体，来创建托管对象类文件。
     *1.3 添加属性并设置类型，可以在属性的右侧面板中设置默认值等选项。(每种数据类型设置选项是不同的)
     *1.4 创建获取请求模板、设置配置模板等。
     *1.5 根据指定实体，创建托管对象类文件(基于NSManagedObject的类文件)
     */
#pragma mark -- 2、实例化上下文对象
    //2.1创建托管对象上下文(NSManagedObjectContext)，并发队列设置为主队列
    /*
     * NSConfinementConcurrencyType 如果使用init方法初始化上下文，默认就是这个并发类型。在iOS9之后已经被苹果废弃，不建议用这个API，调用某些比较新的CoreData的API可能会导致崩溃。
     * NSPrivateQueueConcurrencyType 私有并发队列类型，操作都是在子线程中完成的。
     * NSMainQueueConcurrencyType 主并发队列类型，如果涉及到UI相关的操作，应该考虑使用这个参数初始化上下文。
     */
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //2.2创建托管对象模型(NSManagedObjectModel)，并使用china.json路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"China" withExtension:@"momd"];
    _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    
    //2.3根据托管对象模型(NSPersistentStoreCoordinator)，创建持久化存储调度器
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    
    //2.4创建并关联本地(SQLite)数据库文件，并返回持久化存储对象(NSPersistentStore)，如果已存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"China"];
    /*
     * NSSQLiteStoreType : SQLite数据库
     * NSXMLStoreType : XML文件
     * NSBinaryStoreType : 二进制文件
     * NSInMemoryStoreType : 直接存储在内存中
     */
    [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
    
    //2.5将持久化存储协调器赋值给托管对象上下文，完成基本创建。
    _context.persistentStoreCoordinator = _coordinator;
    
    [self saveData];
    [self queryEntityWithName:@"Prevince"];
}

- (void)saveData {
    
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"china" ofType:@"json"];
    NSData *dataJson = [NSData dataWithContentsOfFile:dataPath options:NSDataReadingMappedIfSafe error:nil];
    
    NSMutableArray *proviceArr = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *previceDict in proviceArr) {
        // 创建托管对象，并指明创建的托管对象所属实体名
        Prevince *prevince = [NSEntityDescription insertNewObjectForEntityForName:@"Prevince" inManagedObjectContext:_context];
        prevince.code = [previceDict[@"code"] integerValue];
        prevince.name = previceDict[@"name"];
        NSMutableArray *cityArr = [NSMutableArray arrayWithArray:previceDict[@"cell"]];
        for (NSDictionary *cityDict in cityArr) {
            City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:_context];
            city.code = [cityDict[@"code"] integerValue];
            city.name = cityDict[@"name"];
            NSMutableArray *districtArr = [NSMutableArray arrayWithArray:cityDict[@"cell"]];
            for (NSDictionary *districtDict in districtArr) {
                District *district = [NSEntityDescription insertNewObjectForEntityForName:@"District" inManagedObjectContext:_context];
                district.code = [districtDict[@"code"] integerValue];
                district.name = districtDict[@"name"];
                [city addDistrictObject:district];
            }
            [prevince addCityObject:city];
        }
    }
    // 通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (_context.hasChanges) {
        [_context save:&error];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }
}

- (void)deleteEntityWithName:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    
    // 建立获取数据的请求对象，指明对entityName实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象NSPredicate,
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"lxz"];
    request.predicate = predicate;
    // 执行获取操作，找到要删除的对象
    NSError *error = nil;
    NSArray *entityNames = [_context executeFetchRequest:request error:&error];
    // 遍历符合删除要求的对象数组，执行删除操作
    
    [entityNames enumerateObjectsUsingBlock:^(NSManagedObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_context deleteObject:obj];
    }];
    // 保存上下文
    if (_context.hasChanges) {
        [_context save:nil];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Delete Data Error : %@", error);
    }
}

- (void)updateEntityWithName:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    
    // 建立获取数据的请求对象，指明对entityName实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象NSPredicate,
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"lxz"];
    request.predicate = predicate;
    // 执行获取操作，找到要删除的对象
    NSError *error = nil;
    NSArray *entityNames = [_context executeFetchRequest:request error:&error];
    // 遍历符合删除要求的对象数组，执行删除操作
    
    [entityNames enumerateObjectsUsingBlock:^(NSManagedObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //更新obj的属相值
    }];
//    [entityNames enumerateObjectsUsingBlock:^(District * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        //更新obj的属相值
//        obj.code = 1234567890;
//    }];
    // 保存上下文
    if (_context.hasChanges) {
        [_context save:nil];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Delete Data Error : %@", error);
    }
}

- (void)queryEntityWithName:(NSString *)entityName {
    // 建立获取数据的请求对象，指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    // 执行获取操作，获取所有Employee托管对象
    NSError *error = nil;
    NSArray *employees = [_context executeFetchRequest:request error:&error];
    [employees enumerateObjectsUsingBlock:^(NSManagedObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
//    [employees enumerateObjectsUsingBlock:^(District * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"code == %lld, name == %@", obj.code, obj.name);
//    }];
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
