//
//  HomeHeadCollectionView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/12.
//  Copyright © 2017年 张强. All rights reserved.
//


#import "HomeHeadCollectionView.h"

@interface HomeHeadCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**nsmutableAray */
@property(nonatomic,strong) NSMutableArray * datas;

@end

@implementation HomeHeadCollectionView
-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"homeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"homeCollectionCell"];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.itemSize = CGSizeMake(ScreenWidth/4.0, HRadio(160)/2.0f);
    self.collectionView.collectionViewLayout = flow;
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    flow.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    [self labelArrayFromNetwork];
}
- (void)labelArrayFromNetwork
{
    [SVProgressHUD showWithStatus:@"标签加载中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keyid"] = @"3384";
    params[@"parentid"] = @"0";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=linkage.get"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (![ZQ_CommonTool isEmptyArray:responseObject]) {
            self.datas = responseObject;
            [self.collectionView reloadData];
            self.pageController.numberOfPages = self.datas.count/8;
            self.pageController.currentPageIndicatorTintColor = [UIColor redColor];
            self.pageController.pageIndicatorTintColor = [UIColor lightGrayColor];
            
            if (self.datas.count<=8) {
//                [self.pageController removeFromSuperview];
                self.pageController.hidden = YES;
            }
            if (self.loadDataSucess) {
                self.loadDataSucess(self.datas.count);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}


+(instancetype)collectionView{
    return [[[NSBundle mainBundle]loadNibNamed:@"HomeHeadView" owner:nil options:nil]lastObject];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    homeCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"homeCollectionCell" forIndexPath:indexPath];
    NSDictionary *dict = self.datas[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[NSString imagePathAddPrefix:dict[@"img"]]];
    [cell.goodIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.goodIcon.contentMode=UIViewContentModeScaleAspectFit;
    cell.goodName.text = dict[@"name"];
    
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger  index = scrollView.contentOffset.x/ScreenWidth;
    self.pageController.currentPage = index;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.datas[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(collectionViewHeadClick:)]) {
        [self.delegate collectionViewHeadClick:dict];
    }
    
    
}

@end
