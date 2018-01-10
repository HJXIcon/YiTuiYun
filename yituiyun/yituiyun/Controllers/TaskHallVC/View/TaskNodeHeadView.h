//
//  TaskNodeHeadView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHKNodeButton.h"

@interface TaskNodeHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *hourTime;
@property (weak, nonatomic) IBOutlet UILabel *miuteTime;

@property (weak, nonatomic) IBOutlet UILabel *secondTime;

@property (weak, nonatomic) IBOutlet UIButton *arrorw1Btn;

@property (weak, nonatomic) IBOutlet UIButton *arrorw2Btn;

@property (weak, nonatomic) IBOutlet LHKNodeButton *FistBtn;
@property (weak, nonatomic) IBOutlet UIView *timePanLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet LHKNodeButton *SecondBtn;
@property (weak, nonatomic) IBOutlet LHKNodeButton *threeBtn;

/**字典 */
@property(nonatomic,strong) NSDictionary * dict;


+(instancetype)nodeHeadView;

-(void)closeTime;
@end
