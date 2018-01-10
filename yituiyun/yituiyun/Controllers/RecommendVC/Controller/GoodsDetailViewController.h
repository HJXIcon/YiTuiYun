//
//  GoodsDetailViewController.h
//  yituiyun
//
//  Created by 张强 on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@class GoodsModel;

@protocol GoodsDetailViewControllerDelegate <NSObject>

- (void)bookingGoodsButtonClickWithIndex:(NSIndexPath *)indexPath WithNum:(NSString *)num;

@end

@interface GoodsDetailViewController : ZQ_ViewController
- (instancetype)initWithGoodsModel:(GoodsModel *)goodsModel;
@property (weak, nonatomic) id <GoodsDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
