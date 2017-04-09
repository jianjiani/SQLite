//
//  SQLiteQueueTool.m
//  sqlite
//
//  Created by 孙英建 on 2017/4/8.
//  Copyright © 2017年 孙英建. All rights reserved.
//

#import "SQLiteQueueTool.h"
#import "FMDB.h"

@interface SQLiteQueueTool ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation SQLiteQueueTool

// 初始化单例工具类
+ (instancetype)shareInstance {
    static SQLiteQueueTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// 懒加载数据库队列
- (FMDatabaseQueue *)queue {
    if (_queue == nil) {
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userque.sqlite"];
        _queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    }
    return _queue;
}

// 创建表
- (BOOL)createTable{
    __block BOOL result;
    // 打开数据库，创建表
    [self.queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS userInfo(id integer PRIMARY KEY, userid text NOT NULL, name text NOT NULL, age integer, sex integer, height integer, weight integer);"];
    }];
    return result;
}

// 插入数据
- (BOOL)inserUserInfoWithDict:(NSDictionary *)userDict{
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdateWithFormat:@"INSERT INTO userInfo(userid,name,age,sex,height,weight) VALUES(%@,%@,%ld,%ld,%ld,%ld)",userDict[@"userid"], userDict[@"name"], [userDict[@"age"] integerValue], [userDict[@"sex"] integerValue], [userDict[@"height"] integerValue], [userDict[@"weight"] integerValue]];
    }];
    return result;
}

// 查询用户信息
- (NSMutableArray *)queryUserInfoWithUserid:(NSString *)userid{
    NSMutableArray *userArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQueryWithFormat:@"SELECT * FROM userInfo WHERE userid=%@", userid];
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"] ? : @"";
            NSInteger age = [resultSet intForColumn:@"age"];
            NSInteger sex = [resultSet intForColumn:@"sex"];
            NSInteger height = [resultSet intForColumn:@"height"];
            NSInteger weight = [resultSet intForColumn:@"weight"];
            NSDictionary *userDict = @{@"userid":userid, @"name":name, @"age":@(age), @"sex":@(sex), @"height":@(height), @"weight":@(weight)};
            [userArr addObject:userDict];
        }
    }];
    return userArr;
}

// 修改用户信息
- (BOOL)updateUserInfo:(NSDictionary *)userDict userid:(NSString *)userid{
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *name = userDict[@"name"] ? : @"";
        NSInteger age = [userDict[@"age"] integerValue];
        NSInteger sex = [userDict[@"sex"] integerValue];
        NSInteger height = [userDict[@"height"] integerValue];
        NSInteger weight = [userDict[@"weight"] integerValue];
        
        NSString *sq = [NSString stringWithFormat:@"UPDATE userInfo SET name='%@', age='%ld', sex='%ld', height='%ld', weight='%ld' WHERE userid='%@'", name, age, sex, height, weight, userid];
        result = [db executeUpdate:sq];
    }];
    return result;
}

// 删除用户信息
- (BOOL)deleteUserInfoWithId:(NSString *)userid{
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sq = [NSString stringWithFormat:@"delete from userInfo where userid='%@'",userid];
        result = [db executeUpdate:sq];
    }];
    return result;
}


@end









