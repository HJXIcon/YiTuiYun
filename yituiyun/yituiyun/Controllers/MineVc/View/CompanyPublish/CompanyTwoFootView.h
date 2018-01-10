//
//  CompanyTwoFootView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddBlock) ();
@interface CompanyTwoFootView : UIView

+(instancetype)footView;
@property(nonatomic,copy)AddBlock  add_block;
@end
