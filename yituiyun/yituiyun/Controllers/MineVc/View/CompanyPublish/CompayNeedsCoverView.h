//
//  CompayNeedsCoverView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompayNeedsCoverView;

@protocol CompayNeedsCoverViewDelegate <NSObject>

-(void)compayNeedsCoverViewBtnClick:(CompayNeedsCoverView *)compayCoverView;
-(void)compayNeedsCoverViewJianZhiBtnClick:(CompayNeedsCoverView *)compayCoverView;


@end

@interface CompayNeedsCoverView : UIView
+(instancetype)coverView;
@property(nonatomic,weak)id<CompayNeedsCoverViewDelegate>  delegate;
@end
