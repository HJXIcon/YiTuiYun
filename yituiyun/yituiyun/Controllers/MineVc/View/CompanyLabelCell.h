//
//  CompanyLabelCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyNeedModel.h"

@interface CompanyLabelCell : UICollectionViewCell
@property(nonatomic,strong) UIView * panView;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong) UIView * showView;

@property(nonatomic,strong) CompanyNeedModel   * model;

-(void)setBackToShowViewNormal;
-(void)setBackToShowViewSelect;

@end
