//
//  EPopView.m
//  Easy
//
//  Created by yituiyun on 2017/12/22.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPopView.h"
#import "EPopTableViewCell.h"

float const kPopViewCellHeight = 50; ///< cell指定高度

@interface EPopView () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow; ///< 当前窗口
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView; ///< 遮罩层
@property (nonatomic, assign) BOOL isUpward;

#pragma mark - Data
@property (nonatomic, copy) NSArray<EPopAction *> *actions;
@property (nonatomic, assign) CGFloat windowWidth; ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; ///< 窗口高度
@end

@implementation EPopView

#pragma mark - Lift Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0,0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}


#pragma mark - Private
/*! @brief 初始化相关 */
- (void)initialize {
    // data
    _actions = @[];
    
    // current view
    self.backgroundColor = [UIColor whiteColor];
    
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    
    // tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

/*! @brief 显示弹窗指向某个点,  */
- (void)showToPoint:(CGPoint)toPoint {
    NSAssert(_actions.count > 0, @"actions must not be nil or empty !");
    
    // 遮罩层
    _shadeView.alpha = 0;
    _shadeView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    [_keyWindow addSubview:_shadeView];
    
    // 刷新数据以获取具体的ContentSize
    [_tableView reloadData];
    
    // 根据刷新后的ContentSize和箭头指向方向来设置当前视图的frame
    CGFloat currentW = kScreenW;
//    CGFloat currentH = _tableView.contentSize.height;
    CGFloat currentH = _actions.count * kPopViewCellHeight;

    // 限制最高高度, 免得选项太多时超出屏幕
    CGFloat maxHeight = _isUpward ? (_windowHeight - toPoint.y) : (toPoint.y - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    
    // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
    if (currentH > maxHeight) {
        currentH = maxHeight;
        _tableView.scrollEnabled = YES;
        if (!_isUpward) { // 箭头指向下则移动到最后一行
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_actions.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    CGFloat currentX = 0;
    CGFloat currentY = toPoint.y;
    
    // 向下
    if (!_isUpward) {
        currentY = toPoint.y - currentH;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    [_keyWindow addSubview:self];
    
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(toPoint.x/currentW, _isUpward ? 0.f : 1.f);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        _shadeView.alpha = 1.f;
    }];
    
    
}


/*! @brief 点击外部隐藏弹窗 */
- (void)hide {
    if (self.hideBlock) {
        self.hideBlock();
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        _shadeView.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark -  *** Public
+ (instancetype)popView {
    return [[self alloc] init];
}

/*! @brief 指向指定的点来显示弹窗 */
- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<EPopAction *> *)actions {
    _actions = [actions copy];
    
    // 计算箭头指向方向
    _isUpward = toPoint.y <= _windowHeight - toPoint.y;
    [self showToPoint:toPoint];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _actions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPopViewCellHeight;
}

static NSString *kPopCellIdentifier = @"kPopoverCellIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EPopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopCellIdentifier];
    if (!cell) {
        cell = [[EPopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPopCellIdentifier];
    }
    
    cell.action = self.actions[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hideBlock) {
        self.hideBlock();
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        _shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        EPopAction *action = _actions[indexPath.row];
        action.handler ? action.handler(action) : NULL;
        _actions = nil;
        [_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
