//
//  HFPickerView.h
//  EasyRepair
//
//  Created by joyman04 on 16/1/6.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFPickerViewModel.h"
#import "HFPickerViewSubModel.h"

@class HFPickerView;

@protocol HFPickerViewDelegate <NSObject>

@optional
//点击取消触发
-(void)cancelWithPickerView:(HFPickerView*)pickerView;
//完成选项选择
-(void)finishSelectWithPickerView:(HFPickerView*)pickerView withUpdata:(NSArray*)upData;
//完成时间选择
-(void)finishSelectWithPickerView:(HFPickerView*)pickerView withDate:(NSDate*)date;
//选项选择第一次获取数据,返回第一条作为默认数据
- (void)firstSelectItemWithPickerView:(HFPickerView*)pickerView withUpdata:(NSArray*)upData;

@end

@interface HFPickerView : UIView
@property (nonatomic,strong) UIView* backView;
@property (nonatomic,assign) id <HFPickerViewDelegate> delegate;

- (instancetype)initWithPickerMode:(UIDatePickerMode)pickerMode;

@property (nonatomic,strong) NSDate* minimumDate;

@property (nonatomic,strong) NSDate* maximumDate;

//走多级选择
- (instancetype)initWithKeyId:(NSString*)keyId pickerModels:(NSArray*)models;
//走单级选择
- (instancetype)initWithModel:(HFPickerViewModel*)model;

-(void)showSelf;

-(void)hideSelf;

@end
