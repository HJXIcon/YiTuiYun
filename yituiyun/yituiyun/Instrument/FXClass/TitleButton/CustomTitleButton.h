//
//  CustomTitleButton.h
//  ChangeClothes
//
//  Created by hslhzj@163.com on 15/7/29.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTitleDelegate <NSObject>

- (void)buttonPresedInTitle:(NSInteger)index;

@end

@interface CustomTitleButton : UIView

//type为1 文字模式 type为2 图片模式 btnHeight 传0为使用默认
- (id)initWithFrame:(CGRect)frame withType:(NSInteger)type withLineInButtonDown:(NSInteger)isInDown withWantBtnHeight:(CGFloat)btnHeight;
//文字模式一维数组 图片模式二维数组
@property (nonatomic,strong) NSArray* titleArr;

@property (nonatomic, weak) id <CustomTitleDelegate> delegate;

@property (nonatomic,copy) NSString* notification;

-(void)changeTitleButtonIndex:(NSInteger)index;

@end
