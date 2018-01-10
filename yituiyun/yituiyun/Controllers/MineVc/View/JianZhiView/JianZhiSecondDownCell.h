//
//  JianZhiSecondDownCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SexBlock)(UIButton *btn);
typedef void(^TextFieldBlock1)(NSString *str);
typedef void(^TextFieldBlock2)(NSString *str);


@interface JianZhiSecondDownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *TextField2;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIView *panView;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property(nonatomic,copy)SexBlock sexblock;
@property(nonatomic,copy) TextFieldBlock1 textfieldblock1;
@property(nonatomic,copy) TextFieldBlock2 textfieldblock2;

@end
