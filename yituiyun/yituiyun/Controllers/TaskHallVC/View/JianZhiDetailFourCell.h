//
//  JianZhiDetailFourCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TelBlock)(UIButton *btn);

@interface JianZhiDetailFourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
@property(nonatomic,copy)TelBlock  telblock;
@end
