//
//  JXPopView.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/10/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPopView.h"
#import "JXPopViewCell.h"
#import "JXPopModel.h"
#import "JXPopModel.h"
#import "JXPopAllSelectView.h"

static float const kPopoverViewCellHeight = 40.f; ///< cell指定高度

@interface JXPopView ()<UITableViewDelegate,UITableViewDataSource>
#pragma mark - UI
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIWindow *keyWindow;
@property (nonatomic, strong) UIView *shadeView; ///< 遮罩层
@property (nonatomic, assign) CGFloat windowWidth; ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; ///< 窗口高度
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; ///< 点击背景阴影的手势

@property (nonatomic, strong) JXPopAllSelectView *allSelectView;

#pragma mark - Data
/** 数据源*/
@property (nonatomic, strong) NSMutableArray <JXPopModel *>*datas;
@property (nonatomic, assign) BOOL isUpward;

@property (nonatomic, assign) JXPopViewSelectBlock selectBlock;

@end
@implementation JXPopView

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
    
    _allSelectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), kPopoverViewCellHeight);
    _tableView.frame = CGRectMake(0,  kPopoverViewCellHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kPopoverViewCellHeight);
}


#pragma mark - Private
/*! @brief 初始化相关 */
- (void)initialize {
    // data
    _datas = [NSMutableArray array];
    
    // current view
    self.backgroundColor = [UIColor whiteColor];
    
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    _shadeView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.18f];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;
    
    // allSelectView
    _allSelectView = [[JXPopAllSelectView alloc]init];
    MJWeakSelf;
    _allSelectView.tapBlock = ^(BOOL isSelectAll){
        [self.datas enumerateObjectsUsingBlock:^(JXPopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelect = isSelectAll;
        }];
        
        [weakSelf.tableView reloadData];
    };
    [self addSubview:_allSelectView];
    
    
    // tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = UIColorFromRGBString(@"0xe1e1e1");
    
    if ([_tableView respondsToSelector:@selector(separatorInset)]) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([_tableView respondsToSelector:@selector(layoutMargins)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    _tableView.rowHeight = kPopoverViewCellHeight;
    [self addSubview:_tableView];
}

/*! @brief 点击外部隐藏弹窗 */
- (void)hide {
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [self.datas enumerateObjectsUsingBlock:^(JXPopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isSelect) {
            [indexSet addIndex:idx];
        }
    }];
    
    if (self.selectBlock) {
        self.selectBlock(indexSet);
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




#pragma mark - Public Method
+ (instancetype)popView{
    return [[self alloc]init];
}
- (void)showToPoint:(CGPoint)toPoint
         withTitles:(NSArray <NSString *>*)titles
     selectIndexSet:(NSMutableIndexSet *)selectIndexSet completion:(JXPopViewSelectBlock)completion{
    
    _selectBlock = completion;
    
    for (NSString *title in titles) {
        JXPopModel *model = [[JXPopModel alloc]init];
        model.title = title;
        [_datas addObject:model];
    }
    
    [selectIndexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL*stop)
     {
         [self.datas enumerateObjectsUsingBlock:^(JXPopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             
             if (idx == index) {
                 obj.isSelect = YES;
             }
         }];
     }];
    
    // 计算箭头指向方向
    _isUpward = toPoint.y <= _windowHeight - toPoint.y;
    [self showToPoint:toPoint];
}

- (void)showToView:(UIView *)pointView
        withTitles:(NSArray <NSString *>*)titles
    selectIndexSet:(NSMutableIndexSet *)selectIndexSet
        completion:(JXPopViewSelectBlock)completion{
    
    _selectBlock = completion;
    
    for (NSString *title in titles) {
        JXPopModel *model = [[JXPopModel alloc]init];
        model.title = title;
        [_datas addObject:model];
    }
    
    
    [selectIndexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL*stop)
     {
         [self.datas enumerateObjectsUsingBlock:^(JXPopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             
             if (idx == index) {
                 obj.isSelect = YES;
             }
         }];
     }];
    
    
    // 计算pointView.superview上的pointView相对于_keyWindow的frame。
    // 判断 pointView 是偏上还是偏下
    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:_keyWindow];// 将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
    CGFloat pointViewUpLength = CGRectGetMinY(pointViewRect);
    CGFloat pointViewDownLength = _windowHeight - CGRectGetMaxY(pointViewRect);
    // 弹窗箭头指向的点
    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
    // 弹窗在 pointView 顶部
    if (pointViewUpLength > pointViewDownLength) {
        toPoint.y = pointViewUpLength;
    }
    // 弹窗在 pointView 底部
    else {
        toPoint.y = CGRectGetMaxY(pointViewRect);
    }
    // 箭头指向方向
    _isUpward = pointViewUpLength <= pointViewDownLength;
    [self showToPoint:toPoint];
    
}

- (void)showToPoint:(CGPoint)toPoint {
    NSAssert(_datas.count > 0, @"datas must not be nil or empty !");

    // 遮罩层
    _shadeView.alpha = 0.f;
    [_keyWindow addSubview:_shadeView];
    
    _tableView.scrollEnabled = _datas.count > 4 ? YES : NO;
    // 刷新数据以获取具体的ContentSize
    [_tableView reloadData];
    
    
    // 根据刷新后的ContentSize和箭头指向方向来设置当前视图的frame
    CGFloat currentW = [self calculateMaxWidth]; // 宽度通过计算获取最大值
    CGFloat currentH =  _datas.count > 5 ? 5 * kPopoverViewCellHeight : _tableView.contentSize.height;
    
    CGFloat currentX = toPoint.x - currentW/2, currentY = toPoint.y;
    // x: 窗口靠左
    if (toPoint.x <= currentW/2) {
        currentX = 0;
    }
    // x: 窗口靠右
    if (_windowWidth - toPoint.x <= currentW/2 ) {
        currentX = _windowWidth - currentW;
    }
    // y: 箭头向下
    if (!_isUpward) {
        currentY = toPoint.y - currentH;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    [_keyWindow addSubview:self];
    
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        _shadeView.alpha = 1.f;
    }];

}


/*! @brief 计算最大宽度 */
- (CGFloat)calculateMaxWidth {
    
    CGFloat maxWidth = 0.f, titleLeftEdge = 0.f, imageWidth = 0.f, imageMaxHeight = kPopoverViewCellHeight;
    CGSize imageSize = [JXPopViewCell imageSize];
    UIFont *titleFont = [JXPopViewCell titleFont];
    
    CGFloat titleWidth;
    
    for (JXPopModel *model in _datas) {
        imageWidth = imageSize.width;
        titleLeftEdge = PopoverViewCellTitleLeftEdge;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) { // iOS7及往后版本
            titleWidth = [model.title sizeWithAttributes:@{NSFontAttributeName : titleFont}].width;
        } else { // iOS6
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            titleWidth = [model.title sizeWithFont:titleFont].width;
#pragma GCC diagnostic pop
        }
        
        CGFloat contentWidth = PopoverViewCellHorizontalMargin*2 + imageWidth + titleLeftEdge + titleWidth;
        if (contentWidth > maxWidth) {
            maxWidth = ceil(contentWidth); // 获取最大宽度时需使用进一取法, 否则Cell中没有图片时会可能导致标题显示不完整.
        }
        
        // 如果最大宽度大于(窗口宽度 - kPopoverViewMargin*2)则限制最大宽度等于(窗口宽度 - kPopoverViewMargin*2)
        if (maxWidth > CGRectGetWidth(_keyWindow.bounds)) {
            maxWidth = CGRectGetWidth(_keyWindow.bounds);
        }
        
    }
    
    return maxWidth;
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JXPopViewCell *cell = [JXPopViewCell cellForTableView:tableView];
    
    cell.model = _datas[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JXPopModel *model = _datas[indexPath.row];
    model.isSelect = !model.isSelect;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
    __block BOOL isSelectAll = YES;
    [self.datas enumerateObjectsUsingBlock:^(JXPopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.isSelect) {
            isSelectAll = NO;
        }
    }];
    
    _allSelectView.isSelectAll = isSelectAll;
    
}



@end
