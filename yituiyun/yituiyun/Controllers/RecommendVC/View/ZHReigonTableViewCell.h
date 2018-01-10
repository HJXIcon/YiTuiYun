//
//  ZHReigonTableViewCell.h
//  tongmenyiren
//
//  Created by LUKHA_Lu on 16/12/16.
//  Copyright © 2016年 ganruihao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentsModel;

@protocol ZHReigonTableViewCellDelegete <NSObject>

- (void)btnPersonShowButtonClickWithIndex:(NSIndexPath *)indexPath WithBtnTag:(UIButton*)ubutton;

@end

@interface ZHReigonTableViewCell : UITableViewCell

@property (nonatomic, strong) CommentsModel *commentsModel;
@property (nonatomic, assign) id <ZHReigonTableViewCellDelegete> delegete;
@property (nonatomic, strong) NSIndexPath *indexPath;

/** 定位的一个button */
@property (nonatomic, strong) UIButton *reginButton;
/** 定位的图片 */
@property (nonatomic, strong) UIImageView  *reginImage;
/** 定位的地址 */
@property (nonatomic, strong) UILabel *reginLabel;
/** 点击出现更多的VIew */
@property (nonatomic, strong) UIButton *moreButton;
/** 更多view的图片 */
@property (nonatomic, strong) UIImageView *moreImage;

/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleateBtn;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *btnView;


@end
