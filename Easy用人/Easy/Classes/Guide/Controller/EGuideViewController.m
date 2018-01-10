//
//  EGuideViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/19.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EGuideViewController.h"
#import "EGuideCell.h"
#import <YYImage.h>

/** 判断是否第一次登录 */
NSString * const EGuidePageKey = @"EGuidePageKey";

@interface EGuideViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *enterBtn;
@end

@implementation EGuideViewController
- (UIButton *)enterBtn{
    if (_enterBtn == nil) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.view.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[EGuideCell class] forCellWithReuseIdentifier:@"EGuideCell"];
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
}


#pragma mark - *** enterAction
- (void)enterAction{
    [UIApplication sharedApplication].keyWindow.rootViewController = [EControllerManger chooseRootController];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EGuideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGuideCell" forIndexPath:indexPath];
    NSArray *imageNames = @[@"EGuide1.gif",@"EGuide2.gif"];
    cell.imageView.image = [YYImage imageNamed:imageNames[indexPath.row]];
    
    if (indexPath.row == imageNames.count - 1) {
        if (![cell.contentView.subviews containsObject:self.enterBtn]) {
            [cell.contentView addSubview:self.enterBtn];
            [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell.contentView);
                make.bottom.mas_equalTo(cell.contentView.mas_bottom).offset(-50);
                make.size.mas_equalTo(CGSizeMake(100, 45));
            }];
        }
    }
    return cell;
}


@end
