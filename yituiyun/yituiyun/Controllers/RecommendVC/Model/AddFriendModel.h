//
//  AddFriendModel.h
//  yituiyun
//
//  Created by 张强 on 2017/1/13.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddFriendModel : NSObject
@property (nonatomic, copy) NSString *uid;//id
@property (nonatomic, copy) NSString *nickname;//标题
@property (nonatomic, copy) NSString *avatar;//图片
@property (nonatomic, copy) NSString *desc;//描述
@property (nonatomic, copy) NSString *sex;//男女
@property (nonatomic, copy) NSString *industry;//类别
@property (nonatomic, copy) NSString *distance;//距离
@end
