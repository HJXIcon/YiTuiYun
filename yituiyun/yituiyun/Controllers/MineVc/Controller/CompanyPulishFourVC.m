//
//  CompanyPulishFourVC.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyPulishFourVC.h"
#import "NeedDataModel.h"
#import "UploadImageModel.h"
#import "FXListModel.h"
#import "SetpModel.h"
#import "SetpImage.h"
#import "YYModel.h"
#import "CompanyNeedModel.h"
#import "CompanyNeedscontainer.h"
#import "OrderPayVc.h"
#import "JXRepeatButton.h"


@interface CompanyPulishFourVC ()

@end

@implementation CompanyPulishFourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)setDescModel:(CompanyNeedDesc *)descModel{
    _descModel = descModel;
    
    
    if (descModel !=nil) {
        self.makeSureBtn.hidden = !self.isCanEding;
        [self.makeSureBtn setTitle:@"修改需求" forState:UIControlStateNormal];
        
        
        if (self.isCanEding) {
        

        }else{
            self.nameLabel.text = descModel.projectName;
            self.priceLabel.text = [NSString stringWithFormat:@"%@元",descModel.price];
            self.numbeLabel.text = [NSString stringWithFormat:@"%@个",descModel.total_single];
            NSInteger single = [descModel.total_single integerValue];
            CGFloat price = [descModel.price floatValue];
            
            self.totalMoney.text = [NSString stringWithFormat:@"%.2f元",single*price];
        }
        
       
        
    }
    
    
    
}
- (IBAction)makeSure:(JXRepeatButton *)sender {
    
    MJWeakSelf
    
    [SVProgressHUD showWithStatus:@"资料上传中..."];
    

    [MobClick event:@"disiyequerendingd"];
    
    
    
    NSMutableDictionary *parm = [self getParm];
    
   
    
    if (parm == nil) {
        [self showHint:@"参数错误"];
        return ;
    }
    
    

    [XKNetworkManager POSTToUrlString:CompanyPulishNeedData parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *resutDict = JSonDictionary;

        
        if ([resutDict[@"errno"]  isEqualToString:@"0"]) {
            
            NSString *order = resutDict[@"rst"][@"demandid"];
            
            
            //立即支付
            UIViewController *vc = weakSelf.containVc.navigationController.childViewControllers[1];
            
            
            [weakSelf.containVc.navigationController popToViewController:vc animated:NO];
            
            OrderPayVc *payVc = [OrderPayVc new];
            payVc.demanID = order;
            
            
            
            [vc.navigationController pushViewController:payVc animated:YES];
            
            [[NeedDataModel shareInstance] cleanData];

            
            
        }else{
            [weakSelf showHint:resutDict[@"errno"]];
           
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];
    
    }

-(NSMutableDictionary *)getParm{
    NSMutableArray *city = [NSMutableArray array];
    for ( FXListModel *model in [NeedDataModel shareInstance].taskZone ) {
        [city addObject:model.linkID];
    }
    NSString *cityStr = [ city componentsJoinedByString:@"@"];
    
    
    NSMutableDictionary *dictparm = [NSMutableDictionary dictionary];
    
    dictparm[@"projectName"] = [NeedDataModel shareInstance].taskName;
    if ([dictparm[@"projectName"] isEqualToString:@""]) {
        [self showHint:@"请填写项目名称"];
        return nil;
    }
    dictparm[@"type"] = [NeedDataModel shareInstance].taskType;
    if ([dictparm[@"type"] isEqualToString:@""]) {
        [self showHint:@"请选择任务类型"];
        return nil;
    }
    dictparm[@"price"] = [NeedDataModel shareInstance].tasksingle;
    if ([dictparm[@"price"]  isEqualToString:@""]) {
        [self showHint:@"请选择任务单价"];
        return nil;
    }
    dictparm[@"total_single"] = [NeedDataModel shareInstance].taskNumber;
    if (    [dictparm[@"total_single"] isEqualToString:@""]) {
        [self showHint:@"请填写任务数量"];
        return nil;
    }
    
    dictparm[@"endDate"] = [NeedDataModel shareInstance].taskTime;
    if (    [dictparm[@"endDate"] isEqualToString:@""]) {
        [self showHint:@"请选择任务截止时间"];
        return nil;
    }
    dictparm[@"desc"] = [NeedDataModel shareInstance].taskDesc;
    if ([dictparm[@"desc"] isEqualToString:@""]) {
        [self showHint:@"请填写任务介绍"];
        return nil;
    }
    if ([NeedDataModel shareInstance].taskZone.count == 0 ) {
        [self showHint:@"请选择执行区域"];
        return nil;
    }
    if ([NeedDataModel shareInstance].taskSetpArray.count == 0 ) {
        [self showHint:@"请填写执行步骤"];
        return nil;
    }

    
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    dictparm[@"memberid"] = model.userID;
    dictparm[@"citys"] = cityStr;

    /*************三个数组**********/
    //拼接
    NSMutableArray *setpArrayresult = [NSMutableArray array];
    for (UploadImageModel *model in [NeedDataModel shareInstance].taskSetpArray) {
        SetpModel *setp = [[SetpModel alloc]init];
        setp.text = model.taskField;
        for (NSString *str in model.imageArray) {
            SetpImage *imageModel = [[SetpImage alloc]init];
            imageModel.url = str;
            [setp.img addObject:imageModel];
        }
        [setpArrayresult addObject:setp];
    }
    
    NSString *resultJson = [setpArrayresult yy_modelToJSONString];
    
    
    NSMutableArray  *ttt = [NSMutableArray array];
    
    
    for (CompanyNeedModel *strdd in [NeedDataModel shareInstance].taskrequireArray) {
       
    
        [ttt addObject:strdd.ID];
    }
    
    NSString *fiedStr = [ttt yy_modelToJSONString];

    dictparm[@"setting_idstr"] =fiedStr;
    dictparm[@"execute_step"] = resultJson;
    
    dictparm[@"enclosure"] =@"";
    dictparm[@"thumb"] = [NeedDataModel shareInstance].logoImageurl;
    
    
    if (self.isCanEding) {
        dictparm[@"demandid"] = [NeedDataModel shareInstance].demandID;
    }

    
    return dictparm;
    

}

@end
