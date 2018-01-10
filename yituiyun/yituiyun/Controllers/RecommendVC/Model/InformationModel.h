//
//  InformationModel.h
//  yituiyun
//
//  Created by 张强 on 15/11/20.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject

@property (nonatomic, copy) NSString *InfoId;//id
@property (nonatomic, copy) NSString *icon;//图片
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *desc;//描述
@property (nonatomic, copy) NSString *time;//时间
@property (nonatomic, copy) NSString *field;//1.内勤 2.外勤
@property (nonatomic, copy) NSString *isCoollection;//是否收藏
@property (nonatomic, copy) NSString *islink;//是否外链
@property (nonatomic, copy) NSString *url;//外链地址
@property (nonatomic, copy) NSString *jobDuration;//工作时长
@end
