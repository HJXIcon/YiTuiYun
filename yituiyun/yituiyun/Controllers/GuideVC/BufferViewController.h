//
//  BufferViewController.h
//  yituiyun
//
//  Created by NIT on 15/6/23.
//  Copyright (c) 2015年 ZQ. All rights reserved.
//

#import "ZQ_ViewController.h"

@class AppDelegate;
@class MainViewController;
@class  GuideViewController;

@interface BufferViewController : ZQ_ViewController
-(void)startAnimation;
-(void)stopAnimation;
-(void)showErrorMess:(NSString *)mess;
@end
