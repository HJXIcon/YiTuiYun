//
//  HFTagModel.h
//  EasyRepair
//
//  Created by joyman04 on 16/1/16.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFTagModel : NSObject
/** 类型0系统标签 1自己添加的 */
@property (nonatomic,copy) NSString* type;
/** 标签id */
@property (nonatomic,copy) NSString* tagId;
/** 标签名 */
@property (nonatomic,copy) NSString* title;
/** 是否选中 */
@property (nonatomic,copy) NSString* isSelct;

@end
