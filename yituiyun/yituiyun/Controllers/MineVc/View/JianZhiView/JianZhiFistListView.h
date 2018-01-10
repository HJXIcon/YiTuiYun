//
//  JianZhiFistListView.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/1.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ListReturnBlock)(NSString *str,NSInteger index);

@interface JianZhiFistListView : UIView
+(instancetype)listView;
-(instancetype)initWithRect:(CGRect)rect andDatas:(NSArray *)array;
@property(nonatomic,copy)ListReturnBlock  listreturnblock;
@end
