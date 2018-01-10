//
//  JianZhiSecondupCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/8/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextViewBlock)(NSString *str);

@interface JianZhiSecondupCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,copy) TextViewBlock texviewblock;

@end
