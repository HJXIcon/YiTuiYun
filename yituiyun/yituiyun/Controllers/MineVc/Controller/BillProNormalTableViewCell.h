//
//  BillProNormalTableViewCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/23.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextFieldBlock)(NSString *string);
@interface BillProNormalTableViewCell : UITableViewCell
@property(nonatomic,copy)  TextFieldBlock textfieldblock;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;

@end
