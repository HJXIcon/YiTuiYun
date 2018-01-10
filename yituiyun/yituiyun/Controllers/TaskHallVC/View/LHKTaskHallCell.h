//
//  LHKTaskHallCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/31.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskHallModel.h"
#import "CompanyNeedListModel.h"

typedef void(^TingZhiBlock)();
typedef void(^AddBlock)();
@interface LHKTaskHallCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subImageView;
@property (weak, nonatomic) IBOutlet UILabel *shengyuLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (weak, nonatomic) IBOutlet UIView *fenjieView;
@property (weak, nonatomic) IBOutlet UILabel *recevLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;

/**model */
@property(nonatomic,strong) TaskHallModel * model;
@property (weak, nonatomic) IBOutlet UIView *twoBtnPanView;

@property (weak, nonatomic) IBOutlet UIButton *tingzhiBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property(nonatomic,copy) TingZhiBlock  tingzhiblock;
@property(nonatomic,copy) AddBlock  addblock;
@property (weak, nonatomic) IBOutlet UILabel *shengyubaozhengjinLabel;
@property(nonatomic,strong) CompanyJianZhiModel * listmodel;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftcontstant;

@property(nonatomic,strong) JiZhiSheHeListModel * jianzhishenhemodel;



@end
