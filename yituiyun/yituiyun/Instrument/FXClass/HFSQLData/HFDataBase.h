//
//  HFDataBase.h
//  ChangeClothes
//
//  Created by hslhzj@163.com on 15/8/24.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface HFDataBase : NSObject

@property (nonatomic, strong) FMDatabase * db;

/*
 实例化数据库单例
 */
+(id)sharInstance;
/** 
 创建新表 参数 表名 列名数组
 列名示例:@"id,name"
 */
-(BOOL)createNewTableWithTableName:(NSString *)tableName andColumn:(NSString*)columnArr;
/** 
 查询信息 表名 列名 条件
 列名示例:@"id,name"
 条件示例:@[@"id=1",@"name=abc"]
 */
-(NSArray*)selectFromeTableName:(NSString*)tableName andColumn:(NSString*)columnArr andCondition:(NSArray*)conditions;
/**
 更新信息 表名 列名 更新的数据 条件
 列名示例:@[@"id",@"name"]
 更新数据示例:@[@"1",@"如果"]
 条件示例:@[@"id=1",@"name=abc"]
 */
-(BOOL)upDataFromeTableName:(NSString*)tableName andColumn:(NSArray*)columnEqualValue andParameter:(NSArray*)parameter andCondition:(NSArray*)conditions;
/** 
 删除信息 表名 条件 
 条件示例:@[@"id=1",@"name=abc"]
 */
-(BOOL)deleteFromeTableName:(NSString*)tableName andCondition:(NSArray*)conditions;

//添加新消息
//-(BOOL)executeUpdateAddNewMessage:(NSString*)columnStr;
//添加新BBS
//-(BOOL)executeUpdateAddCollectBBS:(NSString*)columnStr;
//添加新拼车
//-(BOOL)executeUpdateAddCollectFondCar:(NSString*)columnStr;
//添加新商品
//-(BOOL)executeUpdateAddCollectGood:(NSString*)columnStr;
//遍历查询
//-(NSArray*)executeQuerySelect:(NSString*)SQLStr whithColumn:(NSString*)columnStr;
//查询是否存在
//-(BOOL)executeQuerySelect:(NSString*)SQLStr whithStr:(NSString*)str;
//-(BOOL)executeQuerySelect:(NSString*)SQLStr whithWhere:(NSString*)whereStr whithStr:(NSString*)str;
//删除
//-(BOOL)executeUpdateDel:(NSString*)SQLStr;

@end

