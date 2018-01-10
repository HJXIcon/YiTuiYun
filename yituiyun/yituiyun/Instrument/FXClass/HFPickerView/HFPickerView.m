//
//  HFPickerView.m
//  EasyRepair
//
//  Created by joyman04 on 16/1/6.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "HFPickerView.h"
#import "HFGetTag.h"

@interface HFPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSInteger _starts;//状态值
    NSString* _keyId;
    BOOL _firstGetTag;//第一次获取数据
}

//@property (nonatomic,strong) UIView* backView;
@property (nonatomic,strong) UIPickerView* pickerView;
@property (nonatomic,strong) NSArray* dataArr;
@property (nonatomic,strong) UIDatePicker* datePicker;

@property (nonatomic,strong) UIView *gestureView;

@end

@implementation HFPickerView

- (instancetype)initWithPickerMode:(UIDatePickerMode)pickerMode{
    if (self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]) {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.backView.frame.size.width, self.backView.frame.size.height - 40)];
        self.datePicker.datePickerMode = pickerMode;
        [self.backView addSubview:self.datePicker];
    }
    return self;
}

- (void)setMinimumDate:(NSDate *)minimumDate{
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate{
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = maximumDate;
}

- (instancetype)initWithModel:(HFPickerViewModel *)model{
    if (self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]) {
        self.dataArr = @[model];
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.backView.frame.size.width, self.backView.frame.size.height - 40)];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.backView addSubview:self.pickerView];
        [self getOneDataWithModel:self.dataArr.firstObject];
    }
    return self;
}

- (void)getOneDataWithModel:(HFPickerViewModel*)model{
    NSString* tableName = [@"xiaLaXuanXiang" stringByAppendingString:model.parameter];
    
    [[HFDataBase sharInstance] createNewTableWithTableName:tableName andColumn:@"value,name,superName"];
    
    NSArray* tempArr = [[HFDataBase sharInstance] selectFromeTableName:tableName andColumn:@"value,name,superName" andCondition:@[[NSString stringWithFormat:@"superName=%@",model.parameter]]];
    
    model.subModelArr = [NSMutableArray new];
    for (NSDictionary* tempDic in tempArr) {
        HFPickerViewSubModel* subModel = [[HFPickerViewSubModel alloc] init];
        subModel.title = tempDic[@"name"];
        subModel.mId = tempDic[@"value"];
        [model.subModelArr addObject:subModel];
    }
    if (model.subModelArr.count > [self.pickerView selectedRowInComponent:0]) {
        model.upData = ((HFPickerViewSubModel*)model.subModelArr[[self.pickerView selectedRowInComponent:0]]).mId;
        model.title = ((HFPickerViewSubModel*)model.subModelArr[[self.pickerView selectedRowInComponent:0]]).title;
    }
    
    [self.pickerView reloadComponent:0];
    
    [HFRequest requestWithUrl:[kHost stringByAppendingString:@"api.php?m=data.options"] parameters:@{} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        BOOL isReload = NO;
        for (NSString* tempKey in [responseObject allKeys]) {
            if ([model.parameter isEqualToString:tempKey]) {
                for (NSDictionary* subTempDic in responseObject[tempKey][@"options"]) {
                    NSArray* tempArr = [[HFDataBase sharInstance] selectFromeTableName:tableName andColumn:@"value,name,superName" andCondition:@[[NSString stringWithFormat:@"value=%@",subTempDic[@"value"]],[NSString stringWithFormat:@"superName=%@",tempKey]]];
                    if (tempArr.count == 0) {
                        isReload = YES;
                    }
                    [[HFDataBase sharInstance] upDataFromeTableName:tableName andColumn:@[@"value",@"name",@"superName"] andParameter:@[subTempDic[@"value"],subTempDic[@"name"],tempKey] andCondition:@[[NSString stringWithFormat:@"value=%@",subTempDic[@"value"]],[NSString stringWithFormat:@"superName=%@",tempKey]]];
                }
            }
        }
        
        NSDictionary* tempDic = @{@"free":@{@"options":@[@{@"value":@"0",@"name":@"是"},@{@"value":@"1",@"name":@"否"}]}};
        for (NSString* tempKey in [tempDic allKeys]) {
            if ([model.parameter isEqualToString:tempKey]) {
                for (NSDictionary* subTempDic in tempDic[tempKey][@"options"]) {
                    NSArray* tempArr = [[HFDataBase sharInstance] selectFromeTableName:tableName andColumn:@"value,name,superName" andCondition:@[[NSString stringWithFormat:@"value=%@",subTempDic[@"value"]],[NSString stringWithFormat:@"superName=%@",tempKey]]];
                    if (tempArr.count == 0) {
                        isReload = YES;
                    }
                    [[HFDataBase sharInstance] upDataFromeTableName:tableName andColumn:@[@"value",@"name",@"superName"] andParameter:@[subTempDic[@"value"],subTempDic[@"name"],tempKey] andCondition:@[[NSString stringWithFormat:@"value=%@",subTempDic[@"value"]],[NSString stringWithFormat:@"superName=%@",tempKey]]];
                }
            }
        }
        if (isReload) {
            [self getOneDataWithModel:model];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (instancetype)initWithKeyId:(NSString *)keyId pickerModels:(NSArray *)models{
    if (self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]) {
        _keyId = keyId;
        self.dataArr = models;
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.backView.frame.size.width, self.backView.frame.size.height - 40)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.backView addSubview:self.pickerView];
        [self getPickerTagWithModel:self.dataArr.firstObject];
    }
    
    return self;
}

- (void)setDelegate:(id<HFPickerViewDelegate>)delegate {
    _delegate = delegate;
    if ([self.delegate respondsToSelector:@selector(firstSelectItemWithPickerView:withUpdata:)]) {
        NSMutableArray* upData = [NSMutableArray new];
        for (HFPickerViewModel* model in self.dataArr) {
            NSDictionary* dic;
            if (model.title == nil && model.upData == nil) {
                dic = @{@"upData":@"",@"title":@"",@"parameter":model.parameter};
            }else{
                dic = @{@"upData":model.upData,@"title":model.title,@"parameter":model.parameter};
            }
            [upData addObject:dic];
        }
        _firstGetTag = false;
        [self.delegate firstSelectItemWithPickerView:self withUpdata:upData];
    }
}

- (void)getPickerTagWithModel:(HFPickerViewModel*)model{
    [HFGetTag getTagWithKeyId:_keyId parentId:@"0" getType:EveryReload success:^(NSArray * _Nullable responseObject) {
        model.subModelArr = [NSMutableArray new];
        for (NSDictionary* tempDic in responseObject) {
            HFPickerViewSubModel* subModel = [[HFPickerViewSubModel alloc] init];
            subModel.title = tempDic[@"name"];
            subModel.mId = tempDic[@"linkageid"];
            [model.subModelArr addObject:subModel];
        }
        model.upData = ((HFPickerViewSubModel*)model.subModelArr.firstObject).mId;
        model.title = ((HFPickerViewSubModel*)model.subModelArr.firstObject).title;
        [self.pickerView reloadComponent:0];
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        if (self.dataArr.count > 1) {
           [self getSecondPickerTagWithModel:model.subModelArr.firstObject withComponent:1];
        } else {
            if ([self.delegate respondsToSelector:@selector(firstSelectItemWithPickerView:withUpdata:)]) {
                NSMutableArray* upData = [NSMutableArray new];
                for (HFPickerViewModel* model in self.dataArr) {
                    NSDictionary* dic;
                    if (model.title == nil && model.upData == nil) {
                        dic = @{@"upData":@"",@"title":@"",@"parameter":model.parameter};
                    }else{
                        dic = @{@"upData":model.upData,@"title":model.title,@"parameter":model.parameter};
                    }
                    [upData addObject:dic];
                }
                _firstGetTag = false;
                [self.delegate firstSelectItemWithPickerView:self withUpdata:upData];
            }
        }
    }];
}

- (void)getSecondPickerTagWithModel:(HFPickerViewSubModel*)model withComponent:(NSInteger)component{
    if (!model) {
        return;
    }
    HFPickerViewModel* superModel = self.dataArr[component];
    [HFGetTag getTagWithKeyId:_keyId parentId:model.mId getType:EveryReload success:^(NSArray * _Nullable responseObject) {
        superModel.subModelArr = [NSMutableArray new];
        for (NSDictionary* tempDic in responseObject) {
            HFPickerViewSubModel* subModel = [[HFPickerViewSubModel alloc] init];
            subModel.title = tempDic[@"name"];
            subModel.mId = tempDic[@"linkageid"];
            [superModel.subModelArr addObject:subModel];
        }
        superModel.upData = ((HFPickerViewSubModel*)superModel.subModelArr.firstObject).mId;
        superModel.title = ((HFPickerViewSubModel*)superModel.subModelArr.firstObject).title;
        if (component == self.dataArr.count - 1) {
            if ([self.delegate respondsToSelector:@selector(firstSelectItemWithPickerView:withUpdata:)]) {
                NSMutableArray* upData = [NSMutableArray new];
                for (HFPickerViewModel* model in self.dataArr) {
                    NSDictionary* dic;
                    if (model.title == nil && model.upData == nil) {
                        dic = @{@"upData":@"",@"title":@"",@"parameter":model.parameter};
                    }else{
                        dic = @{@"upData":model.upData,@"title":model.title,@"parameter":model.parameter};
                    }
                    [upData addObject:dic];
                }
                _firstGetTag = false;
                [self.delegate firstSelectItemWithPickerView:self withUpdata:upData];
            }
        }
        
        [self.pickerView reloadComponent:component];
        [self.pickerView selectRow:0 inComponent:component animated:YES];
        if (component + 1 < self.dataArr.count) {
            [self getSecondPickerTagWithModel:superModel.subModelArr.firstObject withComponent:component + 1];
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _firstGetTag = true;
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height / 3)];
        self.backView.backgroundColor = [UIColor whiteColor];
        
//        self.gestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 2 / 3)];
//        [self addSubview:self.gestureView];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
//        [self.gestureView addGestureRecognizer:tap];
        [self addSubview:self.backView];
        
//        UIButton* cancelButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton1.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - self.backView.frame.size.height);
//        [cancelButton1 addTarget:self action:@selector(cancelButtonDown) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:cancelButton1];
        
        UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(10, 10, 50, 20);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithR:241 G:97 B:86 alpha:1] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonDown) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:cancelButton];
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(frame.size.width - 10 - 50, 10, 50, 20);
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithR:241 G:97 B:86 alpha:1] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonDown) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:rightButton];
    }
    return self;
}

#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArr.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    HFPickerViewModel* model = self.dataArr[component];
    return model.subModelArr.count;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    HFPickerViewModel* model = self.dataArr[component];
//    HFPickerViewSubModel* subModel = model.subModelArr[row];
//    return subModel.title;
//}

//- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    HFPickerViewModel* model = self.dataArr[component];
//    HFPickerViewSubModel* subModel = model.subModelArr[row];
//    return [[NSAttributedString alloc] initWithString:subModel.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view{
    HFPickerViewModel* model = self.dataArr[component];
    HFPickerViewSubModel* subModel = model.subModelArr[row];
    UILabel *myView = [[UILabel alloc] init];
    
    myView.textAlignment = NSTextAlignmentCenter;
    
    myView.text = subModel.title;
    
    myView.font = [UIFont systemFontOfSize:16];
    
    myView.backgroundColor = [UIColor clearColor];
    
    return myView;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    HFPickerViewModel* model = self.dataArr[component];
    if (model.subModelArr.count > 0) {
        HFPickerViewSubModel* subModel = model.subModelArr[row];
        model.upData = subModel.mId;
        model.title = subModel.title;
        if (component + 1 < self.dataArr.count) {
            [self getSecondPickerTagWithModel:subModel withComponent:component + 1];
        }
    }
}

-(void)cancelButtonDown{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelWithPickerView:)]) {
//        [self.delegate cancelWithPickerView:self];
//    }
    [self hideSelf];
}

-(void)rightButtonDown{
    if (self.delegate) {
        if (self.pickerView) {
            if ([self.delegate respondsToSelector:@selector(finishSelectWithPickerView:withUpdata:)]) {
                NSMutableArray* upData = [NSMutableArray new];
                for (HFPickerViewModel* model in self.dataArr) {
                    NSDictionary* dic;
                    if (model.title == nil && model.upData == nil) {
                        dic = @{@"upData":@"",@"title":@"",@"parameter":model.parameter};
                    }else{
                        dic = @{@"upData":model.upData,@"title":model.title,@"parameter":model.parameter};
                    }
                    [upData addObject:dic];
                }
                [self.delegate finishSelectWithPickerView:self withUpdata:upData];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(finishSelectWithPickerView:withDate:)]) {
                [self.delegate finishSelectWithPickerView:self withDate:self.datePicker.date];
            }
        }
    }
    [self hideSelf];
}

-(void)showSelf{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.backView.frame = CGRectMake(0, self.frame.size.height / 3 * 2, self.frame.size.width, self.frame.size.height / 3);
    }];
}

-(void)hideSelf{
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height / 3);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
