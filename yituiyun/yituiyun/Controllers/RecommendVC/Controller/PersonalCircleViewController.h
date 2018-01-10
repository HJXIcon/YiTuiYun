//
//  PersonalCircleViewController.h
//  yituiyun
//
//  Created by 张强 on 2017/1/4.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@interface PersonalCircleViewController : ZQ_ViewController
@property (nonatomic, copy) NSString *buddyListString;
- (instancetype)initWithWhere:(NSInteger)where;
- (void)tableViewDataReload;
@end
