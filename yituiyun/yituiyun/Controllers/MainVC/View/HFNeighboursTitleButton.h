//
//  HFNeighboursTitleButton.h
//  CommunityBBS
//
//  Created by joyman04 on 16/3/7.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HFNeighboursTitleButtonDelegate <NSObject>

- (void)neighboursTitleSelectWithIndex:(NSInteger)index;

@end

@interface HFNeighboursTitleButton : UIScrollView

//type为1 文字模式 type为2 图片模式 btnHeight 传0为使用默认
- (id)initWithFrame:(CGRect)frame withType:(NSInteger)type withLineInButtonDown:(NSInteger)isInDown withWantBtnHeight:(CGFloat)btnHeight;
//文字模式一维数组 图片模式二维数组
@property (nonatomic,strong) NSArray* titles;

@property (nonatomic, assign) id <HFNeighboursTitleButtonDelegate> neighboursDelegate;

@property (nonatomic,copy) NSString* notification;

-(void)changeTitleButtonIndex:(NSInteger)index;

@end
