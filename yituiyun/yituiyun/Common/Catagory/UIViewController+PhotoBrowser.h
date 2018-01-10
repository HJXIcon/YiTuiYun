//
//  UIViewController+PhotoBrowser.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/8/31.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface UIViewController (PhotoBrowser)<MWPhotoBrowserDelegate>

@property(nonatomic, strong) NSArray <NSURL *>*photos;
//@property(nonatomic, assign) NSUInteger currentPhotoIndex;
//@property(nonatomic, strong) MWPhotoBrowser *browser;

- (void)pushPhotoBrowser:(NSArray <NSURL *>*)photos currentPhotoIndex:(NSUInteger)currentPhotoIndex;
@end
