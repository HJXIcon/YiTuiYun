//
//  LHKAlterView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/23.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LHKAlterView : UIView
typedef void (^CancelBlock)(LHKAlterView *alterView);
typedef void (^MakeSureBlock)(LHKAlterView *alterView);

+(instancetype)alterView;
@property (weak, nonatomic) IBOutlet UIView *alterView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneSureBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoSureBtn;
@property(nonatomic,copy)CancelBlock  cancelblock;
@property(nonatomic,copy)MakeSureBlock  makesurelblock;
+(instancetype)alterViewWithTitle:(NSString *)titel andDesc:(NSString *)desc WithCancelBlock:(CancelBlock)cancelblock WithMakeSure:(MakeSureBlock)makesureblock;

+(instancetype)alterViewWithTitle:(NSString *)titel andDesc:(NSString *)desc WithMakeSure:(MakeSureBlock)makesureblock;

@end
