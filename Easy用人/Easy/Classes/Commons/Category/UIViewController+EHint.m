//
//  UIViewController+EHint.m
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "UIViewController+EHint.h"


NSInteger const KEHintTag = 666;
NSInteger const KEHintDateTag = 777;

static void *boxSelect = &boxSelect;
static void *update = &update;
static void *cancel = &cancel;

static void *beginL = &beginL;
static void *endL = &endL;
static void *beginD = &beginD;
static void *endD = &endD;
static void *isEnd = &isEnd;
static void *JXDatePicker = &JXDatePicker;
static void *dateComplete = &dateComplete;


@interface UIViewController()
@property (nonatomic, strong) UIButton *boxSelectBtn;
@property (nonatomic, copy) void(^updateBlock)(void);
@property (nonatomic, copy) void(^cancelBlock)(BOOL);

/// 日期选择
@property (nonatomic, strong) UILabel *beginLabel;
@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) BOOL isEndDate;
@property (nonatomic, strong) JXDatePickerView *datepicker;
@property (nonatomic, copy) void(^dateCompleteBlock)(NSDate *beginDate,NSDate *endDate);

@end
@implementation UIViewController (EHint)

#pragma mark - *** setter/getter
- (void)setIsEndDate:(BOOL)isEndDate{
    objc_setAssociatedObject(self, &isEnd, @(isEndDate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isEndDate{
    return [objc_getAssociatedObject(self, &isEnd) boolValue];
}

- (void)setEndDate:(NSDate *)endDate{
    objc_setAssociatedObject(self, &endD, endDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)endDate{
    return objc_getAssociatedObject(self, &endD);
}

- (void)setBeginDate:(NSDate *)beginDate{
     objc_setAssociatedObject(self, &beginD, beginDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)beginDate{
    return objc_getAssociatedObject(self, &beginD);
}

- (void (^)(NSDate *, NSDate *))dateCompleteBlock{
    return objc_getAssociatedObject(self, &dateComplete);
}

- (void)setDateCompleteBlock:(void (^)(NSDate *, NSDate *))dateCompleteBlock{
      objc_setAssociatedObject(self, &dateComplete, dateCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (JXDatePickerView *)datepicker{
    
    JXWeak(self);
    JXDatePickerView *picker = objc_getAssociatedObject(self, &JXDatePicker);
    if (picker == nil) {
        
        picker = [[JXDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
            if (weakself.isEndDate) {
                weakself.endDate = selectDate;
                weakself.endLabel.text = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            }else{
                weakself.beginDate = selectDate;
                weakself.beginLabel.text = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            }
            
        }];
        picker.dateLabelColor = [UIColor orangeColor];//年-月-日-时-分 颜色
        picker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        picker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
    }
    return picker;
}

- (void)setDatepicker:(JXDatePickerView *)datepicker{
    objc_setAssociatedObject(self, &JXDatePicker, datepicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)endLabel{
    UILabel *label = objc_getAssociatedObject(self, &endL);
    
    if (label == nil) {
        label = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#bfbfbf"] text:@"结束时间" textAlignment:NSTextAlignmentCenter];
        label.borderColor = [UIColor colorWithHexString:@"#d2d2d2"].CGColor;
        label.borderWidth = 1;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateEndAction)];
        [label addGestureRecognizer:tap];
        self.endLabel = label;
    }
    
    return label;
}

- (void)setEndLabel:(UILabel *)endLabel{
    objc_setAssociatedObject(self, &endL, endLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UILabel *)beginLabel{
    UILabel *label = objc_getAssociatedObject(self, &beginL);
    
    if (label == nil) {
        label = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#bfbfbf"] text:@"开始时间" textAlignment:NSTextAlignmentCenter];
        label.borderColor = [UIColor colorWithHexString:@"#d2d2d2"].CGColor;
        label.borderWidth = 1;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateBeginAction)];
        [label addGestureRecognizer:tap];
        self.beginLabel = label;
    }
    
    return label;
}

- (void)setBeginLabel:(UILabel *)beginLabel{
    objc_setAssociatedObject(self, &beginL, beginLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setUpdateBlock:(void (^)(void))updateBlock{
    objc_setAssociatedObject(self, &update, updateBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))updateBlock{
    return objc_getAssociatedObject(self, &update);
}


- (void)setCancelBlock:(void (^)(BOOL))cancelBlock{
     objc_setAssociatedObject(self, &cancel, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(BOOL))cancelBlock{
    return objc_getAssociatedObject(self, &cancel);
}

- (UIButton *)boxSelectBtn{
    UIButton *btn = objc_getAssociatedObject(self, &boxSelect);
    
    if (btn == nil) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tishi-gou"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"tishi"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(boxSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        self.boxSelectBtn = btn;
    }
    
    return btn;
}

- (void)setBoxSelectBtn:(UIButton *)boxSelectBtn{
    objc_setAssociatedObject(self, &boxSelect, boxSelectBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - *** Public Method
/**
 提示新版本
 */

/**
 提示新版本
 
 @param describe 描述详情
 @param isShowNeverUpdate 是否显示不再更新
 @param cancelBlock 取消回调
 @param updateBlock 更新回调
 */
- (void)jx_showNewVersionWithDes:(NSString *)describe
               isShowNeverUpdate:(BOOL)isShowNeverUpdate
                     cancelBlock:(void(^)(BOOL isNever))cancelBlock
                     updateBlock:(void(^)(void))updateBlock{
    
    self.updateBlock = updateBlock;
    self.cancelBlock = cancelBlock;
    
    UIView *coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.tag = KEHintTag;
    coverView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
    
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.cornerRadius = 3;
    [coverView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(coverView);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(305), E_RealHeight(170)));
    }];
    
    
    UILabel *hintLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] textColor:[UIColor colorWithHexString:@"#2b2b2b"] text:@"有新版本" textAlignment:0];
    [bgView addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(E_RealWidth(16));
        make.height.mas_equalTo(E_RealHeight(40));
        make.top.mas_equalTo(E_RealHeight(5));
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#ffbf00"];
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(bgView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(hintLabel.mas_bottom);
    }];
    
    UILabel *lable1 = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#6d6d6d"] text:describe textAlignment:0];
    [bgView addSubview:lable1];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line).offset(E_RealHeight(15));
        make.left.mas_equalTo(hintLabel);
        make.right.mas_equalTo(bgView.mas_right).offset(-E_RealWidth(16));
        make.height.mas_equalTo(E_RealHeight(30));
    }];
    
        
    /// 不再更新
    [bgView addSubview:self.boxSelectBtn];
    [self.boxSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hintLabel);
        make.top.mas_equalTo(lable1.mas_bottom).offset(E_RealHeight(5));
        make.width.height.mas_equalTo(E_RealWidth(15));
    }];
    
    UILabel *notLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#747474"] text:@"不再提示" textAlignment:0];
    [bgView addSubview:notLabel];
    [notLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.boxSelectBtn);
        make.left.mas_equalTo(self.boxSelectBtn.mas_right).offset(E_RealWidth(10));
    }];
    
    // 是否显示不再更新
    self.boxSelectBtn.hidden = !isShowNeverUpdate;
    notLabel.hidden = !isShowNeverUpdate;
    
    
    /// 取消 | 立即更新
    UIButton *cancelBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor colorWithHexString:@"#ffbf00"] selectColor:nil title:@"取消" nornamlImageName:nil selectImageName:nil textAlignment:0 target:self action:@selector(cancelAction)];
    [cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ededed"]] forState:UIControlStateHighlighted];
    [bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(bgView);
        make.width.mas_equalTo(E_RealWidth(305 * 0.5));
        make.top.mas_equalTo(notLabel.mas_bottom).offset(E_RealHeight(10));
    }];
    
    UIButton *updateBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor colorWithHexString:@"#ffbf00"] selectColor:nil title:@"立即更新" nornamlImageName:nil selectImageName:nil textAlignment:0 target:self action:@selector(updateAction)];
    [updateBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [updateBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ededed"]] forState:UIControlStateHighlighted];
    [bgView addSubview:updateBtn];
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(bgView);
        make.width.mas_equalTo(E_RealWidth(305 * 0.5));
        make.top.mas_equalTo(notLabel.mas_bottom).offset(E_RealHeight(10));
    }];
    
    
    
}

/**
 提示手机号相同
 */
- (void)jx_showSamePhone{
    UIView *coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.tag = KEHintTag;
    coverView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.cornerRadius = 3;
    [coverView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(coverView);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(305), E_RealHeight(154)));
    }];
    
    
    UILabel *hintLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#464646"] text:@"该手机号与当前绑定的手机号相同" textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(E_RealWidth(12));
        make.right.mas_equalTo(bgView.mas_right).offset(-E_RealWidth(12)); make.top.mas_equalTo(bgView).offset(E_RealHeight(39));
    }];
    
    
    UIButton *sureBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor colorWithHexString:@"#ffbf00"] selectColor:nil title:@"确定" nornamlImageName:nil selectImageName:nil textAlignment:0 target:self action:@selector(removeAction)];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ededed"]] forState:UIControlStateHighlighted];
    [bgView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView.mas_right).offset(-E_RealWidth(22));
        make.top.mas_equalTo(hintLabel.mas_bottom).offset(E_RealHeight(61));
        
    }];
    
    
}

- (void)jx_showDataPickerWithCompleteBlock:(void(^)(NSDate *beginDate, NSDate *endDate))completeBlock{
    
    self.dateCompleteBlock = completeBlock;
    
    UIView *coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.tag = KEHintDateTag;
    coverView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
    
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [coverView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(coverView);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(285), E_RealHeight(150)));
    }];
    
    
    /// 开始结束日期
    CGFloat labelW = E_RealWidth(100);
    CGFloat margin = (E_RealWidth(285) - labelW * 2 - E_RealWidth(28)) * 0.5;
    [bgView addSubview:self.beginLabel];
    [self.beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(labelW, E_RealHeight(30)));
        make.left.mas_equalTo(bgView).offset(margin);
        make.centerY.mas_equalTo(bgView);
    }];
    
    UILabel *zLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#7c7c7c"] text:@"至" textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:zLabel];
    [zLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.mas_equalTo(self.beginLabel);
        make.left.mas_equalTo(self.beginLabel.mas_right);
        make.width.mas_equalTo(E_RealWidth(28));
    }];
    
    
    [bgView addSubview:self.endLabel];
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(labelW, E_RealHeight(30)));
        make.left.mas_equalTo(zLabel.mas_right);
        make.centerY.mas_equalTo(bgView);
    }];
    
    
    /// 今日按钮
    UIButton *todayBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] normalColor:[UIColor colorWithHexString:@"#ffbf00"] selectColor:nil title:@"今日" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(todayAction)];
    todayBtn.cornerRadius = E_RealHeight(25/2);
    todayBtn.borderWidth = 1;
    todayBtn.borderColor = [UIColor colorWithHexString:@"#ffbf00"].CGColor;
    [bgView addSubview:todayBtn];
    [todayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(E_RealHeight(25));
        make.left.mas_equalTo(self.beginLabel);
        make.bottom.mas_equalTo(self.beginLabel.mas_top).offset(-E_RealHeight(10));
        make.width.mas_equalTo(E_RealWidth(45));
    }];
    
    
    UIButton *sureBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor whiteColor] selectColor:nil title:@"确定" nornamlImageName:nil selectImageName:nil textAlignment:0 target:self action:@selector(dateSureAction)];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffcc36"]] forState:UIControlStateNormal];
    [bgView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(bgView);
        make.height.mas_equalTo(E_RealHeight(44));
        
    }];
    
    
    /// 关闭按钮
    UIImageView *closeImageView = [[UIImageView alloc]init];
    closeImageView.image = [UIImage imageNamed:@"date_Close"];
    closeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateRemove)];
    [closeImageView addGestureRecognizer:closeTap];
    [bgView addSubview:closeImageView];
    [closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView).offset(-E_RealWidth(10));
        make.top.mas_equalTo(E_RealHeight(10));
        make.width.height.mas_equalTo(E_RealWidth(16));
    }];
    
}

#pragma mark - *** Actions
#pragma mark - date
- (void)dateEndAction{
    self.isEndDate = YES;
    [self.datepicker show];
}
- (void)dateBeginAction{
    self.isEndDate = NO;
    [self.datepicker show];
}

- (void)dateCloseAction{
    [self dateRemove];
}

- (void)dateSureAction{
    if (self.dateCompleteBlock) {
        self.dateCompleteBlock(self.beginDate, self.endDate);
    }
    [self dateRemove];
}
- (void)todayAction{
    self.beginDate = self.endDate = [NSDate date];
    self.beginLabel.text = self.endLabel.text = [self.endDate stringWithFormat:@"yyyy-MM-dd"];
}


- (void)dateRemove{
    
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == KEHintDateTag) {
            [view removeFromSuperview];
            self.beginLabel = nil;
            self.endLabel = nil;
            self.datepicker = nil;
            self.beginDate = nil;
            self.endDate = nil;
            self.dateCompleteBlock = nil;
        }
    }
}

#pragma mark - vision / samePhone
- (void)updateAction{
    if (self.updateBlock) {
        self.updateBlock();
    }
     [self removeAction];
}

- (void)cancelAction{
    
    if (self.cancelBlock) {
        self.cancelBlock(self.boxSelectBtn.selected);
    }
    [self removeAction];
}

- (void)boxSelectAction:(UIButton *)button{
    button.selected = !button.selected;
}

- (void)removeAction{
    
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == KEHintTag) {
            [view removeFromSuperview];
            
            self.boxSelectBtn = nil;
            self.updateBlock = nil;
            self.cancelBlock = nil;
        }
    }
}
@end
