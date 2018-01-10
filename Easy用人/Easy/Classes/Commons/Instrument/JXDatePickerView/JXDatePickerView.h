//
//  JXDatePickerView.h
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+DatePicker.h"

/**
 *  弹出日期类型
 */
typedef enum{
    DateStyleShowYearMonthDayHourMinute  = 0,//年月日时分
    DateStyleShowMonthDayHourMinute,//月日时分
    DateStyleShowYearMonthDay,//年月日
    DateStyleShowMonthDay,//月日
    DateStyleShowHourMinute//时分
    
}JXDateStyle;

@interface JXDatePickerView : UIView
/**
 *  确定按钮颜色
 */
@property (nonatomic, strong) UIColor *doneButtonColor;
/**
 *  年-月-日-时-分 文字颜色(默认橙色)
 */
@property (nonatomic, strong) UIColor *dateLabelColor;
/**
 *  滚轮日期颜色(默认黑色)
 */
@property (nonatomic, strong) UIColor *datePickerColor;

/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
@property (nonatomic, retain) NSDate *maxLimitDate;
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
@property (nonatomic, retain) NSDate *minLimitDate;

/**
 *  大号年份字体颜色(默认灰色)想隐藏可以设置为clearColor
 */
@property (nonatomic, retain) UIColor *yearLabelColor;

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(JXDateStyle)datePickerStyle
                    CompleteBlock:(void(^)(NSDate *))completeBlock;

/**
 滚动到指定的的日期
 */
- (instancetype)initWithDateStyle:(JXDateStyle)datePickerStyle
                     scrollToDate:(NSDate *)scrollToDate
                    CompleteBlock:(void(^)(NSDate *))completeBlock;


- (void)show;

@end
