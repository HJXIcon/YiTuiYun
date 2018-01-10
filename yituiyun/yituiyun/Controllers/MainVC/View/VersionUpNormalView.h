//
//  VersionUpNormalView.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VersionUpNormalViewDelegate <NSObject>

-(void)normalViewBtnClick:(UIButton *)btn;

@end

@interface VersionUpNormalView : UIView
+(instancetype)normalView;
@property (weak, nonatomic) IBOutlet UIButton *tishiBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
/**代理 */
@property(nonatomic,assign) id<VersionUpNormalViewDelegate> delegate;
@end
