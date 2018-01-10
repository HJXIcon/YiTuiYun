//
//  ZQLabelAndImageButton.h
//  yituiyun
//
//  Created by 张强 on 16/1/11.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQLabelAndImageButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *label;
- (void)isShowImage:(NSInteger)isImage;
@end
