//
//  LHKMapPopView.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHKMapAnnotation.h"

@protocol LHKMapPopViewDelegate <NSObject>

-(void)mapPopViewBtnClick:(LHKMapAnnotation *)model;

@end

@interface LHKMapPopView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

/**12 */
@property(nonatomic,strong) LHKMapAnnotation * annotation;

/**代理 */
@property(nonatomic,assign)id<LHKMapPopViewDelegate>  delegate;

+(instancetype)popView;
@end
