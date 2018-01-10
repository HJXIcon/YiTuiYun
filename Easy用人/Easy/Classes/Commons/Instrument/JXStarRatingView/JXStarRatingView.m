//
//  JXStarRatingView.m
//  Easy
//
//  Created by yituiyun on 2017/11/21.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXStarRatingView.h"

@interface JXStarRatingView(){
    CGContextRef _context;
}
@property(nullable, nonatomic, strong) UIImageView *progressImageView;
@property(nullable, nonatomic, strong) UIImageView *backgroundImageView;

@end
@implementation JXStarRatingView

#pragma mark - *** init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initializate];
        [self setupUI];
    }
    return self;
}

- (void)initializate{
    
    self.starMargin = 5;
    self.progress = 3;
    
    if (self.backgroundImage == nil) {
        self.backgroundImage = [UIImage imageNamed:@"JXStarRating.bundle/b27_icon_star_gray"];
    }
    if (self.foregroundImage == nil) {
        self.foregroundImage = [UIImage imageNamed:@"JXStarRating.bundle/b27_icon_star_yellow"];
    }
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.frame = self.bounds;
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.contentMode = UIViewContentModeLeft;
    self.backgroundImageView.clipsToBounds = YES;
    [self addSubview:self.backgroundImageView];
    
    
    self.progressImageView = [[UIImageView alloc] init];
    self.progressImageView.frame = self.bounds;
    self.progressImageView.contentMode = UIViewContentModeLeft;
    self.progressImageView.clipsToBounds = YES;
    [self addSubview:self.progressImageView];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.backgroundImageView addGestureRecognizer:tap];
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.backgroundImageView addGestureRecognizer:pan];
    
    [self setupUI];
}

#pragma mark - *** UI
- (void)setupUI{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadStarsDelay) object:nil];
    [self performSelector:@selector(loadStarsDelay) withObject:nil afterDelay:0];
   
}


- (void)loadStarsDelay{
    self.backgroundImageView.frame = self.bounds;
    self.progressImageView.frame = self.bounds;
    self.progress = self.progress;
    
    CGFloat starWidth = (self.frame.size.width - self.starMargin * 4) / 5;
    UIView * backgroundCache = [[UIImageView alloc] init];
    backgroundCache.frame = self.bounds;
    
    // Background.
    for (NSInteger i = 0; i < 5; i++) {
        
        UIImageView * star = [[UIImageView alloc] init];
        star.frame = CGRectMake(starWidth * i + self.starMargin * i, 0, starWidth, self.frame.size.height);
        star.image = self.backgroundImage;
        [backgroundCache addSubview:star];
    }
    self.backgroundImageView.image = [self convertViewToImage:backgroundCache];
    
    UIView *starCache = [[UIImageView alloc] init];
    starCache.frame = self.bounds;
    
    // Foreground.
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView * star = [[UIImageView alloc] init];
        star.frame = CGRectMake(starWidth * i + self.starMargin * i, 0, starWidth, self.frame.size.height);
        star.image = self.foregroundImage;
        [starCache addSubview:star];
    }
    
    self.progressImageView.image = [self convertViewToImage:starCache];
}

- (UIImage *)convertViewToImage:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - *** Actions
- (void)tapAction:(UIGestureRecognizer *)tap{
    
    CGPoint tapPoint = [tap locationInView:self.backgroundImageView];
    CGFloat progress = 5. / self.frame.size.width * tapPoint.x;
    self.progress = progress;
    
    if (self.finishBlock) {
        self.finishBlock(self.progress);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(starRatingView:currentValue:)]) {
        [self.delegate starRatingView:self currentValue:self.progress];
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan{
    CGPoint panPoint = [pan locationInView:self.backgroundImageView];
    CGFloat progress = 5. / self.frame.size.width * panPoint.x;
    self.progress = progress;
    
    if (self.finishBlock) {
        self.finishBlock(self.progress);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(starRatingView:currentValue:)]) {
        [self.delegate starRatingView:self currentValue:self.progress];
    }
}


#pragma mark - *** dealloc
- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadStarsDelay) object:nil];
}

- (void)removeFromSuperview{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadStarsDelay) object:nil];
    [super removeFromSuperview];
}


#pragma mark - *** setter
- (void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
    for (UIGestureRecognizer * ges in self.backgroundImageView.gestureRecognizers) {
        ges.enabled = enabled;
    }
}

- (void)setStarMargin:(CGFloat)starMargin{
    _starMargin = starMargin;
    [self setupUI];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setupUI];
}

- (void)setStyle:(JXStarRatingStyle)style{
    _style = style;
    self.progress = self.progress;
}

- (void)setProgress:(CGFloat)progress{
    if (progress > 5. || progress < 0) {
        NSLog(@"'Progress' could not greater than 5.0");
        if (progress > 5.) progress = 5.;
        else if(progress < 0) progress = 0;
    }
    
    switch (self.style) {
        case JXStarRatingWholeStarStyle:
            progress = roundf(progress);
            break;

        case JXStarRatingHalfStyle:
            
#define HALF_CUTTING(number) else if (progress > number && progress <= number + 0.5) progress = number + 0.25
            if (progress <= 0.25) progress = 0;
            HALF_CUTTING(0.25);
            HALF_CUTTING(0.75);
            HALF_CUTTING(1.25);
            HALF_CUTTING(1.75);
            HALF_CUTTING(2.25);
            HALF_CUTTING(2.75);
            HALF_CUTTING(3.25);
            HALF_CUTTING(3.75);
            HALF_CUTTING(4.25);
            HALF_CUTTING(4.75);
            break;
            
        case JXStarRatingIncompleteStyle:
            break;
    }
    
    _progress = progress;
    
    self.progressImageView.frame = CGRectMake(0, 0, self.frame.size.width / 5. * self.progress, self.frame.size.height);
    

}


@end
