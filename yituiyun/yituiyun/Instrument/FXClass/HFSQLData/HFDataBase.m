//
//  HFDataBase.m
//  ChangeClothes
//
//  Created by hslhzj@163.com on 15/8/24.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import "HFDataBase.h"

@implementation HFDataBase

static HFDataBase *single = nil;

+(id)sharInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/mydata.db"];
        single = [[HFDataBase alloc] initWithPath:path];
    });
    return single;
}

-(id)initWithPath:(NSString*)path{
    if (self = [super init]) {
        self.db = [[FMDatabase alloc] initWithPath:path];
    }
    return self;
}

-(BOOL)createNewTableWithTableName:(NSString *)tableName andColumn:(NSString*)column{
    
    NSMutableString* SQLStr = [NSMutableString stringWithFormat:@"create table if not exists %@(%@);",tableName,column];
    
    [self.db open];
    BOOL res = [self.db executeUpdate:SQLStr];
    [self.db close];
    
    return res;
}

//-(BOOL)insertWithTableName:(NSString*)tableName addColumn:(NSString*)column andValue:(NSArray*)values{
//    
//    
//}

-(NSArray*)selectFromeTableName:(NSString*)tableName andColumn:(NSString*)column andCondition:(NSArray*)conditions{
    //创建sql语句
    NSMutableString* SQLStr = [NSMutableString stringWithFormat:@"select %@ from %@",column,tableName];
    NSMutableArray* whereArr = [NSMutableArray new];
    //判断是否有条件
    if (conditions) {
        [SQLStr appendString:@" where "];
        //如果有循环拼接条件
        for (int i = 0; i < conditions.count; i++) {
            NSString* where = conditions[i];
            NSString* sign = @"=";
            NSRange range = [where rangeOfString:sign];
            if (range.length == 0) {
                sign = @"<";
                range = [where rangeOfString:sign];
                if (range.length == 0) {
                    sign = @">";
                    range = [where rangeOfString:sign];
                    if (range.length == 0) {
                        sign = @"<=";
                        range = [where rangeOfString:sign];
                        if (range.length == 0) {
                            sign = @">=";
                            range = [where rangeOfString:sign];
                            if (range.length == 0) {
                                return nil;
                            }
                        }
                    }
                }
            }
            NSString* whereLeft = [where substringToIndex:range.location];
            NSString* whereRight = [where substringFromIndex:range.location + range.length];
            [whereArr addObject:whereRight];
            if (i != conditions.count - 1) {
                [SQLStr appendFormat:@"%@%@? and ",whereLeft,sign];
            }else{
                [SQLStr appendFormat:@"%@%@?;",whereLeft,sign];
            }
        }
        
    }else{
        //如果没有直接给分号
        [SQLStr appendString:@";"];
    }
    //创建要返回的数据
    NSMutableArray* selectArr = [NSMutableArray new];
    NSArray* columnArr = [column componentsSeparatedByString:@","];
    //打开数据库
    [self.db open];
    //取出查询出来的结果
    FMResultSet* set = [_db executeQuery:SQLStr withArgumentsInArray:whereArr];
    //循环结果
    while ([set next]) {
        @autoreleasepool {
            //创建保存每条数据的字典
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            //循环每条 取出要查的数据
            for (NSString* tempStr in columnArr) {
                //得到这条数据
                NSString* myValue = [set stringForColumn:tempStr];
                //填入字典
                if (myValue) {
                   [dic setObject:myValue forKey:tempStr];
                }
            }
            //填入数组
            [selectArr addObject:dic];
        }
    }
    //关闭数据库
    [self.db close];
    //返回查出的数据
    return selectArr;
}

-(BOOL)upDataFromeTableName:(NSString *)tableName andColumn:(NSArray *)columnName andParameter:(NSArray *)parameter andCondition:(NSArray *)conditions{
    
    NSString* columnStr = [columnName componentsJoinedByString:@","];
    NSArray* dataArr = [[HFDataBase sharInstance] selectFromeTableName:tableName andColumn: columnStr andCondition:conditions];
    BOOL res;
    NSMutableString* SQLStr;
    NSMutableArray* whereArr;
    if (dataArr.count > 0) {
        //创建sql语句
        SQLStr = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",tableName];
        if (parameter) {
            whereArr = [NSMutableArray arrayWithArray:parameter];
        }else{
            return NO;
        }
        if (columnName) {
            for (int i = 0; i < columnName.count; i++) {
                NSString* str = columnName[i];
                if (i != columnName.count - 1) {
                    [SQLStr appendFormat:@"%@=?,",str];
                }else{
                    [SQLStr appendFormat:@"%@=? ",str];
                }
            }
        }else{
            return NO;
        }
        
        //判断是否有条件
        if (conditions) {
            [SQLStr appendString:@" WHERE "];
            //如果有循环拼接条件
            for (int i = 0; i < conditions.count; i++) {
                NSString* where = conditions[i];
                NSString* sign = @"=";
                NSRange range = [where rangeOfString:sign];
                if (range.length == 0) {
                    sign = @"<";
                    range = [where rangeOfString:sign];
                    if (range.length == 0) {
                        sign = @">";
                        range = [where rangeOfString:sign];
                        if (range.length == 0) {
                            sign = @"<=";
                            range = [where rangeOfString:sign];
                            if (range.length == 0) {
                                sign = @">=";
                                range = [where rangeOfString:sign];
                                if (range.length == 0) {
                                    return NO;
                                }
                            }
                        }
                    }
                }
                NSString* whereLeft = [where substringToIndex:range.location];
                NSString* whereRight = [where substringFromIndex:range.location + range.length];
                [whereArr addObject:whereRight];
                if (i != conditions.count - 1) {
                    [SQLStr appendFormat:@"%@%@? and ",whereLeft,sign];
                }else{
                    [SQLStr appendFormat:@"%@%@?;",whereLeft,sign];
                }
            }
            
        }else{
            //如果没有直接给分号
            [SQLStr appendString:@";"];
        }
    }else{
        SQLStr = [NSMutableString stringWithFormat:@"insert into %@(%@) values(",tableName,columnStr];
        whereArr = [NSMutableArray arrayWithArray:parameter];
        for (int i = 0 ; i < columnName.count; i++) {
            if (i != columnName.count - 1) {
                [SQLStr appendString:@"?,"];
            }else{
                [SQLStr appendString:@"?);"];
            }
        }
    }
    
    [self.db open];
    
    res = [_db executeUpdate:SQLStr withArgumentsInArray:whereArr];
    
    [self.db close];
    
    return res;
}

-(BOOL)deleteFromeTableName:(NSString*)tableName andCondition:(NSArray*)conditions{
    NSMutableString* SQLStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"delete from %@",tableName]];
    NSMutableArray* whereArr = [NSMutableArray new];
    //判断是否有条件
    if (conditions) {
        [SQLStr appendString:@" where "];
        //如果有循环拼接条件
        for (int i = 0; i < conditions.count; i++) {
            NSString* where = conditions[i];
            NSString* sign = @"=";
            NSRange range = [where rangeOfString:sign];
            if (range.length == 0) {
                sign = @"<";
                range = [where rangeOfString:sign];
                if (range.length == 0) {
                    sign = @">";
                    range = [where rangeOfString:sign];
                    if (range.length == 0) {
                        sign = @"<=";
                        range = [where rangeOfString:sign];
                        if (range.length == 0) {
                            sign = @">=";
                            range = [where rangeOfString:sign];
                            if (range.length == 0) {
                                return NO;
                            }
                        }
                    }
                }
            }
            NSString* whereLeft = [where substringToIndex:range.location];
            NSString* whereRight = [where substringFromIndex:range.location + range.length];
            [whereArr addObject:whereRight];
            if (i != conditions.count - 1) {
                [SQLStr appendFormat:@"%@%@? and ",whereLeft,sign];
            }else{
                [SQLStr appendFormat:@"%@%@?;",whereLeft,sign];
            }
        }
    }else{
        //如果没有直接给分号
        [SQLStr appendString:@";"];
    }

    [self.db open];

    BOOL res = [_db executeUpdate:SQLStr withArgumentsInArray:whereArr];

    [self.db close];

    return res;
}
@end
