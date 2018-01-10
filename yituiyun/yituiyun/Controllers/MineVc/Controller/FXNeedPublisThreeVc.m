//
//  FXNeedPublisThreeVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "FXNeedPublisThreeVc.h"
#import "CompanyCollectionFootView.h"
#import "CompanyCollectionHeadView.h"
#import "CompanyThreeCollectionCell.h"
#import "FXPublishLabelVc.h"
#import "CompanyNeedModel.h"
#import "CompanyNeedscontainer.h"

@interface FXNeedPublisThreeVc ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *oneLable;

@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong) CompanyCollectionFootView * footView;

@end

@implementation FXNeedPublisThreeVc

#pragma mark - 懒加载

-(NSMutableArray *)datalabels{
    if (_datalabels == nil) {
        _datalabels = [NSMutableArray array];
    }
    return _datalabels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLableBorder:self.oneLable];
    [self setLableBorder:self.twoLabel];
    [self setLableBorder:self.threeLabel];
    [self setLableBorder:self.fourLabel];
    [self setLableBorder:self.fiveLabel];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.itemSize = CGSizeMake(ScreenWidth/2.0f-2, 44);
    self.collectionView.collectionViewLayout = flow;
    flow.footerReferenceSize = CGSizeMake(ScreenWidth, 44);
    flow.headerReferenceSize = CGSizeMake(ScreenWidth, 44);
    flow.minimumLineSpacing = 1;
    flow.minimumInteritemSpacing = 1;
    
    //注册头
    [self.collectionView registerNib:[UINib nibWithNibName:@"CompanyCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CompanyCollectionHeadView"];
    
    //注册cell
    [self.collectionView registerClass:[CompanyThreeCollectionCell class] forCellWithReuseIdentifier:@"CompanyThreeCollectionCell"];
    //注册foot
    
        [self.collectionView registerNib:[UINib nibWithNibName:@"CompanyCollectionFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CompanyCollectionFootView"];
   

    
}
-(void)setDescModel:(CompanyNeedDesc *)descModel{
    _descModel = descModel;
    if (descModel !=nil) {
       
        [self.collectionView reloadData];
        
        [self.datalabels removeAllObjects];
        if (descModel.setting.count>0) {
            for (NSDictionary *dict in descModel.setting) {
                CompanyNeedModel *model= [[CompanyNeedModel alloc]init];
                model.ID = dict[@"id"];
                model.fid=dict[@"fid"];
                model.name_zh = dict[@"name_zh"];
                [self.datalabels addObject:model];
            }
            
            if (self.isCanEding) {
                [NeedDataModel shareInstance].taskrequireArray = self.datalabels; 
            }
            
           
            [self.collectionView reloadData];
        }
    }

}
-(void)setLableBorder:(UILabel *)label{
             label.layer.borderWidth = 1;
             label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.cornerRadius = 16;
    label.clipsToBounds = YES;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datalabels.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CompanyNeedModel *model = self.datalabels[indexPath.row];
    
    CompanyThreeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CompanyThreeCollectionCell" forIndexPath:indexPath];

    cell.model = model;
    
    return cell;
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MJWeakSelf
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CompanyCollectionHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CompanyCollectionHeadView" forIndexPath:indexPath];
        return headView;
    }else{
        CompanyCollectionFootView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CompanyCollectionFootView" forIndexPath:indexPath];
        self.footView = footView;
        //foot的block
        footView.addBlock = ^{
//            [self.navigationController pushViewController:[FXPublishLabelVc new] animated:YES];
            
            FXPublishLabelVc *pub  = [[FXPublishLabelVc alloc]init];
            pub.qianmianDatas = weakSelf.datalabels;
            pub.block = ^(NSArray *datas) {
                
                [MobClick event:@"disanyetianjiayaoqiu"];
                [weakSelf.datalabels removeAllObjects];
                [weakSelf.datalabels addObjectsFromArray:datas];
                
                [NeedDataModel shareInstance].taskrequireArray = weakSelf.datalabels;
                [weakSelf.collectionView reloadData];
            };
            
            [self.contavC presentViewController:pub animated:YES completion:nil];
        };
        if (self.descModel) {
            if (self.isCanEding) {
               footView.hidden = NO;
            }else{
                footView.hidden = YES;
            }
            
        }else{
            footView.hidden = NO;
        }
        
        return footView;
        
    }
    return nil;
    
}
     

@end
