//
//  ELaunchAdView.m
//  Easy
//
//  Created by yituiyun on 2017/12/19.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ELaunchAdView.h"
#import <YYImage.h>


@interface ELaunchAdView()
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic,copy   ) dispatch_source_t dispatchTimer;

@end

@implementation ELaunchAdView
- (YYAnimatedImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[YYAnimatedImageView alloc]init];
        
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.imageView];
        YYImage *image = [YYImage imageNamed:@"ELaunch.gif"];
        self.imageView.image = image;
    
    }
    return self;
}



#pragma mark - 开始计时
- (void)dispath_Tiemr{
     //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建timer
    _dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置.1s触发一次，0s的误差
    dispatch_source_set_timer(_dispatchTimer, dispatch_walltime(NULL, 0), 0.1 * NSEC_PER_SEC, 0);
    
    __block CGFloat duration = 2.3;
    
    dispatch_source_set_event_handler(_dispatchTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(duration <= 0){
                dispatch_source_cancel(_dispatchTimer);
                if (self.launchEndBlock) {
                    self.launchEndBlock();
                }
                
                [self removeFromSuperview];
                
            }else{
                
                duration -= 0.1;
            }
            
        });
    });
    
    //开始执行dispatch源
    dispatch_resume(_dispatchTimer);
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    [self.imageView startAnimating];
    [self dispath_Tiemr];
}



@end
