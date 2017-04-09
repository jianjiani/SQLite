//
//  SQLiteQueueTool.h
//  sqlite
//
//  Created by 孙英建 on 2017/4/8.
//  Copyright © 2017年 孙英建. All rights reserved.
//

/*
 1、此类封装了使用FMDatabaseQueue实例操作sqlite数据库，实现数据库的增删改查功能。
 2、FMDatabaseQueue是线程安全的，可以跨线程使用，使用FMDatabaseQueue操作数据库的时候，FMDatabase 会将块代码block运行在一个串行队列上，所以即使在多线程同时调用FMDatabaseQueue的方法，仍然还是顺序执行。
 3、如果是多线程访问数据库建议参考此类中的方法进行操作
 */

#import <Foundation/Foundation.h>

@interface SQLiteQueueTool : NSObject

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








