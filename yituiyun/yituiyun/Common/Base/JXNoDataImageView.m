//
//  JXNoDataImageView.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXNoDataImageView.h"

@implementation JXNoDataImageView

-(UIImageView *)nodataImageView{
    if (_nodataImageView == nil) {
        _nodataImageView = [[UIImageView alloc]init];
        _nodataImageView.image = [UIImage imageNamed:@"NodataTishi"];
    }
    return _nodataImageView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromRGBString(@"0xededed");
        [self addSubview:self.nodataImageView];
        
        [self.nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(WRadio(55)));
            make.height.mas_equalTo(@(HRadio(65)));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(HRadio(80));
        }];
        
    }
    return self;
}
@end
