//
//  JXPunchClockAddressCell.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXBaseTableViewCell.h"

@interface JXPunchClockAddressCell : JXBaseTableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *refreshButton;
/// 没有更新按钮的时候显示
@property (nonatomic, strong) UILabel *addressNotRefrshLabel;
/** 刷新*/
@property (nonatomic, copy) void(^reloadAddressBlock)();
@end
