//
//  JXPopModel.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/10/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXPopModel : NSObject

/** image*/
@property (nonatomic, strong) NSString *image;
/** title*/
@property (nonatomic, strong) NSString *title;

/** 是否选中*/
@property (nonatomic, assign) BOOL isSelect;

@end
