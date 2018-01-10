//
//  ZHReplayTableViewCell.h
//  tongmenyiren
//
//  Created by LUKHA_Lu on 16/9/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentsModel;
@class ReplyModel;
@class HFTextView;

@protocol ZHReplayTableViewCellDeleagete <NSObject>

/** 点击某人名字 */
- (void)replayWithUserId:(NSString*)userId withUserName:(NSString*)userName;
/** 回复某条评论 */
- (void)replayCommentWithIndexPath:(NSIndexPath*)indexPath WithtextView:(HFTextView *)textView;
/** 删除某条评论 */
- (void)deleteWithIndexPath:(NSIndexPath*)indexPath;
//改变展开收回状态
- (void)changeFoldWithIndexPath:(NSIndexPath*)indexPath;
//长按
- (void)longPressWithIndexPath:(NSIndexPath*)indexPath;
//点击评论人名字
- (void)clickCommentPeopleWithIndexPath:(NSIndexPath*)indexPath;


@end

@interface ZHReplayTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic, assign) id <ZHReplayTableViewCellDeleagete> delegate;



@property (nonatomic, strong) ReplyModel *commentsModel;

@end
