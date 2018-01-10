//
//  ZHReplayTableViewCell.m
//  tongmenyiren
//
//  Created by LUKHA_Lu on 16/9/27.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZHReplayTableViewCell.h"
#import "CommentsModel.h"
#import "ReplyModel.h"
#import "HFTextView.h"
#import "UIColor+HFExtension.h"
#import "ILRegularExpressionManager.h"
#import "NSString+NSString_ILExtension.h"
@interface ZHReplayTableViewCell ()<HFTextViewDelegate>


@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) HFTextView *textView;

@property (nonatomic, strong) UILabel *replayLabel;//回复的内容


@end

@implementation ZHReplayTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textView = [[HFTextView alloc] initWithFrame:CGRectMake(39 + 12, 0, ZQ_Device_Width - 59 + 36.75 - 51, 0)];
        self.textView.textColor = kUIColorFromRGB(0x216fc6);
        self.textView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        [self.contentView addSubview:self.textView];
        
    }
    return self;
}

- (void)setCommentsModel:(ReplyModel *)commentsModel{
    _commentsModel = commentsModel;
    
    self.textView.frame = CGRectMake(39 + 12, 0, ZQ_Device_Width - 59 + 36.75 - 51, 0);
    
    NSString *matchString;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    if ([ZQ_CommonTool isEmpty:commentsModel.replyName]) {
        matchString = [NSString stringWithFormat:@"%@:%@",commentsModel.evaluationName,commentsModel.replyContent];
        
        NSString *range = NSStringFromRange(NSMakeRange(0, commentsModel.evaluationName.length));
        [tempArr addObject:range];
    } else {
        NSString* userName = commentsModel.evaluationName;
        NSString* replayName = commentsModel.replyName;
        matchString = [NSString stringWithFormat:@"%@回复%@:%@", userName, replayName,commentsModel.replyContent];
        NSString *range1 = NSStringFromRange(NSMakeRange(0, userName.length));
        [tempArr addObject:range1];
        NSString *range2 = NSStringFromRange(NSMakeRange(userName.length + 2, replayName.length));
        [tempArr addObject:range2];
    }
    NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
    NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                       withString:PlaceHolder];
    
    NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0];
    
    //**********号码******
    
    NSMutableArray *mobileLink = [ILRegularExpressionManager matchMobileLink:newString];
    for (int i = 0; i < mobileLink.count; i ++) {
        
        [totalArr addObject:[mobileLink objectAtIndex:i]];
    }
    
    //*************************
    
    //***********匹配网址*********
    
    NSMutableArray *webLink = [ILRegularExpressionManager matchWebLink:newString];
    for (int i = 0; i < webLink.count; i ++) {
        
        [totalArr addObject:[webLink objectAtIndex:i]];
    }
    
    //******自行添加**********
    for (int i = 0; i < [tempArr count]; i ++) {
        NSString *string = [newString substringWithRange:NSRangeFromString([tempArr objectAtIndex:i])];
        [totalArr addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString([tempArr objectAtIndex:i]))]];
    }
    self.textView.delegate = self;
    self.textView.isFold = NO;
    self.textView.isDraw = YES;
    self.textView.canClickAll = true;
    self.textView.attributedData = totalArr;
    self.textView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    //***********************
    [self.textView setOldString:matchString andNewString:newString];
    
    self.textView.frame = CGRectMake(39 + 12, 0, ZQ_Device_Width - 59 + 36.75 - 51, [self.textView getTextHeight]);
    
    commentsModel.replyCellH = CGRectGetMaxY(self.textView.frame);
    
}
//文字内容点击
- (void)clickHFTextView:(NSString *)clickString{
    
    if (![ZQ_CommonTool isEmpty:clickString]) {
        //        // 点击的是自己还是别人
        //        NSString *string = nil;
        //        if ([self.commentsModel.replyid isEqualToString:@"0"]) {
        //            string = self.commentsModel.evaluationId;
        //        } else {
        //            if ([clickString isEqualToString:UserDefaultsGet(UserName)]) {
        //                 string = self.commentsModel.evaluationId;
        //            } else {
        //                 string = self.commentsModel.replyid;
        //            }
        //        }
        //        if (self.delegate && [self.delegate respondsToSelector:@selector(replayWithUserId:withUserName:)]) {
        //            [self.delegate replayWithUserId:string withUserName:clickString];// 这个是回复
        //        }
        //    } else {
        //        if (self.delegate && [self.delegate respondsToSelector:@selector(replayCommentWithIndexPath:WithtextView:)]) {
        //            [self.delegate replayCommentWithIndexPath:self.indexPath WithtextView:self.textView];// 这个是回复
        //        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickCommentPeopleWithIndexPath:)]) {
            [self.delegate clickCommentPeopleWithIndexPath:self.indexPath];
        }
    }
}
//文字内容长按
- (void)longClickHFTextView:(NSString *)clickString{
    if (self.commentsModel != nil) {
        UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
        if ([self.commentsModel.evaluationId isEqualToString:userinfo.userID]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(longPressWithIndexPath:)]) {
                [self.delegate longPressWithIndexPath:self.indexPath];
            }
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
