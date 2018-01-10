//
//  ShowImageViewController.h
//  tongmenyiren
//
//  Created by 张强 on 16/8/26.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@protocol ShowImageViewControllerDelegate;

@interface ShowImageViewController : ZQ_ViewController
@property (weak, nonatomic) id <ShowImageViewControllerDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property(nonatomic,assign)BOOL  hideRightBtn;
- (instancetype)initWithImageArray:(NSMutableArray *)imageArray;
- (void)seleImageLocation:(NSInteger)location;
- (void)showDeleteButton;
- (void)showMoreButton;
@end

@protocol ShowImageViewControllerDelegate <NSObject>

- (void)deleteImageTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath;
- (void)refreshImageUrl:(NSString *)imageUrl;

@end
