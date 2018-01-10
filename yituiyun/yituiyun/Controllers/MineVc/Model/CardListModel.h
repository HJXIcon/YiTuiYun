//
//  CardListModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardListModel : NSObject
@property(nonatomic,strong) NSString * cardid;
@property(nonatomic,strong) NSString * bankName;
@property(nonatomic,strong) NSString * cardcode;
@property(nonatomic,strong) NSString * detailBranch;
@property(nonatomic,strong) NSString * uname;
@property(nonatomic,strong) NSString * card_phone;
@property(nonatomic,strong) NSString * cert_id;
@property(nonatomic,strong) NSString * bank_code;


//支付宝
@property(nonatomic,strong) NSString * aliname;
@property(nonatomic,strong) NSString * alicode;
@property(nonatomic,assign)NSString*  isChose;



@end
