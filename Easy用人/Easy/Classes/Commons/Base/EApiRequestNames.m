//
//  EApiRequestNames.m
//  Easy
//
//  Created by yituiyun on 2017/12/5.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#pragma mark - *** webView接口地址
/** webView接口地址*/
NSString *const kWebViewApiPrefix = @"http://192.168.0.148:9081";

#pragma mark - *** 详细接口地址
/** 注册*/
NSString *const kRegister = @"/user/public/register";

/** 授权登录*/
NSString *const kAuthorizedLogin = @"/user/public/authorizedLogin";

/** 登录*/
NSString *const kLogin = @"/user/public/login";

/** 发送短信验证码*/
NSString *const kSendCode = @"/user/public/sendCode";

/** 找回密码*/
NSString *const kFindPassword = @"/user/public/findPassword";

/** 完善基本资料*/
NSString *const kEditMember = @"/user/user/editMember";

/** 修改手机号码*/
NSString *const kEditMobile = @"/user/user/editMobile";

/** 修改密码*/
NSString *const kEditPassword = @"/user/user/editPassword";

/** 上传图片*/
NSString *const kUploadUImage = @"/global/file/upload";

/** 意见反馈*/
NSString *const kFeedback = @"/user/user/feedback";

/** 通知中心获取未读消息总数*/
NSString *const kUnreadMsgCount = @"/user/user/unreadMsgCount";

/** 通知消息列表*/
NSString *const kMsgList = @"/user/user/msgList";

/** 实名认证*/
NSString *const kApplyAuthentication = @"/user/user/applyAuthentication";

/** 获取实名数据，状态*/
NSString *const kGetAuthentication = @"/user/user/getAuthentication";

/** 酒店列表*/
NSString *const kHotelList = @"/bp/index/hotelList";

/** 打卡历史列表*/
NSString *const kList = @"/bp/index/list";

/** 获取关注的人力公司*/
NSString *const kMyFollowHr = @"/user/user/myFollowHr";

/** 获取版本号*/
NSString *const kVersion = @"/user/public/version";

/** 兼职管理*/
NSString *const kUserGetDemand = @"/bp/demandPrice/userGetDemand";

/** 升级成为带队身份*/
NSString *const kUpgradeGroup = @"/user/user/upgradeGroup";

/** 获取用户个人资料*/
NSString *const kGetMemberInfo = @"/user/user/getMemberInfo";

/** 微信绑定手机号*/
NSString *const kWxBindMobile = @"/user/public/wxBindMobile";

/** 报名表*/
NSString *const kDemandGroupManage = @"/bp/demandPrice/demandGroupManage";

/** 获取已在项目中的团队成员userId*/
NSString *const kDemandGroupMember = @"/bp/demandPrice/demandGroupMember";

/** 获取我的团队成员*/
NSString *const kMyGroupMember = @"/user/user/myGroupMember";

/** 领队删除成员*/
NSString *const kDelGroupMember = @"/user/user/delGroupMember";

/** 领队删除成员*/
NSString *const kSearchMember = @"/user/user/searchMember";

/** 领队添加成员*/
NSString *const kAddGroupMember = @"/user/user/addGroupMember";

/** 项目团队增加成员*/
NSString *const kDemandAddMember = @"/bp/demandPrice/demandAddMember";

/** 我的评价*/
NSString *const kMyComment = @"/user/user/myComment";

/** app协议(注册界面)*/
NSString *const kAgreement = @"/global/eq/agreement";

/** 检查是否设置密码*/
NSString *const kCheckIsSetPwd = @"/user/user/checkIsSetPwd";

/** 设置密码*/
NSString *const kSetPassword = @"/user/user/setPassword";

/** 扫描二维码的地址*/
NSString *const kQRCodeApi = @"http://eqdev.yituiyun.cn:9081";
