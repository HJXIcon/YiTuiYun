//
//  LHKSellerWriteCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^TextBlock)(NSString *text);
typedef void (^FieldBlock)();
typedef void (^AginBtnBlock)();




@interface LHKSellerWriteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *fieldBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
//textfiled文字改变时传递的block
@property(nonatomic,copy)TextBlock textBlock;

//Field 文字改变时传递的block
@property(nonatomic,copy)FieldBlock  fieldBlock;

//againBtn 文字改变时传递的block
@property(nonatomic,copy)AginBtnBlock   aginBlock;


@end
