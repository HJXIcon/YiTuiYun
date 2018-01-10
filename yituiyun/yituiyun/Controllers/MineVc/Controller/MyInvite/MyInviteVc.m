//
//  MyInviteVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/20.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "MyInviteVc.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "InviteNumberVc.h"
#import "InviteFenhongDetail.h"
#import "CodeImageViewVc.h"


@interface MyInviteVc ()
@property (weak, nonatomic) IBOutlet UILabel *numberInvitLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property(nonatomic,strong) NSString * inviteAddress;
@property(nonatomic,strong) NSString * inviteTitle;
@property(nonatomic,strong) NSString * inviteContent;
@property(nonatomic,strong) UIImage * logoImage;
@property (weak, nonatomic) IBOutlet UIButton *yaoyueBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@end

@implementation MyInviteVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getInviteAdress];
    self.inviteAddress = @"";
    [self getCountandFenghongFromServer];
    self.yaoyueBtn.layer.cornerRadius = 5;
    self.yaoyueBtn.clipsToBounds = YES;
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.clipsToBounds = YES;
    [MobClick event:@"gerenzhongxinyaoyue"];
}
-(void)viewWillAppear:(BOOL)animated{
     [self getCountandFenghongFromServer];
}
- (IBAction)codeBtnClick:(id)sender {
    MJWeakSelf
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"user_id"] = usermodel.userID;
    
    [SVProgressHUD showWithStatus:@"数据加载.."];
    [XKNetworkManager POSTToUrlString:QrCodeGeneral parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
      
        NSDictionary *resultDict = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
        
        if ([code isEqualToString:@"0"]) {
            CodeImageViewVc *vc = [[CodeImageViewVc alloc]init];
            vc.imageUrl = [NSString imagePathAddPrefix:resultDict[@"rst"]];
            
            
            
            vc.view.backgroundColor =[UIColor colorWithWhite:0 alpha:0.7];
            vc.modalPresentationStyle=UIModalPresentationCustom;
            
            [weakSelf presentViewController:vc animated:YES completion:nil];

            
        }else{
            [weakSelf showHint:code];
        }
        
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:@"服务器问题"];
    }];
    return ;
    
}

-(void)getCountandFenghongFromServer{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict[@"memberid"] = model.userID;
    [XKNetworkManager POSTToUrlString:InviteCountandFenghong parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        NSDictionary *resultDic = JSonDictionary;
        [SVProgressHUD dismiss];
         if ([resultDic[@"errno"] isEqualToString:@"0"]) {
            
            weakSelf.numberInvitLabel.text =[NSString stringWithFormat:@"%@个",resultDic[@"rst"][@"count"]];
            weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%@元",resultDic[@"rst"][@"money"]];
         }else{
             [weakSelf showHint:@"数据请求出错"];
         }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
-(void)getInviteAdress{
    MJWeakSelf
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = model.userID;
    [XKNetworkManager POSTToUrlString:GetInviteAddress parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resutDict = JSonDictionary;
        if ([resutDict[@"errno"] isEqualToString:@"0"]) {
            weakSelf.inviteAddress =  resutDict[@"rst"][@"url"];
            weakSelf.inviteTitle = resutDict[@"rst"][@"title"];
            weakSelf.inviteContent = resutDict[@"rst"][@"title"];
          
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
- (IBAction)inviteClick:(id)sender {
    InviteNumberVc  *inv = [[InviteNumberVc alloc]init];
    inv.navigationItem.title = @"我的邀约";
    pushToControllerWithAnimated(inv)
}
- (IBAction)fenhongClick:(id)sender {
    InviteFenhongDetail  *inv2 = [[InviteFenhongDetail alloc]init];
    inv2.navigationItem.title = @"分红明细";
    pushToControllerWithAnimated(inv2)

}
- (IBAction)shareClick:(id)sender {
    
    if ([self.inviteAddress isEqualToString:@""]) {
        [self showHint:@"请求失败"];
        [self getInviteAdress];
        return;
    }
    [MobClick event:@"yaoyuezhuanqianyaoyue"];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    
    [SSUIShareActionSheetStyle setStatusBarStyle:UIStatusBarStyleLightContent];
    [SSUIShareActionSheetStyle setActionSheetColor:kUIColorFromRGB(0xeeeeee)];
    [SSUIShareActionSheetStyle setItemNameColor:kUIColorFromRGB(0x777777)];
    [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:11]];
    [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:kUIColorFromRGB(0xeeeeee)];
    [SSUIShareActionSheetStyle setCancelButtonLabelColor:kUIColorFromRGB(0x666666)];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.inviteContent
                                     images:@[[UIImage imageNamed:@"logo"]]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.inviteAddress]]
                                      title:self.inviteTitle
                                       type:SSDKContentTypeAuto];
    
    
    [shareParams SSDKSetupQQParamsByText:self.inviteContent
                                   title:self.inviteTitle
                                     url:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.inviteAddress]]
                              thumbImage:[UIImage imageNamed:@"logo"]
                                   image:[UIImage imageNamed:@"logo"]

                                    type:SSDKContentTypeWebPage
                      forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    NSArray * platforms =@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatFav),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)];
    //2、分享
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:sender
                                                                     items:platforms
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                               {
                                                                   [MobClick event:@"shareObjectNums"];
                                                                   
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                               case SSDKResponseStateFail:
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                                   
                                                               default:
                                                                   break;
                                                           }
                                                       }];

}



@end
