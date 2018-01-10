//
//  LHKAPI.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#ifndef LHKAPI_h
#define LHKAPI_h

#import "NSString+LHKExtension.h"
#import "UIViewController+LHKHUD.h"
#import "SVProgressHUD.h"
#import "NSArray+Safe.h"
#define fontradio(i)  i*ScreenWidth/375.0f


#import "Masonry.h"
#define Kversion @"kversion"
#define KversionTishi @"kversiontishi"
#define App_url @"http://itunes.apple.com/us/app/id1167285122"

#define ViewFromXib [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject]
#define KNotifceNodeInvalid  @"KNotifceNodeInvalid"

//十六进制颜色转换成UIColor  UIColorFromRGB(0xffffff)
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//UIColorFromRGBString(@"0xffffff")
#define UIColorFromRGBString(rgbString) [UIColor colorWithRed:((strtoul([rgbString cStringUsingEncoding:NSUTF8StringEncoding], 0, 16) & 0xFF0000 )>>16)/255.0 green:((strtoul([rgbString cStringUsingEncoding:NSUTF8StringEncoding], 0, 16) & 0x00FF00 )>>8)/255.0 blue:(strtoul([rgbString cStringUsingEncoding:NSUTF8StringEncoding], 0, 16) & 0x0000FF)/255.0 alpha:1.0]
//当前设备的版本
#define     kCurrentFloatDevice     [[[UIDevice currentDevice]systemVersion]floatValue]


#define  WRadio(I)  I*[UIScreen mainScreen].bounds.size.width/375.0f
#define  HRadio(I)  I*[UIScreen mainScreen].bounds.size.height/667.0f
#define JSonDictionary  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]
#define  FontRadio(I)  I*[UIScreen mainScreen].bounds.size.width/375.0f

#define PersonCenterName  @"PersonCenterName"
#define PersonCenterCarId @"PersonCenterCarId"
#define HuiSeBtnValue  @"0xcacaca"
#define HongSeMain     @"0xf16156"
#define MaxCountPicToNeeds 9

#define API(I) [NSString stringWithFormat:@"%@%@", kHost,I]
#import "LHKAlterView.h"
#import "JianZhiModel.h"
#define LoginUsernameSave @"LoginUsernameSave"
/**************/

#define GetNearySellerURL API(@"api.php?m=user.periphery")
#define GetSellerWriteURL API(@"api.php?m=my.storeSave")
#define GetFieldURL API(@"api.php?m=linkage.get")
#define FileUpload  API(@"kindeditor/php/uploadApi.php?mode=1")
#define AppGuideRequestURL API(@"api.php?m=data.ad")
#define ProjectRestartTaskURL API(@"api.php?m=user.addTask")
#define TaskHallGetTasks API(@"api.php?m=get.my_tasks")
#define TaskQianDao API(@"api.php?m=add.new_node")
#define TaskStartorCancel API(@"api.php?m=user.taskStatus")
#define TaskNodeTimeDetail API(@"api.php?m=get.collectData")
#define AliPayUserInterface API(@"api.php?m=pay.aliPay")
#define WeChatUserInterface API(@"api.php?m=pay.wxPay")
#define Unionpay API(@"api.php?m=pay.unionPay")
#define BackToPay API(@"api.php?m=burse.reimburse")
#define OrderGeneral API(@"api.php?m=burse.toPay")
#define UnionPaySign API(@"api.php?m=pay.frontValidate")
#define CompanyNeedsGetLabel API(@"api.php?m=get.collect_fields")
#define CompanyPulishNeedData API(@"api.php?m=add.demand")
#define CompanyPulishNeedList API(@"api.php?m=get.demandList")
#define CompanyNeedsGetOrder API(@"api.php?m=burse.pay_demand")
#define CompanyJianzhiBurseToPay API(@"api.php?m=burse.pay_job")
#define ConpanyNeedGetWalletandPrice API(@"api.php?m=get.payDemand")
#define CompanyJianZiPayJobMoney API(@"api.php?m=get.payJob")
#define CompanyNeedWalletToPay API(@"api.php?m=pay.burse_pay")
#define CompanyNeedsCancelTask API(@"api.php?m=my.cancelDemand")
#define CompayNeedListDetail API(@"api.php?m=get.demandDetail")
#define GetInviteAddress API(@"api.php?m=my.getExtensionUrl")
#define RealNameCerfi API(@"api.php?m=my.authentication")
#define RealNameCerfiStatus API(@"api.php?m=my.authenticationStatus")
#define InviteCountandFenghong  API(@"api.php?m=my.getExtensionCount")
#define InviteCountPaiMing API(@"api.php?m=my.getExtensionRanking")
#define InviteFengHongPaiMing API(@"api.php?m=my.getExtensionList")
#define MyMoneyDetail API(@"api.php?m=my.getAmountDetail")
#define MyMoneyOneDetail API(@"api.php?m=my.getAmountDetailDesc")
#define TiXianRecordList API(@"api.php?m=my.getDrawmoney")
#define TiXianRecordDetail API(@"api.php?m=my.getDrawmoneyDetail")
#define CompanyDeleteNeedTask API(@"api.php?m=my.delDemand")
#define CompanyWorkList API(@"api.php?m=get.demandNodeList")
#define CompanyWorkShenHe API(@"api.php?m=user.actionNode")
#define GetInfoByPhone API(@"api.php?m=my.superior")
#define GetBankListName API(@"api.php?m=pay.bankList")
#define CompanyNeedStop API(@"api.php?m=add.demand")
#define CompanyNeedShenHeSucess API(@"api.php?m=user.actionNode")
#define QrCodeGeneral API(@"api.php?m=my.qrcode")
#define AddOrderInterface API(@"api.php?m=burse.addDeamndSku")
#define InvoiceDetail API(@"api.php?m=get.invoice")
#define InvoiceSaveOrXiu API(@"api.php?m=add.invoice")
#define AllCitys API(@"api.php?m=data.areas")
#define JianZhiTijiao API(@"api.php?m=add.job")
#define JianZhiCompanyList API(@"api.php?m=get.jobList")
#define JianZhiCompanyListDetail API(@"api.php?m=get.jobDetail")
#define JianZhiStopHandle API(@"api.php?m=user.jobStop")
#define JianZhiSheHeList API(@"api.php?m=get.applyList")
#define JianZhiHandleRefuseOrPass API(@"api.php?m=user.actionApply")
#define MyAllJianZhi  API(@"api.php?m=get.myJobApply")
#define JianZhiBaoMing API(@"api.php?m=user.jobApplyStatus")
#define JianZhiCollection API(@"api.php?m=user.collect")
#define JianZhiTongJi API(@"api.php?m=get.jobApplyCount")
#define FaPiaoRecordList API(@"api.php?m=get.consumerList")
#define SubmitFaPiao  API(@"api.php?m=add.invoice_apply")
#define HistryFaPiaoList API(@"api.php?m=get.invoiceList")
#define HistryFapiaoListDetail API(@"api.php?m=get.invoiceDetail")
#define GetLastFapiaoRecord API(@"api.php?m=get.new_invoice")
#endif /* LHKAPI_h */
