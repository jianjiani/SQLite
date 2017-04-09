//
//  SQLiteTool.m
//  sqlite
//
//  Created by 孙英建 on 2017/4/8.
//  Copyright © 2017年 孙英建. All rights reserved.
//

#import "SQLiteTool.h"
#import "FMDB.h"

@interface SQLiteTool ()

@property (strong, nonatomic) FMDatabase *db;

@end

@implementation SQLiteTool

// 初始化方法
+ (instancetype)shareInstance {
    static SQLiteTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

// 懒加载创建数据库实例
- (FMDatabase *)db{
    if (!_db) {
        // 获取数据库创建路径
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.sqlite"];
        // 创建数据库
        _db = [FMDatabase databaseWithPath:filePath];
    }
    return _db;
}

// 创建表
- (BOOL)createTable{
    BOOL result;
    // 打开数据库，创建表
    if ([self.db open]) {
        result = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS userInfo(id integer PRIMARY KEY, userid text NOT NULL, name text NOT NULL, age integer, sex integer, height integer, weight integer);"];
    }
    return result;
}

// 插入数据
- (BOOL)inserUserInfoWithDict:(NSDictionary *)userDict{
    BOOL result;
    if ([self.db open]) {
        result = [self.db executeUpdateWithFormat:@"INSERT INTO userInfo(userid,name,age,sex,height,weight) VALUES(%@,%@,%ld,%ld,%ld,%ld)",userDict[@"userid"], userDict[@"name"], [userDict[@"age"] integerValue], [userDict[@"sex"] integerValue], [userDict[@"height"] integerValue], [userDict[@"weight"] integerValue]];
    }
    [self.db close];
    return result;
}

// 查询用户信息
- (NSMutableArray *)queryUserInfoWithUserid:(NSString *)userid{
    NSMutableArray *userArr = [NSMutableArray array];
    if ([self.db open]) {
        FMResultSet *resultSet = [self.db executeQueryWithFormat:@"SELECT * FROM userInfo WHERE userid=%@", userid];
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"] ? : @"";
            NSInteger age = [resultSet intForColumn:@"age"];
            NSInteger sex = [resultSet intForColumn:@"sex"];
            NSInteger height = [resultSet intForColumn:@"height"];
            NSInteger weight = [resultSet intForColumn:@"weight"];
            NSDictionary *userDict = @{@"userid":userid, @"name":name, @"age":@(age), @"sex":@(sex), @"height":@(height), @"weight":@(weight)};
            [userArr addObject:userDict];
        }
    }
    [self.db close];
    return userArr;
}

// 修改用户信息
- (BOOL)updateUserInfo:(NSDictionary *)userDict userid:(NSString *)userid{
    BOOL result;
    NSString *name = userDict[@"name"] ? : @"";
    NSInteger age = [userDict[@"age"] integerValue];
    NSInteger sex = [userDict[@"sex"] integerValue];
    NSInteger height = [userDict[@"height"] integerValue];
    NSInteger weight = [userDict[@"weight"] integerValue];
    if ([self.db open]) {
        NSString *sq = [NSString stringWithFormat:@"UPDATE userInfo SET name='%@', age='%ld', sex='%ld', height='%ld', weight='%ld' WHERE userid='%@'", name, age, sex, height, weight, userid];
        result = [self.db executeUpdate:sq];
    }
    [self.db close];
    return result;
}

// 删除用户信息
- (BOOL)deleteUserInfoWithId:(NSString *)userid{
    BOOL result;
    if ([self.db open]) {
        NSString *sq = [NSString stringWithFormat:@"delete from userInfo where userid='%@'",userid];
        result = [self.db executeUpdate:sq];
    }
    [self.db close];
    return result;
}

@end














