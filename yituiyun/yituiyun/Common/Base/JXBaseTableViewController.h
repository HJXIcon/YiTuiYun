//
//  JXBaseTableViewController.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/12.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXNoDataImageView.h"
@interface JXBaseTableViewController : UITableViewController
@property(nonatomic,strong) JXNoDataImageView *nodataImageView;
- (void)loadHeaderAction;
- (void)loadFooterAction;
- (void)loadDataSuccess;
@end
