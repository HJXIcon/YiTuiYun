//
//  JianZhiFistCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/1.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ListBlock)(UIButton *btn);
typedef void(^AddressBlock)(UIButton *btn);
typedef void(^TextFieldBlock)(NSString *str);


@interface JianZhiFistCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;

@property (weak, nonatomic) IBOutlet UIButton *descBtn;
@property (weak, nonatomic) IBOutlet UILabel *Titlelabel;
@property(nonatomic,copy) ListBlock listblock;
@property(nonatomic,copy) AddressBlock addressblock;
@property(nonatomic,copy) TextFieldBlock textfieldblock;
@end
