//
//  BillSectionFootOrHeadView.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/23.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillSectionFootOrHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;

@property (weak, nonatomic) IBOutlet UIView *panView;
@property (weak, nonatomic) IBOutlet UILabel *panoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *panDesView;
+(instancetype)footOrHeadView;


@end
