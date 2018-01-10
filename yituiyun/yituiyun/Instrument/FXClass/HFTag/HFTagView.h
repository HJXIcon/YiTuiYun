//
//  HFTagView.h
//  ChangeClothes
//
//  Created by joyman04 on 15/10/23.
//  Copyright © 2015年 BFHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFTagButton.h"
#import "HFTagModel.h"

@class HFTagView;

@protocol HFTagViewDelegate <NSObject>

@optional
/** HFTagModel */
-(void)selectTagWithTagView:(HFTagView*)tagView withTagModels:(NSMutableArray*)tagModels;

@end

@interface HFTagView : UIView

@property (nonatomic,copy) NSString* keyId;

@property (nonatomic,copy) NSString* optionName;

@property (nonatomic,assign) id <HFTagViewDelegate> delegate;

- (instancetype)initWithOptionName:(NSString*)optionName withMaxNum:(NSInteger)maxNum;

- (instancetype)initWithKeyId:(NSString*)keyId withMaxNum:(NSInteger)maxNum;

/** 显示自己 */
-(void)showSelf;
/** 隐藏 */
-(void)hide;

@end
