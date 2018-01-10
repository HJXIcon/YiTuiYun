//
//  PlayVideoViewController.h
//  yituiyun
//
//  Created by 张强 on 2017/2/8.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@protocol PlayVideoViewControllerDelegate <NSObject>

- (void)deleteVideoWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface PlayVideoViewController : ZQ_ViewController
@property (weak, nonatomic) id <PlayVideoViewControllerDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
- (instancetype)initWithVideo:(NSString *)videoUrl;
- (void)showDeleteButton;

@end
