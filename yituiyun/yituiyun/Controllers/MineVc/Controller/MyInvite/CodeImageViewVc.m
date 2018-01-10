//
//  CodeImageViewVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/19.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CodeImageViewVc.h"

@interface CodeImageViewVc ()

@end

@implementation CodeImageViewVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
}

- (IBAction)backup:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


@end
