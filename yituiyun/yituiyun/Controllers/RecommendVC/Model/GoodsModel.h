//
//  GoodsModel.h
//  yituiyun
//
//  Created by 张强 on 15/11/20.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsId;//id
@property (nonatomic, copy) NSString *icon;//图片
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *price;//现价格
@property (nonatomic, copy) NSString *originalPrice;//旧价格
@property (nonatomic, copy) NSString *nums;//预定数
@property (nonatomic, copy) NSString *isCollection;//是否收藏
@property (nonatomic, copy) NSString *link;//详情地址
@property (nonatomic, copy) NSString *isStatus;//是否上架 1上架 2下架
@property (nonatomic, copy) NSString *isAppointment;//是否预约
@property (nonatomic, copy) NSString *phone;//商家电话
@property (nonatomic, strong) NSMutableArray *imageArray;//图片集合
@end
