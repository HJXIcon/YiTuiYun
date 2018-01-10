//
//  LHKBasicVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/30.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKBasicVc.h"

@interface LHKBasicVc ()

@end

@implementation LHKBasicVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"NodataTishi"];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(WRadio(55)));
        make.height.mas_equalTo(@(HRadio(65)));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    self.view.backgroundColor = UIColorFromRGBString(@"0xededed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
