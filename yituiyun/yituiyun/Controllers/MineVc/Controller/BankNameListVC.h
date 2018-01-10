//
//  BankNameListVC.h
//  yituiyun
//
//  Created by yituiyun on 2017/7/4.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlankNameBlock)(NSString *bankname,NSString *bankid);
@interface BankNameListVC : UIViewController

@property(nonatomic,copy)BlankNameBlock  blanknameblock;


@end
