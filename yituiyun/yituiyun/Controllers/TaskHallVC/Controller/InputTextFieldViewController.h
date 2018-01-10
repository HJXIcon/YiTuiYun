//
//  InputTextFieldViewController.h
//  yituiyun
//
//  Created by 张强 on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"
@protocol InputTextFieldViewControllerDelegate <NSObject>

- (void)inputTextFieldString:(NSString *)string WithIndex:(NSIndexPath *)index;

@end

@interface InputTextFieldViewController : ZQ_ViewController
@property (weak, nonatomic) id <InputTextFieldViewControllerDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *index;

- (instancetype)initWithTitle:(NSString *)title;
@end
