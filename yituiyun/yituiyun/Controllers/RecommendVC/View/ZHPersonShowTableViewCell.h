//
//  ZHPersonShowTableViewCell.h
//  tongmenyiren
//
//  Created by LUKHA_Lu on 16/8/31.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentsModel;

@protocol ZQPersonCommentsCellDelegate <NSObject>

- (void)reviewImagesButtonClickWithIndex:(NSIndexPath *)index WithImageTag:(NSInteger)tag;
- (void)gotoPersonAction:(NSIndexPath *)indexPath WithBtnTag:(NSInteger)tag;

@end

@interface ZHPersonShowTableViewCell : UITableViewCell

@property (nonatomic, strong) CommentsModel *commentsModel;

@property(nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id <ZQPersonCommentsCellDelegate> delegate;
@property(nonatomic,assign) CGFloat height;

+ (ZHPersonShowTableViewCell *)cellWithTableView:(UITableView*)tableView;

@end
