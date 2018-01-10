//
//  CompanyThreeCollectionCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyNeedModel.h"

@interface CompanyThreeCollectionCell : UICollectionViewCell
/**uilabel */
@property(nonatomic,strong) UILabel * contentLabel;
/**内容字典 */
@property(nonatomic,strong) CompanyNeedModel * model;

@end
