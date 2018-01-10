//
//  ReplyModel.h
//  tongmenyiren
//
//  Created by 张强 on 16/8/26.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject
/** 动态id  */
@property (nonatomic, copy) NSString *dynamicid;
/** 回复id  */
@property (nonatomic, copy) NSString *cid;
/** 评价人姓名  */
@property (nonatomic, copy) NSString *evaluationName;
/** 评价人身份  */
@property (nonatomic, copy) NSString *evaluationUModelid;
/** 评价人id*/
@property (nonatomic, copy) NSString *evaluationId;
/** 回复人姓名  */
@property (nonatomic, copy) NSString *replyName;
/** 回复人id  */
@property (nonatomic, copy) NSString *replyid;
/** 回复人身份  */
@property (nonatomic, copy) NSString *replyUModelid;
/** 回复人内容  */
@property (nonatomic, copy) NSString *replyContent;
/** 头像 */
@property (nonatomic, copy) NSString *headImage;
/** 是否可以删除 */
@property (nonatomic, copy) NSString *isdelte;

@property (nonatomic, assign) CGFloat replyCellH;

@end
