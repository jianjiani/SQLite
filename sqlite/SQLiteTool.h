//
//  SQLiteTool.h
//  sqlite
//
//  Created by 孙英建 on 2017/4/8.
//  Copyright © 2017年 孙英建. All rights reserved.
//

/*
 1、此类封装了使用FMDatabase实例操作sqlite数据库，实现数据库的增删改查功能。操作之前必须先打开数据库，操作之后记得将数据库关闭
 2、值得注意的是此方法如果多线程同时访问数据库的时候会出现crash。因为FMDatabase 这个类是线程不安全的，所以不能在多线程的环境中使用FMDatabase对数据库进行读写
 3、如果多线程同时访问的时候推荐参考此工程中的SQLiteQueueTool工具类
 */

#import <Foundation/Foundation.h>

@interface SQLiteTool : NSObject

/**
 *初始化单例工具类
 */
+ (instancetype)shareInstance;

/**
 *创建表
 */
- (BOOL)createTable;

/**
 *将字典中的用户信息插入到表中
 */
- (BOOL)inserUserInfoWithDict:(NSDictionary *)userDict;

/**
 *根据用户id查询用户信息
 */
- (NSMutableArray *)queryUserInfoWithUserid:(NSString *)userid;

/**
 *修改对应userid的用户信息
 */
- (BOOL)updateUserInfo:(NSDictionary *)userDict userid:(NSString *)userid;

/**
 *删除指定用户
 */
- (BOOL)deleteUserInfoWithId:(NSString *)userid;

@end








