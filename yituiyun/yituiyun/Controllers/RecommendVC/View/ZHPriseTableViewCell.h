//
//  ZHPriseTableViewCell.h
//  tongmenyiren
//
//  Created by LUKHA_Lu on 16/9/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentsModel;
@class CollectModel;

@protocol ZHPriseTableViewCellDeleagete <NSObject>

- (void)goToPerson:(NSIndexPath*)indexPath WithPerTag:(NSInteger)perTag;


@end


@interface ZHPriseTableViewCell : UITableViewCell

@property (nonatomic, strong) CommentsModel *model;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) id <ZHPriseTableViewCellDeleagete> deleagete;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
