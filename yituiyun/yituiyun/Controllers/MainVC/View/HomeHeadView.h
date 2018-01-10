//
//  HomeHeadView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/5.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHKLeftButoon.h"


@protocol HomeHeadViewDelegate <NSObject>

-(void)headViewcityBtnClick:(UIButton *)btn;

-(void)headViewSoSouBtnClick:(UIButton *)btn;

-(void)headViewCollectionViewClick:(NSDictionary *)dict;

@end


@interface HomeHeadView : UIView


@property (weak, nonatomic) IBOutlet UIView *picturepanView;



@property (weak, nonatomic) IBOutlet LHKLeftButoon *citySlectBtn;
@property(nonatomic,assign)id<HomeHeadViewDelegate>  delegate;


+(instancetype)headView;

@end
