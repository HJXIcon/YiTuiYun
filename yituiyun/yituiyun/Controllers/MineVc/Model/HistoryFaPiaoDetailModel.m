//
//  HistoryFaPiaoDetailModel.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/25.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "HistoryFaPiaoDetailModel.h"

@implementation HistoryFaPiaoDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list" : [HistroyFapiaoDetailListModel class]
              };
}
@end
