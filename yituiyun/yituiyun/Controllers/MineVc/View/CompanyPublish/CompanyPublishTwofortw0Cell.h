//
//  CompanyPublishTwofortw0Cell.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadImageModel.h"

typedef void(^DelteBlock) ();

@protocol CompanyPublishTwofortw0CellDelegate <NSObject>

- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath;
- (void)addImageButtonClickWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface CompanyPublishTwofortw0Cell : UITableViewCell

@property(nonatomic,weak)id<CompanyPublishTwofortw0CellDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UILabel *placLabel;

/**当前位置 */
@property(nonatomic,strong) NSIndexPath * indexPath;

@property(nonatomic,copy) DelteBlock deleteBlock;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIView *panView;

/**模型数据 */
@property(nonatomic,strong) UploadImageModel * model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textNHeightConstant;

@property(nonatomic,assign) BOOL isDetail;


@end
