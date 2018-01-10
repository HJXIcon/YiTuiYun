//
//  UserInfoModel.h
//  社区快线
//
//  Created by 张强 on 15/12/8.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
/** 用户头像  */
@property (nonatomic, copy) NSString *avatar;
/** 用户ID */
@property (nonatomic, copy) NSString *userID;
/** 身份 */
@property (nonatomic, copy) NSString *identity;
/** 是否允许查看BD手机号 */
@property (nonatomic, copy) NSString *isSeeTel;
/** 是否申请变更全职 */
@property (nonatomic, copy) NSString *isChange;
/** 求职类型 */
@property (nonatomic, copy) NSString *jobType;
/** 显示的MyID */
@property (nonatomic, copy) NSString *MyID;
/** 用户昵称  */
@property (nonatomic, copy) NSString *nickname;
/** 用户名  */
@property (nonatomic, copy) NSString *username;
/** 性别  */
@property (nonatomic, copy) NSString *sex;
/** 用户手机号  */
@property (nonatomic, copy) NSString *mobile;
/** 是否接收系统消息消息 */
@property (nonatomic, copy) NSString *sysNotice;
/** 是否接受聊天消息 */
@property (nonatomic, copy) NSString *chatNotice;
/** 生日  */
@property (nonatomic, copy) NSString *age;
/** 性别  */
@property (nonatomic, copy) NSString *gender;
/** 用户等级 */
@property (nonatomic, copy) NSString *userLevel;
/** 用户二维码 */
@property (nonatomic, copy) NSString *userCode;
/** 地区 */
@property (nonatomic, copy) NSString *region;
/** 个性签名 */
@property (nonatomic, copy) NSString *signature;
/** 关注数 */
@property (nonatomic, copy) NSString *focusNub;
/** 粉丝数 */
@property (nonatomic, copy) NSString *fanceNub;
/** 收藏数 */
@property (nonatomic, copy) NSString *collectNub;
/** 是否绑定微信  */
@property (nonatomic, copy) NSString *isWeiXin;
/** 是否绑定QQ  */
@property (nonatomic, copy) NSString *isQQ;
/** qqUId  */
@property (nonatomic, copy) NSString *qqUid;
/** 微信UID */
@property (nonatomic, copy) NSString *weixinUid;
/** 是否等待审核 */
@property (nonatomic, copy) NSString *isAudit;

/** 待付款  */
@property (nonatomic, copy) NSString *obligations;
/** 接单数 */
@property (nonatomic, copy) NSString *receiveOrders;
/** 配送数  */
@property (nonatomic, copy) NSString *distribution;
/** 完成数  */
@property (nonatomic, copy) NSString *complete;
/** 消息数  */
@property (nonatomic, copy) NSString *information;
//** 是否绑定微博 */
@property (nonatomic, copy) NSString *isWeiBo;

/** 好评率 */
@property (nonatomic, copy) NSString *rateString;
/** 是否关注 */
@property (nonatomic, copy) NSString *isFocOn;


/** 学历 */
@property (nonatomic, copy) NSString *recordString;
/** 所在地 */
@property (nonatomic, copy) NSString *homeString;
/** 详情地址 */
@property (nonatomic, copy) NSString *addressString;
/** 工龄 */
@property (nonatomic, copy) NSString *lengthString;
/** 加盟区域 */
@property (nonatomic, copy) NSString *joinArea;
/** 拍摄类别 */
@property (nonatomic, copy) NSString *filmCategory;

/** 人身险价格  */
@property (nonatomic, copy) NSString *rsprice;
/** 工资险价格  */
@property (nonatomic, copy) NSString *gzprice;


/** 分享标题  */
@property (nonatomic, copy) NSString *shareTitle;
/** 分享描述  */
@property (nonatomic, copy) NSString *shareDescription;
/** 分享图片  */
@property (nonatomic, copy) NSString *shareImg;
/** 分享地址  */
@property (nonatomic, copy) NSString *shareUrl;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
