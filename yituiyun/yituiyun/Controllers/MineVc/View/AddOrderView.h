//
//  AddOrderView.h
//  yituiyun
//
//  Created by yituiyun on 2017/7/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NumberBlock)(NSString *str);
typedef void(^PriceBlock)(NSString *str);

@interface AddOrderView : UIView
+(instancetype)orderView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property(nonatomic,copy) NumberBlock numberblock;
@property(nonatomic,copy) PriceBlock priceblock;

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *orginPriceLabel;

@end
