//
//  FXUserInfoModel.h
//  yituiyun
//
//  Created by fx on 16/11/3.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

/*************************** 个人信息 简历 企业资料 公用model **********************************/

@interface FXUserInfoModel : NSObject

/** 个人id  */
@property (nonatomic, copy) NSString *personID;
/** 头像  */
@property (nonatomic, copy) NSString *personIcon;
/** 昵称 or企业名称 */
@property (nonatomic, copy) NSString *nickName;
/** 真实姓名 or负责人姓名  */
@property (nonatomic, copy) NSString *realName;
/** 性别  */
@property (nonatomic, copy) NSString *sex;
/** 电话  */
@property (nonatomic, copy) NSString *telPhone;
/** 通讯地址 办公地址 */
@property (nonatomic, copy) NSString *address;
/** 经度  */
@property (nonatomic, copy) NSString *lng;
/** 纬度  */
@property (nonatomic, copy) NSString *lat;
/** 行业id 企业  */
@property (nonatomic, copy) NSString *industry;
/** 行业title  企业 */
@property (nonatomic, copy) NSString *industryStr;
/** 工作年限  */
@property (nonatomic, copy) NSString *workYears;
/** 求职类型  */
@property (nonatomic, copy) NSString *jobType;
/** 兴趣爱好  */
@property (nonatomic, copy) NSString *hobby;
/** 身高  */
@property (nonatomic, copy) NSString *height;
/** 个人简介  */
@property (nonatomic, copy) NSString *introduce;
/** 身份证正面  */
@property (nonatomic, copy) NSString *idCardFront;
/** 身份证反面  */
@property (nonatomic, copy) NSString *idCardBack;
/** 出身年月  */
@property (nonatomic, copy) NSString *birthday;
/** 身份证号  */
@property (nonatomic, copy) NSString *idCard;
/** 毕业院校  */
@property (nonatomic, copy) NSString *school;
/** 学历 0未知 1博士 2研究生 3本科 4专科 5高中 6中专 7初中 8小学 */
@property (nonatomic, copy) NSString *education;
/** 微信号  */
@property (nonatomic, copy) NSString *weichat;
/** 网址  */
@property (nonatomic, copy) NSString *website;
/** 需求  */
@property (nonatomic, copy) NSString *desired;
/** 名片  */
@property (nonatomic, copy) NSString *callingCard;
/** 营业执照  */
@property (nonatomic, copy) NSString *certificate;
/** 动态  */
@property (nonatomic, strong) NSDictionary *dynamicDic;
/** 推荐人信息字典 */
@property(nonatomic,strong) NSDictionary * refersDic;

@property(nonatomic,strong) NSString * email;

/*****户口所在地*********/
@property(nonatomic,strong) NSString * ascription;

@end
