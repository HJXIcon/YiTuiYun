//
//  HFGetTag.h
//  EasyRepair
//
//  Created by joyman04 on 16/2/16.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GetTagUrl [kHost stringByAppendingString:@"api.php?m=linkage.get"]

typedef NS_ENUM(NSInteger,HFGetTagStyle) {
    OnleOnce = 0,//只获取一次
    EveryReload,//每次获取每次刷新,但读取到直接显示
    EveryGet,//每次从服务器获取
};

@interface HFGetTag : NSObject

+ (void)getTagWithKeyId:(nullable NSString *)keyId
               parentId:(nullable NSString *)parentId
                getType:(HFGetTagStyle)style
                success:(nullable void (^)(NSArray* _Nullable responseObject))success;

@end
