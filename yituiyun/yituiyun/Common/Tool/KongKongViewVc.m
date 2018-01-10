//
//  KongKongViewVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/13.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "KongKongViewVc.h"

@interface KongKongViewVc ()
@property(nonatomic,strong) UIImageView * nodataImageView;

@end

@implementation KongKongViewVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [self.view addSubview:self.nodataImageView];
    
   
    
    
    //添加站位图片
    
    [self.nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(WRadio(55)));
        make.height.mas_equalTo(@(HRadio(65)));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(HRadio(80));
    }];
    
}

-(UIImageView *)nodataImageView{
    if (_nodataImageView == nil) {
        _nodataImageView = [[UIImageView alloc]init];
        _nodataImageView.image = [UIImage imageNamed:@"NodataTishi"];
    }
    return _nodataImageView;
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
