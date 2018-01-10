//
//  MyWalletTishi.h
//  yituiyun
//
//  Created by yituiyun on 2017/10/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ProtocolClickBlock) ();
@interface MyWalletTishi : UIView
@property(nonatomic,copy)ProtocolClickBlock  block;
@end
