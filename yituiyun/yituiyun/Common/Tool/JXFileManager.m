//
//  JXFileManager.m
//  FishingWorld
//
//  Created by mac on 17/2/23.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import "JXFileManager.h"


@implementation JXFileManager

+ (void)removeDirectoryPath:(NSString *)directoryPath
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 判断是否传入进来 是不是文件夹路径
    // 判断是否是文件夹
    BOOL isDirectory = NO;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        // 直接报错
        // name:异常名字
        // reason:异常原因
        NSException *exception = [NSException exceptionWithName:@"FileError" reason:@"笨蛋，传错了路径，只能传文件夹路径，并且要存在" userInfo:nil];
        
        [exception raise];
    }
    
    // 获取文件夹里面所有子文件,只能获取下一级
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        [mgr removeItemAtPath:filePath error:nil];
    }
}
// 指定一个文件夹路径，就获取文件夹尺寸
+ (NSInteger)getSizeOfDirectoryPath:(NSString *)directoryPath
{
    // 1.获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 判断是否传入进来 是不是文件夹路径
    // 判断是否是文件夹
    BOOL isDirectory = NO;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        // 直接报错
        // name:异常名字
        // reason:异常原因
        NSException *exception = [NSException exceptionWithName:@"FileError" reason:@"笨蛋，传错了路径，只能传文件夹路径，并且要存在" userInfo:nil];
        
        [exception raise];
    }
    
    // 3.获取文件夹里面所有文件全路径
    // subpathsAtPath:获取文件夹里面所有子路径,把所有子级目录全部获取
    NSArray *subpaths = [mgr subpathsAtPath:directoryPath];
    NSInteger totalSize = 0;
    for (NSString *subPath in subpaths) {
        // 获取文件全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        // 如果是隐藏文件 或者 文件夹 不需要计算 优化
        if ([filePath containsString:@".DS"]) continue;
        
        // 判断是否是文件夹
        BOOL isDirectory = NO;
        BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        if (!isExist || isDirectory) continue;
        
        // 获取文件尺寸
        NSInteger fileSize = [[mgr attributesOfItemAtPath:filePath error:nil] fileSize];
        totalSize += fileSize;
        
    }
    
    return totalSize;
    
    
    // 1.NSFileManager
    // 2.获取文件夹里面所有文件 全路径
    // 3.获取文件属性 attributesOfItemAtPath
    // 3.1 指定一个路径，就能获取到这个路径的文件属性
    // 3.2 只能获取文件的尺寸 不能获取文件夹尺寸
    // 4.把所有的文件的尺寸 累加 变成 文件夹尺寸
}




@end
