//
//  FXInPutViewController.h
//  yituiyun
//
//  Created by fx on 16/10/17.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZQ_ViewController.h"

@protocol FXInPutViewControllerDelegate <NSObject>

- (void)saveTextWith:(NSString *)text;

@end

@interface FXInPutViewController : ZQ_ViewController

@property (nonatomic, copy) NSString *textStr;

@property (nonatomic, assign) id<FXInPutViewControllerDelegate> delegate;

@end
