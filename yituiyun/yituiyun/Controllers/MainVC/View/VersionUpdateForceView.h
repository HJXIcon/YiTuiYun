//
//  VersionUpdateForceView.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VersionUpdateForceViewDelegate <NSObject>

-(void)forceViewBtnClick;

@end

@interface VersionUpdateForceView : UIView
+(instancetype)forceView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
/**代理 */
@property(nonatomic,assign) id<VersionUpdateForceViewDelegate> delegate;
@end
