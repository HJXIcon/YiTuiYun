//
//  ImageVo.h
//  社区快线
//
//  Created by 张强 on 15/11/20.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageVo : NSObject

@property (nonatomic, copy) NSString *cover;//图片
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *desc;//描述
@property (nonatomic, copy) NSString *link;//链接 type = 1 时的外链地址
@property (nonatomic, copy) NSString *type;//类型 0无跳转 1外链 2商品详情 3资讯详情
@property (nonatomic, copy) NSString *dataid;//数据ID type=2:商品id;type=3:资师id
@end
