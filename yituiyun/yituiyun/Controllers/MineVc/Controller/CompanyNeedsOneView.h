//
//  CompanyNeedsOneView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TimeBlock)(UIButton *btn);
typedef void(^TypeBlock) (UIButton *btn);
typedef void(^PriceTiShiBlock) ();

typedef void(^DeleteBlock)(UIButton *btn);

typedef void(^LogoBlock) (UIButton *btn);


@interface CompanyNeedsOneView : UIView
+(instancetype)oneView;
@property(nonatomic,copy)TimeBlock  timeBlock;
@property(nonatomic,copy)TypeBlock  typeBlock;
@property(nonatomic,copy)PriceTiShiBlock  tishiBlock;
@property(nonatomic,copy)LogoBlock   logoblock;
@property(nonatomic,copy)DeleteBlock   deleteblock;


@property (weak, nonatomic) IBOutlet UITextField *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeStrLabel;
@property (weak, nonatomic) IBOutlet UITextField *total_singleLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *endDataBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
