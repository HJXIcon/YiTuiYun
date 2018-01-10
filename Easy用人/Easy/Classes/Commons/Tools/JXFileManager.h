//
//  JXFileManager.h
//  FishingWorld
//
//  Created by mac on 17/2/23.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#define JXCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
/*
 作用：处理文件尺寸
 */
@interface JXFileManager : NSObject

// 文档注释
/**
 *  指定一个文件夹路径，就获取文件夹尺寸
 *
 *  @param directoryPath 文件夹全路径
 *
 *  @return 文件夹尺寸
 */
+ (NSInteger)getSizeOfDirectoryPath:(NSString *)directoryPath;

/**
 *  指定一个文件夹路径，删除
 *
 *  @param directoryPath 文件夹全路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;

@end
