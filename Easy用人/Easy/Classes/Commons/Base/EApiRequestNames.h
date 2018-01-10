//
//  EApiRequestNames.h
//  Easy
//
//  Created by yituiyun on 2017/12/5.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

/*!   ------  网络请求 -------       */
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever 1
#define TestSever    0
#define ProductSever 0

#if DevelopSever
/** 接口前缀-开发服务器*/
static NSString *const kApiPrefix = @"http://eqdev.yituiyun.cn:9052";
#elif TestSever
/** 接口前缀-测试服务器*/
static NSString *const kApiPrefix = @"http://192.168.0.148:9052";
#elif ProductSever
/** 接口前缀-生产服务器*/
static NSString *const kApiPrefix = @"http://139.196.115.177:9052";
#endif

#define  E_ApiRequset(string) ([NSString stringWithFormat:@"%@%@",kApiPrefix,string])

#pragma mark - *** webView接口地址
/** webView接口地址*/
UIKIT_EXTERN NSString *const kWebViewApiPrefix;


#pragma mark - *** 详细接口地址
/** 注册*/
UIKIT_EXTERN NSString *const kRegister;

/** 授权登录*/
UIKIT_EXTERN NSString *const kAuthorizedLogin;

/** 登录*/
UIKIT_EXTERN NSString *const kLogin;

/** 发送短信验证码*/
UIKIT_EXTERN NSString *const kSendCode;

/** 找回密码*/
UIKIT_EXTERN NSString *const kFindPassword;

/** 完善基本资料*/
UIKIT_EXTERN NSString *const kEditMember;

/** 修改手机号码*/
UIKIT_EXTERN NSString *const kEditMobile;

/** 修改密码*/
UIKIT_EXTERN NSString *const kEditPassword;

/** 上传图片*/
UIKIT_EXTERN NSString *const kUploadUImage;

/** 意见反馈*/
UIKIT_EXTERN NSString *const kFeedback;

/** 通知中心获取未读消息总数*/
UIKIT_EXTERN NSString *const kUnreadMsgCount;

/** 通知消息列表*/
UIKIT_EXTERN NSString *const kMsgList;

/** 实名认证*/
UIKIT_EXTERN NSString *const kApplyAuthentication;

/** 获取实名数据，状态*/
UIKIT_EXTERN NSString *const kGetAuthentication;

/** 酒店列表*/
UIKIT_EXTERN NSString *const kHotelList;

/** 打卡历史列表*/
UIKIT_EXTERN NSString *const kList;

/** 获取关注的人力公司*/
UIKIT_EXTERN NSString *const kMyFollowHr;

/** 获取版本号*/
UIKIT_EXTERN NSString *const kVersion;

/** 兼职管理*/
UIKIT_EXTERN NSString *const kUserGetDemand;

/** 升级成为带队身份*/
UIKIT_EXTERN NSString *const kUpgradeGroup;

/** 获取用户个人资料*/
UIKIT_EXTERN NSString *const kGetMemberInfo;

/** 微信绑定手机号*/
UIKIT_EXTERN NSString *const kWxBindMobile;

/** 报名表*/
UIKIT_EXTERN NSString *const kDemandGroupManage;

/** 获取已在项目中的团队成员userId*/
UIKIT_EXTERN NSString *const kDemandGroupMember;

/** 获取我的团队成员*/
UIKIT_EXTERN NSString *const kMyGroupMember;

/** 领队删除成员*/
UIKIT_EXTERN NSString *const kDelGroupMember;

/** 领队删除成员*/
UIKIT_EXTERN NSString *const kSearchMember;

/** 领队添加成员*/
UIKIT_EXTERN NSString *const kAddGroupMember;

/** 项目团队增加成员*/
UIKIT_EXTERN NSString *const kDemandAddMember;

/** 我的评价*/
UIKIT_EXTERN NSString *const kMyComment;

/** app协议(注册界面)*/
UIKIT_EXTERN NSString *const kAgreement;

/** 检查是否设置密码*/
UIKIT_EXTERN NSString *const kCheckIsSetPwd;

/** 设置密码*/
UIKIT_EXTERN NSString *const kSetPassword;

/** 扫描二维码的地址*/
UIKIT_EXTERN NSString *const kQRCodeApi;



