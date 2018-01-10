//
//  InputTextViewController.h
//  yituiyun
//
//  Created by 张强 on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@protocol InputTextViewControllerDelegate <NSObject>

- (void)inputTextViewString:(NSString *)string WithIndex:(NSInteger )index;

@end

@interface InputTextViewController : ZQ_ViewController
@property (weak, nonatomic) id <InputTextViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger index;

- (instancetype)initWithTitle:(NSString *)title WithDesc:(NSString *)desc;
@end
