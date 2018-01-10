//
//  HFTagView.m
//  ChangeClothes
//
//  Created by joyman04 on 15/10/23.
//  Copyright © 2015年 BFHD. All rights reserved.
//

#import "HFTagView.h"
#import "HFGetTag.h"

@interface HFTagView ()<UIScrollViewDelegate>



@property (nonatomic,strong) UIScrollView* backView;
@property (nonatomic,strong) UIPageControl* pageView;

@property (nonatomic,strong) NSMutableArray* dataArr;
//@property (nonatomic,strong) NSMutableArray* styleDataArr;
//@property (nonatomic,strong) NSMutableArray* selectTagDataArr;

@property (nonatomic,strong) UIView* buttonBack;
@property (nonatomic,strong) UIButton* finishButton;
@property (nonatomic,strong) UIButton* cancelButton;

@property (nonatomic,strong) NSMutableArray* selectArr;

@property (nonatomic,assign) NSInteger maxNum;

@end

@implementation HFTagView

- (instancetype)initWithOptionName:(NSString *)optionName withMaxNum:(NSInteger)maxNum{
    self = [self initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.maxNum = maxNum;
    self.optionName = optionName;
    return self;
}

- (instancetype)initWithKeyId:(NSString *)keyId withMaxNum:(NSInteger)maxNum{
    self = [self initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.maxNum = maxNum;
    self.keyId = keyId;
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = self.bounds;
        visualEffectView.alpha = 0.9;
        [self addSubview:visualEffectView];
        
        UITapGestureRecognizer*tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [visualEffectView addGestureRecognizer:tap];
        
        self.backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, frame.size.height - 200, frame.size.width, 200)];
        self.backView.delegate = self;
        self.backView.alwaysBounceHorizontal = NO;
        self.backView.alwaysBounceVertical = NO;
        self.backView.showsHorizontalScrollIndicator = NO;
        self.backView.showsVerticalScrollIndicator = NO;
        self.backView.pagingEnabled = YES;
        self.backView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
        [self addSubview:self.backView];
        
        self.pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 10, frame.size.width, 10)];
        self.pageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:self.pageView];
        
        self.buttonBack = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.frame.origin.y - 40, frame.size.width, 40)];
        self.buttonBack.backgroundColor = [UIColor clearColor];
        [self addSubview:self.buttonBack];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(10, 0, 50, self.buttonBack.frame.size.height);
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonDown) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonBack addSubview:self.cancelButton];
        
        self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.finishButton.frame = CGRectMake(self.buttonBack.frame.size.width - 50 - 10, 0, self.cancelButton.frame.size.width, self.buttonBack.frame.size.height);
        [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.finishButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.finishButton addTarget:self action:@selector(finishButtonDown) forControlEvents:UIControlEventTouchUpInside];
        self.finishButton.userInteractionEnabled = NO;
        [self.buttonBack addSubview:self.finishButton];
    }
    return self;
}

-(NSMutableArray*)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray new];
    }
    return _selectArr;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.pageView setCurrentPage:offset.x / bounds.size.width];
}

-(void)setKeyId:(NSString *)keyId{
    _keyId = keyId;
    [self.selectArr removeAllObjects];
    [self.finishButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.finishButton.userInteractionEnabled = NO;
    
    [HFGetTag getTagWithKeyId:keyId parentId:@"0" getType:EveryReload success:^(NSArray * _Nullable responseObject) {
        for (NSDictionary* tempDic in responseObject) {
            HFTagModel* model = [[HFTagModel alloc] init];
            model.title = tempDic[@"name"];
            model.tagId = tempDic[@"id"];
            [self.dataArr addObject:model];
        }
        [self setButton];
    }];
}

-(void)setOptionName:(NSString *)optionName{
    _optionName = optionName;
    [self.selectArr removeAllObjects];
    [self.finishButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.finishButton.userInteractionEnabled = NO;
    
    [self getOneDataWithIsReload:true];
}

- (void)getOneDataWithIsReload:(BOOL)isReload{
    NSString* tableName = [@"xiaLaXuanXiang" stringByAppendingString:self.optionName];
    
    [[HFDataBase sharInstance] createNewTableWithTableName:tableName andColumn:@"value,name,superName"];
    
    NSArray* tempArr = [[HFDataBase sharInstance] selectFromeTableName:tableName andColumn:@"value,name,superName" andCondition:@[[NSString stringWithFormat:@"superName=%@",self.optionName]]];
    
    [self.dataArr removeAllObjects];
    for (NSDictionary* tempDic in tempArr) {
        HFTagModel* model = [[HFTagModel alloc] init];
        model.title = tempDic[@"name"];
        model.tagId = tempDic[@"value"];
        [self.dataArr addObject:model];
    }
    [self setButton];
    
    if (isReload) {
        [self getTagsDataFromService];
    }
}

- (void)getTagsDataFromService{
    NSString* tableName = [@"xiaLaXuanXiang" stringByAppendingString:self.optionName];
    
    [HFRequest requestWithUrl:[kHost stringByAppendingString:@"api.php?m=data.options"] parameters:@{} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        BOOL isReload = NO;
        for (NSString* tempKey in [responseObject allKeys]) {
            if ([self.optionName isEqualToString:tempKey]) {
                for (NSDictionary* subTempDic in responseObject[tempKey][@"options"]) {
                    NSArray* tempArr = [[HFDataBase sharInstance] selectFromeTableName:tableName andColumn:@"value,name,superName" andCondition:@[[NSString stringWithFormat:@"value=%@",subTempDic[@"value"]],[NSString stringWithFormat:@"superName=%@",tempKey]]];
                    if (tempArr.count == 0) {
                        isReload = YES;
                    }
                    [[HFDataBase sharInstance] upDataFromeTableName:tableName andColumn:@[@"value",@"name",@"superName"] andParameter:@[subTempDic[@"value"],subTempDic[@"name"],tempKey] andCondition:@[[NSString stringWithFormat:@"value=%@",subTempDic[@"value"]],[NSString stringWithFormat:@"superName=%@",tempKey]]];
                }
            }
        }
        if (isReload) {
            [self getOneDataWithIsReload:false];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [self getTagsDataFromService];
    }];
}

#pragma mark 发布时选择标签
-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

-(void)setButton{
    for (UIView* view in self.backView.subviews) {
//        if ([view isKindOfClass:[HFTagButton class]]) {
            [view removeFromSuperview];
//        }
    }
    CGFloat x = 10;
    CGFloat y = 10;
    NSInteger ye = 1;
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        HFTagModel* model = self.dataArr[i];
//        CGSize buttonSize = [NSString sizeWithString:model.title font:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(self.frame.size.width - 20, 15)];
        CGSize buttonSize = [model.title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(self.frame.size.width - 20, 15)];
        if (x > self.backView.frame.size.width - 20 - 5 - buttonSize.width) {
            x = 10;
            y = y + 25;
            if (y > self.backView.frame.size.height - 20 - buttonSize.height) {
                y = 10;
                ye++;
            }
        }
        CGRect buttonFrame = CGRectMake((ye - 1) * self.backView.frame.size.width + x, y, buttonSize.width + 20, buttonSize.height + 10);
        x = x + buttonSize.width + 20 + 5;
        HFTagButton* button = [HFTagButton creatWithFram:buttonFrame withBackColor:[UIColor lightGrayColor]];
        button.tag = i;
        [button setTitle:model.title forState:UIControlStateNormal];
        
        for (HFTagModel* tempModel in self.selectArr) {
            if ([tempModel.title isEqualToString:model.title]) {
                button.backgroundColor = [UIColor colorWithR:53 G:135 B:206 alpha:1];
            }
        }
        
        [button addTarget:self action:@selector(finishSelectTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:button];
    }
    self.backView.contentSize = CGSizeMake(self.frame.size.width * ye, self.backView.frame.size.height);
    self.pageView.numberOfPages = ye;
    self.pageView.currentPage = 0;
}

#pragma mark 选择标签
-(void)finishSelectTap:(UIButton*)button{
    HFTagModel* model = self.dataArr[button.tag];
    BOOL isHave = NO;
    for (HFTagModel* tempModel in self.selectArr) {
        if (tempModel == model) {
            isHave = YES;
            [self.selectArr removeObject:model];
            break;
        }
    }
    if (isHave) {
        [self.selectArr removeObject:model];
    }else{
        if (self.selectArr.count < self.maxNum || self.maxNum == 0) {
           [self.selectArr addObject:model];
        }else{
            return;
        }
    }
    
    [self setButton];
    
    if (self.selectArr.count > 0) {
        [self.finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.finishButton.userInteractionEnabled = YES;
    }else{
        [self.finishButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.finishButton.userInteractionEnabled = NO;
    }
}

-(void)cancelButtonDown{
    [self hide];
}

-(void)finishButtonDown{
    NSMutableArray* tagNameArr  = [NSMutableArray new];
    NSMutableArray* tagIdArr = [NSMutableArray new];
    for (HFTagModel* model in self.selectArr) {
        [tagNameArr addObject:model.title];
        [tagIdArr addObject:model.tagId];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTagWithTagView:withTagModels:)]) {
        [self.delegate selectTagWithTagView:self withTagModels:self.selectArr];
    }
    
    [self hide];
}

#pragma mark 显示
-(void)showSelf{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

#pragma mark 隐藏
-(void)hide{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
