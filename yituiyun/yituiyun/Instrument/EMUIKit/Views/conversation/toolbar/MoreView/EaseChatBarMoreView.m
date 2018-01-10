/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 50
#define INSETS 10
#define MOREVIEW_COL 4
#define MOREVIEW_ROW 2
#define MOREVIEW_BUTTON_TAG 1000

@implementation UIView (MoreView)

- (void)removeAllSubview
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end

@interface EaseChatBarMoreView ()<UIScrollViewDelegate>
{
    EMChatToolbarType _type;
    NSInteger _maxIndex;
}

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *audioCallButton;
@property (nonatomic, strong) UIButton *videoCallButton;

@end

@implementation EaseChatBarMoreView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseChatBarMoreView *moreView = [self appearance];
    moreView.moreViewBackgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame type:(EMChatToolbarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = type;
        [self setupSubviewsForType:_type];
    }
    return self;
}

- (void)setupSubviewsForType:(EMChatToolbarType)type
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (ZQ_Device_Width - 60)/4 - CHAT_BUTTON_SIZE;
    
    _takePicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(30 + insets/2, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *takePicLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CHAT_BUTTON_SIZE + 12, CHAT_BUTTON_SIZE + insets, 20)];
    takePicLabel.text = @"照相/视频";
    takePicLabel.textAlignment = NSTextAlignmentCenter;
    takePicLabel.textColor = [UIColor blackColor];
    takePicLabel.font = [UIFont systemFontOfSize:12];
    takePicLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_takePicButton];
    [self addSubview:takePicLabel];

    _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(30 + insets + insets/2 + CHAT_BUTTON_SIZE, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_photoButton.frame), CHAT_BUTTON_SIZE + 12, CHAT_BUTTON_SIZE, 20)];
    photoLabel.text = @"相册";
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.textColor = [UIColor blackColor];
    photoLabel.font = [UIFont systemFontOfSize:12];
    photoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_photoButton];
    [self addSubview:photoLabel];
    
//    _videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_videoButton setFrame:CGRectMake(30 + insets*2 + insets/2 + CHAT_BUTTON_SIZE*2, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_videoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_video"] forState:UIControlStateNormal];
//    [_videoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoSelected"] forState:UIControlStateHighlighted];
//    [_videoButton addTarget:self action:@selector(takeVideoAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *videoPicLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_videoButton.frame), CHAT_BUTTON_SIZE + 12, CHAT_BUTTON_SIZE, 20)];
//    videoPicLabel.text = @"红包";
//    videoPicLabel.textAlignment = NSTextAlignmentCenter;
//    videoPicLabel.textColor = [UIColor blackColor];
//    videoPicLabel.font = [UIFont systemFontOfSize:12];
//    videoPicLabel.backgroundColor = [UIColor clearColor];
//    [self addSubview:_videoButton];
//    [self addSubview:videoPicLabel];
    // insets*3  CHAT_BUTTON_SIZE*3
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(30 + insets*2 + insets/2 + CHAT_BUTTON_SIZE*2, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_locationButton.frame), CHAT_BUTTON_SIZE + 12, CHAT_BUTTON_SIZE, 20)];
    locationLabel.text = @"位置";
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.font = [UIFont systemFontOfSize:12];
    locationLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_locationButton];
    [self addSubview:locationLabel];
    
    //    CGRect frame = self.frame;
    //    if (type == ChatMoreTypeChat) {
    //        frame.size.height = 150;
    //
    //        _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
    //        [_audioCallButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    //        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
    //        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
    //        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
    //        [self addSubview:_audioCallButton];
    //    }
    //    else if (type == ChatMoreTypeGroupChat)
    //    {
    //        frame.size.height = 80;
    //    }
    CGRect frame = self.frame;
    frame.size.height = 100;
    self.frame = frame;
}

- (void)insertItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title
{
//    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE) / 5;
//    CGRect frame = self.frame;
    _maxIndex++;
//    NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
//    NSInteger page = _maxIndex/pageSize;
//    NSInteger row = (_maxIndex%pageSize)/MOREVIEW_COL;
//    NSInteger col = _maxIndex%MOREVIEW_COL;
//    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE * row, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [moreButton setImage:image forState:UIControlStateNormal];
//    [moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
//    [moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
//    moreButton.tag = MOREVIEW_BUTTON_TAG+_maxIndex;
//    [_scrollview addSubview:moreButton];
//    [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
//    [_pageControl setNumberOfPages:page + 1];
//    if (_maxIndex >=5) {
//        frame.size.height = 150;
//        _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
//        _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
//    }
//    self.frame = frame;
//    _pageControl.hidden = _pageControl.numberOfPages<=1;
    
    CGFloat insets = (ZQ_Device_Width - 60)/4 - CHAT_BUTTON_SIZE;
    _videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_videoButton setFrame:CGRectMake(30 + insets*2 + insets/2 + CHAT_BUTTON_SIZE*2, 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_videoButton setImage:image forState:UIControlStateNormal];
    [_videoButton setImage:highLightedImage forState:UIControlStateHighlighted];
    _videoButton.tag = MOREVIEW_BUTTON_TAG+5;
    [_videoButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *videoPicLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_videoButton.frame), CHAT_BUTTON_SIZE + 12, CHAT_BUTTON_SIZE, 20)];
    videoPicLabel.text = title;
    videoPicLabel.textAlignment = NSTextAlignmentCenter;
    videoPicLabel.textColor = [UIColor blackColor];
    videoPicLabel.font = [UIFont systemFontOfSize:12];
    videoPicLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_videoButton];
    [self addSubview:videoPicLabel];
}

- (void)updateItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title atIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [(UIButton*)moreButton setImage:image forState:UIControlStateNormal];
        [(UIButton*)moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    }
}

- (void)removeItematIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [self _resetItemFromIndex:index];
        [moreButton removeFromSuperview];
    }
}

#pragma mark - private

- (void)_resetItemFromIndex:(NSInteger)index
{
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE) / 5;
    CGRect frame = self.frame;
    for (NSInteger i = index + 1; i<_maxIndex + 1; i++) {
        UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+i];
        if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
            NSInteger moveToIndex = i - 1;
            NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
            NSInteger page = moveToIndex/pageSize;
            NSInteger row = (moveToIndex%pageSize)/MOREVIEW_COL;
            NSInteger col = moveToIndex%MOREVIEW_COL;
            [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE * row, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
            moreButton.tag = MOREVIEW_BUTTON_TAG+moveToIndex;
            [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
            [_pageControl setNumberOfPages:page + 1];
        }
    }
    _maxIndex--;
    if (_maxIndex >=5) {
        frame.size.height = 150;
    } else {
        frame.size.height = 80;
    }
    self.frame = frame;
    _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

#pragma setter
//- (void)setMoreViewColumn:(NSInteger)moreViewColumn
//{
//    if (_moreViewColumn != moreViewColumn) {
//        _moreViewColumn = moreViewColumn;
//        [self setupSubviewsForType:_type];
//    }
//}
//
//- (void)setMoreViewNumber:(NSInteger)moreViewNumber
//{
//    if (_moreViewNumber != moreViewNumber) {
//        _moreViewNumber = moreViewNumber;
//        [self setupSubviewsForType:_type];
//    }
//}

- (void)setMoreViewBackgroundColor:(UIColor *)moreViewBackgroundColor
{
    _moreViewBackgroundColor = moreViewBackgroundColor;
    if (_moreViewBackgroundColor) {
        [self setBackgroundColor:_moreViewBackgroundColor];
    }
}

/*
 - (void)setMoreViewButtonImages:(NSArray *)moreViewButtonImages
 {
 _moreViewButtonImages = moreViewButtonImages;
 if ([_moreViewButtonImages count] > 0) {
 for (UIView *view in self.subviews) {
 if ([view isKindOfClass:[UIButton class]]) {
 UIButton *button = (UIButton *)view;
 if (button.tag < [_moreViewButtonImages count]) {
 NSString *imageName = [_moreViewButtonImages objectAtIndex:button.tag];
 [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
 }
 }
 }
 }
 }
 
 - (void)setMoreViewButtonHignlightImages:(NSArray *)moreViewButtonHignlightImages
 {
 _moreViewButtonHignlightImages = moreViewButtonHignlightImages;
 if ([_moreViewButtonHignlightImages count] > 0) {
 for (UIView *view in self.subviews) {
 if ([view isKindOfClass:[UIButton class]]) {
 UIButton *button = (UIButton *)view;
 if (button.tag < [_moreViewButtonHignlightImages count]) {
 NSString *imageName = [_moreViewButtonHignlightImages objectAtIndex:button.tag];
 [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
 }
 }
 }
 }
 }*/

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset =  scrollView.contentOffset;
    if (offset.x == 0) {
        _pageControl.currentPage = 0;
    } else {
        int page = offset.x / CGRectGetWidth(scrollView.frame);
        _pageControl.currentPage = page;
    }
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

- (void)moreAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button && _delegate && [_delegate respondsToSelector:@selector(moreView:didItemInMoreViewAtIndex:)]) {
        [_delegate moreView:self didItemInMoreViewAtIndex:button.tag-MOREVIEW_BUTTON_TAG];
    }
}

@end
