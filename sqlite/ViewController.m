//
//  ViewController.m
//  sqlite
//
//  Created by 孙英建 on 2017/4/8.
//  Copyright © 2017年 孙英建. All rights reserved.
//

#import "ViewController.h"
#import "SQLiteTool.h"
#import "SQLiteQueueTool.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *userInfoArr;

@end

@implementation ViewController

#pragma mark - 懒加载数据数组

- (NSMutableArray *)userInfoArr{
    if (!_userInfoArr) {
        _userInfoArr = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            NSDictionary *userDict = @{@"userid":[NSString stringWithFormat:@"%d",i+10001], @"name":[NSString stringWithFormat:@"王%d",i+1], @"age":@(21+i), @"sex":@(i%2), @"height":@(171+i), @"weight":@(71+i)};
            [_userInfoArr addObject:userDict];
        }
    }
    return _userInfoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

#pragma mark - 使用FMDatabase的数据库相关操作

// 插入
- (void)insertBtnAction{
    for (NSDictionary *dict in self.userInfoArr) {
        [[SQLiteTool shareInstance] inserUserInfoWithDict:dict];
    }
}

// 查询
- (void)queryBtnBtnAction{
    NSMutableArray *userArr = [[SQLiteTool shareInstance] queryUserInfoWithUserid:[NSString stringWithFormat:@"%d",10004]];
    NSLog(@"%@",userArr);
}

// 更新
- (void)updateBtnAction{
    NSDictionary *userDict = @{@"userid":[NSString stringWithFormat:@"%d",10008], @"name":@"嘿嘿嘿", @"age":@(88), @"sex":@(3), @"height":@(160), @"weight":@(50)};
    BOOL result = [[SQLiteTool shareInstance] updateUserInfo:userDict userid:[NSString stringWithFormat:@"%d",10008]];
    if (result) {
        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败");
    }
}

// 删除
- (void)deleteBtnAction{
    BOOL result = [[SQLiteTool shareInstance]deleteUserInfoWithId:[NSString stringWithFormat:@"10008"]];
    if (result) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

#pragma mark - 使用FMDatabaseQueue的数据库相关操作

// 插入
- (void)insertBtnTwoAction{
    for (NSDictionary *dict in self.userInfoArr) {
        [[SQLiteQueueTool shareInstance] inserUserInfoWithDict:dict];
    }
}

// 查询
- (void)queryBtnTwoBtnAction{
    NSMutableArray *userArr = [[SQLiteQueueTool shareInstance] queryUserInfoWithUserid:[NSString stringWithFormat:@"%d",10005]];
    NSLog(@"%@",userArr);
}

// 更新
- (void)updateBtnTwoAction{
    NSDictionary *userDict = @{@"userid":[NSString stringWithFormat:@"%d",10008], @"name":@"嘿嘿嘿", @"age":@(88), @"sex":@(3), @"height":@(160), @"weight":@(50)};
    BOOL result = [[SQLiteQueueTool shareInstance] updateUserInfo:userDict userid:[NSString stringWithFormat:@"%d",10008]];
    if (result) {
        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败");
    }
}

// 删除
- (void)deleteBtnTwoAction{
    BOOL result = [[SQLiteQueueTool shareInstance]deleteUserInfoWithId:[NSString stringWithFormat:@"10008"]];
    if (result) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

#pragma mark - 界面

- (void)configureUI{
    UIButton *insertBtn = [self creatBtnWithFrame:CGRectMake(20, 60, 80, 30) Title:@"插入数据"];
    [self.view addSubview:insertBtn];
    [insertBtn addTarget:self action:@selector(insertBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *insertBtnTwo = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(insertBtn.frame)+30, 60, 90, 30) Title:@"插入数据2"];
    [self.view addSubview:insertBtnTwo];
    [insertBtnTwo addTarget:self action:@selector(insertBtnTwoAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *queryBtn = [self creatBtnWithFrame:CGRectMake(20, 100, 80, 20) Title:@"查询数据"];
    [self.view addSubview:queryBtn];
    [queryBtn addTarget:self action:@selector(queryBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *queryBtnTwo = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(insertBtn.frame)+30, 100, 90, 20) Title:@"查询数据2"];
    [self.view addSubview:queryBtnTwo];
    [queryBtnTwo addTarget:self action:@selector(queryBtnTwoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *updateBtn = [self creatBtnWithFrame:CGRectMake(20, 140, 80, 20) Title:@"更新数据"];
    [self.view addSubview:updateBtn];
    [updateBtn addTarget:self action:@selector(updateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *updateBtnTwo = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(insertBtn.frame)+30, 140, 90, 20) Title:@"更新数据2"];
    [self.view addSubview:updateBtnTwo];
    [updateBtnTwo addTarget:self action:@selector(updateBtnTwoAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *deleteBtn = [self creatBtnWithFrame:CGRectMake(20, 180, 80, 20) Title:@"删除数据"];
    [self.view addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *deleteBtnTwo = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(insertBtn.frame)+30, 180, 90, 20) Title:@"删除数据2"];
    [self.view addSubview:deleteBtnTwo];
    [deleteBtnTwo addTarget:self action:@selector(deleteBtnTwoAction) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)creatBtnWithFrame:(CGRect)frame Title:(NSString *)title{
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    return btn;
}

@end








