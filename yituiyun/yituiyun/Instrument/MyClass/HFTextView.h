//
//  HFTextView.h
//  EasyRepair
//
//  Created by joyman04 on 16/3/29.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HFTextViewDelegate <NSObject>

- (void)clickHFTextView:(NSString *)clickString;

- (void)longClickHFTextView:(NSString *)clickString;


@end

@interface HFTextView : UIView

#define PlaceHolder @" "
#define EmotionItemPattern    @"\\[em:(\\d+):\\]"
#define AttributedImageNameKey      @"ImageName"

#define limitline 4

#define FontHeight                  SubTitleFontSize
#define ImageLeftPadding            2.0
#define ImageTopPadding             3.0
#define FontSize                    FontHeight
#define LineSpacing                 10.0
#define EmotionImageWidth           FontSize


#define TitleFontSize 16

#define SubTitleFontSize 15

#define ContentFontSize 14

#define TimeFontSize 13


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色

#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

@property (nonatomic,strong) NSAttributedString *attrEmotionString;
@property (nonatomic,strong) NSArray *emotionNames;
@property (nonatomic,assign) BOOL isDraw;
@property (nonatomic,assign) BOOL isFold;//是否折叠
@property (nonatomic,strong) NSMutableArray *attributedData;
@property (nonatomic,assign) int textLine;
@property (nonatomic,assign) id <HFTextViewDelegate> delegate;
@property (nonatomic,assign) CFIndex limitCharIndex;//限制行的最后一个char的index
@property (nonatomic,assign) BOOL canClickAll;//是否可点击整段文字
@property (nonatomic,assign) BOOL allClickShowView;//点击全部时是否显示View;

@property (nonatomic,strong) UIColor *textColor;

- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString;

- (NSInteger)getTextLines;

- (CGFloat)getTextHeight;

@end
