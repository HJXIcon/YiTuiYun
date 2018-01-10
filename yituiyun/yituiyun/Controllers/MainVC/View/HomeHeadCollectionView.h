//
//  HomeHeadCollectionView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/12.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homeCollectionCell.h"
#import "LHKLeftButoon.h"



@protocol HomeHeadCollectionViewDelegate <NSObject>

-(void)collectionViewHeadClick:(NSDictionary *)dict;

@end


@interface HomeHeadCollectionView : UIView
+(instancetype)collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (nonatomic, copy) void(^loadDataSucess)(NSInteger);
/**代理 */
@property(nonatomic,assign)id<HomeHeadCollectionViewDelegate>  delegate;

@end
