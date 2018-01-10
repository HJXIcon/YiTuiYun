//
//  CommentsModel.h
//  tongmenyiren
//
//  Created by 张强 on 16/8/26.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsModel : NSObject
/** 被评论人(艺人)id */
@property (nonatomic, copy) NSString *artistId;
/** 被评论人(艺人)名字 */
@property (nonatomic, copy) NSString *artistName;
/** 被评论人(艺人)回复内容 */
@property (nonatomic, copy) NSString *artistContent;
/** 是否匿名 */
@property (nonatomic, copy) NSString *isAny;
/** 评论id */
@property (nonatomic, copy) NSString *cid;
/** 评价人姓名 */
@property (nonatomic, copy) NSString *evaluationName;
/** 评价人id */
@property (nonatomic, copy) NSString *evaluationId;
/** 评价人头像 */
@property (nonatomic, copy) NSString *evaluationHeadPortrait;
/** 身份 */
@property (nonatomic, copy) NSString *uModelid;
/** 评价时间 */
@property (nonatomic, copy) NSString *evaluationTime;
/** 预约时间 */
@property (nonatomic, copy) NSString *preTime;
/** 评价内容  */
@property (nonatomic, copy) NSString *evaluationContent;
/** 订单号  */
@property (nonatomic, copy) NSString *orderNumber;
/** 拍摄时间  */
@property (nonatomic, copy) NSString *shootTime;
/** 视频地址  */
@property (nonatomic, copy) NSString *video;
/** 视频缩略图地址  */
@property (nonatomic, copy) NSString *videoThumb;
/** 评价图片集合  */
@property (nonatomic, strong) NSMutableArray *evaluationImagesArray;
/** 回复评论集合  */
@property (nonatomic, strong) NSMutableArray *replyArray;
/** 位置 1.商品详情 2.订单评价 */
@property (nonatomic, copy) NSString *where;
/** 发布的位置 */
@property (nonatomic, copy) NSString *region;
/** 主图 */
@property (nonatomic,copy) NSString *mainImage;
/** 赞的人的集合 */
@property (nonatomic, strong) NSMutableArray *praiseArray;
/** 我是否赞了 */
@property (nonatomic, copy) NSString *isPrise;
/** 我是否关注了 */
@property (nonatomic, copy) NSString *isFocuson;
/** 我是否收藏了 */
@property (nonatomic, copy) NSString *isCollection;
/** 动态ID */
@property (nonatomic, copy) NSString *dynamicID;
/** 是否有更多评论 */
@property (nonatomic, copy) NSString *isMoreComment;
/** 是否好评 */
@property (nonatomic, copy) NSString *isHighPraise;
/** 来自哪里 */
@property (nonatomic,copy) NSString *fromWhere;
/** describe */
@property (nonatomic,copy) NSString *describe;
/** Isreceive */
@property (nonatomic, copy) NSString *isReceive;
/** 是否点击更多 */
@property (nonatomic, copy) NSString *isEditMore;


/** 项目主图 */
@property (nonatomic, copy) NSString *mainImae;
/** 类别 */
@property (nonatomic, copy) NSString *category;
/** 类别1 */
@property (nonatomic, copy) NSString *category1;
/** 单价 */
@property (nonatomic, copy) NSString *unPrise;
/** 数量 */
@property (nonatomic, copy) NSString *timeNum;


/** 项目还是秀*/
@property (nonatomic, copy) NSString *isShow;

/** 是否修改评价 */
@property (nonatomic, copy) NSString *isEditComment;

/** 是否有追评 */
@property (nonatomic, copy) NSString *afterComment;

/** 追评的内容 */
@property (nonatomic, copy) NSString *afterCommentContant;
/** 追评的时间 */
@property (nonatomic, copy) NSString *afterCommentTime;
/** 追评的数组图片 */
@property (nonatomic, strong) NSMutableArray *afetrBlumArray;

@property (nonatomic, copy) NSString *isReplay;

@property (nonatomic, assign) CGFloat commentCellH;// 第一个row的高
@property (nonatomic, assign) CGFloat reginHeight;//定位的高

@property (nonatomic,assign) CGFloat priseCellH;

@property (nonatomic, copy) NSString *firstAvatr;

@property (nonatomic, copy) NSString *xiaoXiType;

@property (nonatomic,copy) NSString *is_ZhuiPing;




@end
