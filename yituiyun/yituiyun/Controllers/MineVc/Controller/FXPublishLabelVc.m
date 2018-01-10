//
//  FXPublishLabelVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "FXPublishLabelVc.h"
#import "CompanyLabelCell.h"
#import "CompanyNeedModel.h"
#import "YYModel.h"

@interface FXPublishLabelVc ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *makesureBtn;
@property(nonatomic,strong) NSMutableArray * labeldatas;
//给钱一页面的结果
@property(nonatomic,strong) NSMutableArray * resultDatas;
@end

@implementation FXPublishLabelVc
- (IBAction)backToLast:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)makeSureClick:(id)sender {
    
    
    if (self.block) {
        [self.resultDatas removeAllObjects];

        for (CompanyNeedModel *subModel in self.labeldatas) {
            if (subModel.isShow == 1) {
                [self.resultDatas addObject:subModel];
            }
        }

        self.block(self.resultDatas);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(NSMutableArray *)resultDatas{
    if (_resultDatas == nil) {
        _resultDatas = [NSMutableArray array];
    }
    return _resultDatas;
}

-(NSMutableArray *)labeldatas{
    if (_labeldatas == nil) {
        _labeldatas = [NSMutableArray array];
    }
    return _labeldatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //注册cell
    [self.collectionView registerClass:[CompanyLabelCell class] forCellWithReuseIdentifier:@"CompanyLabelCell"];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.itemSize = CGSizeMake(ScreenWidth/2.0f-2, 40);
    self.collectionView.collectionViewLayout = flow;
    flow.minimumLineSpacing = 1;
    flow.minimumInteritemSpacing = 1;

    //请求服务器
    [self getDataFromSever];
    
    self.makesureBtn.layer.cornerRadius = 2;
    self.makesureBtn.clipsToBounds = YES;

    
    
}

-(void)getDataFromSever{
    MJWeakSelf
    
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [XKNetworkManager GETDataFromUrlString:CompanyNeedsGetLabel parameters:dict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *tempDict = JSonDictionary;
        NSArray *dataArray = tempDict[@"rst"];
        
        
//        weakSelf.labeldatas = [CompanyNeedModel objectArrayWithKeyValuesArray:dataArray];
       
        for (NSDictionary *dict in dataArray) {
            CompanyNeedModel *model = [[CompanyNeedModel alloc]init];
            model.ID = dict[@"id"];
            model.fid = dict[@"fid"];
            model.name_zh= dict[@"name_zh"];
            [weakSelf.labeldatas addObject:model];
        }
        
        
        if (weakSelf.qianmianDatas.count>0) {
            
            for (CompanyNeedModel *model in weakSelf.labeldatas) {
                for (CompanyNeedModel *subModel in weakSelf.qianmianDatas) {
                    if ([model.fid isEqualToString:subModel.fid]) {
                    
                        model.isShow = 1;
                        break;
                    }else{
                        model.isShow = 0;
                    }
                }
                /*******************/
            
            
            }
            
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
        
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CompanyLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CompanyLabelCell" forIndexPath:indexPath];
    CompanyNeedModel *model = self.labeldatas[indexPath.row];
    cell.model = model;
    
    if (model.isShow == 1) {
        [cell setBackToShowViewSelect];
    }else{
        [cell setBackToShowViewNormal];}

    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.labeldatas.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CompanyNeedModel *model = self.labeldatas[indexPath.row];
    
    if (model.isShow == 1) {
        model.isShow =0;
    }else{
        model.isShow = 1;
    }
    CompanyLabelCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (model.isShow == 1) {
        [cell setBackToShowViewSelect];
    }else{
        [cell setBackToShowViewNormal];}
    
//    [self.resultDatas addObject:model];
    
}

@end
