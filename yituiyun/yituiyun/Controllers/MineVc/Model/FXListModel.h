//
//  FXListModel.h
//  yituiyun
//
//  Created by fx on 16/11/3.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

/***************************下拉列表的model **********************************/

@interface FXListModel : NSObject

/** id  */
@property (nonatomic, copy) NSString *linkID;
/** 内容  */
@property (nonatomic, copy) NSString *title;

@end
