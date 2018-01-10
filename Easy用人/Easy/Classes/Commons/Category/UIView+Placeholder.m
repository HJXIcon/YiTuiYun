//
//  UIView+Placeholder.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/26.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "UIView+Placeholder.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

#define DEFAULTCOLOR [UIColor colorWithHexString:@"#565656"]
#define DEFAULTFONT  [UIFont boldSystemFontOfSize:E_FontRadio(16)]


@interface UIView ()
/** 占位图 */
@property (nonatomic, strong) UIView *jx_placeholderView;
/** 记录scrollView是否滚动 */
@property (nonatomic, assign) BOOL originalScrollEnabled;
@end

@implementation UIView (Placeholder)

static void *placeholder = &placeholder;
static void *reloadBlockKey = &reloadBlockKey;
static void *placeholderColor = &placeholderColor;
static void *placeholderBackgroundColor = &placeholderBackgroundColor;
static void *reloadBtnBackgroundColor = &reloadBtnBackgroundColor;
static void *originalScrollEnabledKey = &originalScrollEnabledKey;


#pragma mark - setter/getter
- (UIView *)jx_placeholderView {
    return objc_getAssociatedObject(self, &placeholder);
}


- (void)setJx_placeholderView:(UIView *)jx_placeholderView{
    objc_setAssociatedObject(self, &placeholder, jx_placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void (^)(void))reloadBlock{
    return objc_getAssociatedObject(self, &reloadBlockKey);
}

- (void)setReloadBlock:(void (^)(void))reloadBlock{
    objc_setAssociatedObject(self, &reloadBlockKey, reloadBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)jx_placeholderColor{
     return objc_getAssociatedObject(self, &placeholderColor);
}

- (void)setJx_placeholderColor:(UIColor *)jx_placeholderColor{
     objc_setAssociatedObject(self, &placeholderColor, jx_placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIColor *)jx_placeholderBackgroundColor{
    return objc_getAssociatedObject(self, &placeholderBackgroundColor);
}

- (void)setJx_placeholderBackgroundColor:(UIColor *)jx_placeholderBackgroundColor{
     objc_setAssociatedObject(self, &placeholderBackgroundColor, jx_placeholderBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIColor *)jx_reloadBtnBackgroundColor{
    return objc_getAssociatedObject(self, &reloadBtnBackgroundColor);
}


- (void)setJx_reloadBtnBackgroundColor:(UIColor *)jx_reloadBtnBackgroundColor{
    objc_setAssociatedObject(self, &reloadBtnBackgroundColor, jx_reloadBtnBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)originalScrollEnabled{
     return [objc_getAssociatedObject(self, &originalScrollEnabledKey) boolValue];
}

- (void)setOriginalScrollEnabled:(BOOL)originalScrollEnabled{
   
    objc_setAssociatedObject(self, &originalScrollEnabledKey, @(originalScrollEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}


- (void)jx_showPlaceholderViewWithImageName:(NSString *)imageName
                       desText:(NSString *)desText
                reloadBtnTitle:(NSString *)reloadBtnTitle
                   reloadBlock:(void(^)(void))reloadBlock{
    self.reloadBlock = reloadBlock;
    
    // 如果是UIScrollView及其子类，占位图展示期间禁止scroll
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        // 先记录原本的scrollEnabled
        self.originalScrollEnabled = scrollView.scrollEnabled;
        // 再将scrollEnabled设为NO
        scrollView.scrollEnabled = NO;
    }
    
    //------- 占位图 -------//
    if (self.jx_placeholderView) {
        [self.jx_placeholderView removeFromSuperview];
        self.jx_placeholderView = nil;
    }
    self.jx_placeholderView = [[UIView alloc] init];
    [self addSubview:self.jx_placeholderView];
    self.jx_placeholderView.backgroundColor = self.jx_placeholderBackgroundColor ? self.jx_placeholderBackgroundColor : [UIColor whiteColor];
    [self.jx_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
    
    //------- 图标 -------//
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.jx_placeholderView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.superview);
        make.centerY.mas_equalTo(imageView.superview).mas_offset(-E_RealWidth(95));
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(95), E_RealWidth(95)));
    }];
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    if (!path.length) {
        path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    }
    if (path.length) {
        imageView.image = [UIImage imageWithContentsOfFile:path];
    }else{
        imageView.image = [UIImage imageNamed:imageName];
    }
    
    
    //------- 描述 -------//
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = self.jx_placeholderColor ? self.jx_placeholderColor : DEFAULTCOLOR;
    descLabel.font = DEFAULTFONT;
    [self.jx_placeholderView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(descLabel.superview);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(E_RealHeight(18));
    }];
    descLabel.text = desText;
    
    
    //------- button -------//
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.titleLabel.font = DEFAULTFONT;
    [reloadButton setTitle:reloadBtnTitle forState:UIControlStateNormal];
    [self.jx_placeholderView addSubview:reloadButton];
    if (self.jx_reloadBtnBackgroundColor) {
        [reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        reloadButton.backgroundColor = self.jx_reloadBtnBackgroundColor ? self.jx_reloadBtnBackgroundColor : EThemeColor;
    }else{
        [reloadButton setTitleColor:self.jx_placeholderColor ? self.jx_placeholderColor : EThemeColor forState:UIControlStateNormal];
    }
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(reloadButton.superview);
        make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(E_RealHeight(20));
    }];
    
    [reloadButton addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
    
    reloadButton.hidden = reloadBtnTitle.length == 0;
    
}


- (void)reloadAction{
    if (self.reloadBlock) {
        self.reloadBlock();
    }
    
    // 从父视图移除
    [self.jx_placeholderView removeFromSuperview];
    self.jx_placeholderView = nil;
    self.jx_placeholderColor = nil;
    self.jx_reloadBtnBackgroundColor = nil;
    self.jx_placeholderBackgroundColor = nil;
    
    // 复原UIScrollView的scrollEnabled
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = self.originalScrollEnabled;
    }
    
    
    
}

@end
