//
//  HomeHeadSectionView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/5.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sectionBtnBlock) (NSInteger sectionindex);

@interface HomeHeadSectionView : UIView
/**sectionBlock */
@property(nonatomic,copy)sectionBtnBlock  s_block;
@property (weak, nonatomic) IBOutlet UIButton *fistBtn;

+(instancetype)sectionView;
@end
