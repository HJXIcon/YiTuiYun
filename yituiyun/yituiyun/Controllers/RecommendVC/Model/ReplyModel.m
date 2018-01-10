//
//  ReplyModel.m
//  tongmenyiren
//
//  Created by 张强 on 16/8/26.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ReplyModel.h"

@implementation ReplyModel

-(void)setReplyContent:(NSString *)replyContent {
    _replyContent = replyContent;
    
    NSString *replyString;//判断是回复的还是评论的
    if ([ZQ_CommonTool isEmpty:self.replyName]) {
        replyString = [NSString stringWithFormat:@"%@ : %@", self.evaluationName, self.replyContent];
    } else {
        replyString = [NSString stringWithFormat:@"%@回复%@ : %@", self.evaluationName, self.replyName, self.replyContent];
    }
    CGSize replySize = [replyString sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ZQ_Device_Width - 45 - 12 - 12 - 5, MAXFLOAT)];
    _replyCellH = replySize.height + 2 + 5;
}

@end
