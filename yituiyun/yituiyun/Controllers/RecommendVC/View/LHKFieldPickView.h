//
//  LHKFieldPickView.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHKFieldPickView;

@protocol LHKFieldPickViewDelegate <NSObject>

-(void)fieldPickViewFieldSelect:(NSInteger)row withFieldView:(LHKFieldPickView*)fieldView;

@end

@interface LHKFieldPickView : UIView

@property (weak, nonatomic) IBOutlet UIPickerView *filedPickView;
@property(nonatomic,strong) NSArray * dataArray;

@property(nonatomic,assign)id<LHKFieldPickViewDelegate> delegate;

+(instancetype)pickView;
@end
