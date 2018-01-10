//
//  EMyTeamViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMyTeamViewController.h"
#import "EMyTeamCell.h"
#import "EMyTeamViewModel.h"
#import "EAddMemberViewController.h"

#define NODataTag 996
@interface EMyTeamViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchTextF;
@property (nonatomic, strong) UITableView *tableView;
/// 背景图标
@property (nonatomic, weak) UIButton *bgBtn;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) NSMutableArray *myDataArr;
@property (nonatomic, strong) NSMutableArray <EMyTeamListModel *>*lists;
/// 搜索的结果
@property (nonatomic, strong) NSMutableArray<EMyTeamListModel *> *searchResult;
/// 是否显示搜索结果
@property (nonatomic, assign) BOOL isShowSearchResult;
@end

@implementation EMyTeamViewController
#pragma mark - *** lazy load
- (NSMutableArray<EMyTeamListModel *> *)searchResult{
    if (_searchResult == nil) {
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}
- (NSMutableArray<EMyTeamListModel *> *)lists{
    if (_lists == nil) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = EBackgroundColor;
    }
    return _tableView;
}

- (UITextField *)searchTextF{
    if (_searchTextF == nil) {
        _searchTextF = [[UITextField alloc]init];
        _searchTextF.leftViewMode = UITextFieldViewModeAlways;
        UIView *leftView = [[UIView alloc]init];
        leftView.frame = CGRectMake(0, 0, 15 + 43 * 0.5, 43 *0.5);
        leftView.centerY = _searchTextF.centerY;
        UIImageView *leftImageV = [[UIImageView alloc]init];
        leftImageV.frame = CGRectMake(15, 0, 43 * 0.5, 43 *0.5);
        leftImageV.image = [UIImage imageNamed:@"mine_sousuo"];
        [leftView addSubview:leftImageV];
        _searchTextF.leftView = leftView;
        _searchTextF.size = CGSizeMake(E_RealWidth(330), E_RealHeight(40));
        _searchTextF.cornerRadius = E_RealHeight(20);
        _searchTextF.backgroundColor = [UIColor whiteColor];
        [_searchTextF addTarget:self action:@selector(searchTextAction:) forControlEvents:UIControlEventEditingDidEndOnExit | UIControlEventEditingDidEnd];
        _searchTextF.returnKeyType = UIReturnKeySearch;
        _searchTextF.delegate = self;
        
    }
    return _searchTextF;
}


#pragma mark - *** cycle life
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的团队";
    [self setupUI];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - *** Private Method
/// 加载数据
- (void)loadData{
    self.lists = nil;
    [EMyTeamViewModel getMyGroupMember:^(NSArray<EMyTeamListModel *> *myTeamLists) {
        
        if (myTeamLists.count == 0) {
            
        }
        else{
            [self removeNoDataView];
            [myTeamLists enumerateObjectsUsingBlock:^(EMyTeamListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.existUserIds containsObject:obj.childUserId]) {
                    obj.isSelect = YES;
                }
            }];
            [self.lists addObjectsFromArray:myTeamLists];
            [self changeSelectBtnStatu];
            [self.tableView reloadData];
        }
    }];
}

- (void)setupUI{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加成员" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction)];
    
    [self.view addSubview:self.searchTextF];
    [self.searchTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 + E_StatusBarAndNavigationBarHeight);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(330), E_RealHeight(40)));
    }];
    
     /// bottomView
    if (self.isDemandAddMember) {
        UIView *bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        [self.view bringSubviewToFront:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
        
        
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bgBtn = bgBtn;
        [bgBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [bgBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f0e9d8"]] forState:UIControlStateSelected];
        [bottomView addSubview:bgBtn];
        [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(bottomView);
            make.width.mas_equalTo(kScreenW * 0.5);
        }];
        
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"mine_gou"] forState:UIControlStateNormal];
        self.selectBtn.userInteractionEnabled = NO;
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"mine_goushang"] forState:UIControlStateSelected];
        [bgBtn addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgBtn);
            make.width.height.mas_equalTo(22);
            make.left.mas_equalTo(bottomView).offset(E_RealWidth(55));
        }];
        
        UILabel *allLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHexString:@"616161"] text:@"全选" textAlignment:0];
        [bgBtn addSubview:allLabel];
        [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgBtn);
            make.left.mas_equalTo(self.selectBtn.mas_right).offset(E_RealWidth(15));
        }];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setBackgroundImage:[UIImage imageWithColor:EThemeColor] forState:UIControlStateNormal];
        sureBtn.adjustsImageWhenHighlighted = NO;
        [bottomView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.mas_equalTo(bottomView);
            make.width.mas_equalTo(kScreenW * 0.5);
        }];
        
        [self.view addSubview:self.tableView];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.searchTextF.mas_bottom).offset(10);
            make.bottom.mas_equalTo(bottomView.mas_top);
        }];
    }
    else {
        
        [self.view addSubview:self.tableView];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.searchTextF.mas_bottom).offset(10);
        }];
        
    }
    
    
    /// 无数据
    [self showNoDataView];
    
    
}

- (void)removeNoDataView{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == NODataTag) {
            [obj removeFromSuperview];
        }
    }];
}

/**
 无数据
 */
- (void)showNoDataView{
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = EBackgroundColor;
    bgView.tag = NODataTag;
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"chatu"];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.width.height.mas_equalTo(E_RealWidth(95.0));
        make.top.mas_equalTo(bgView).offset(E_RealHeight(140) + E_StatusBarAndNavigationBarHeight);
    }];
    
    
    UILabel *label = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"0x707070"] text:@"团队就你一个人哦~寂寞吧" textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView);
        make.top.mas_equalTo(imageView.mas_bottom).offset(E_RealHeight(25));
    }];
    
    
    // 添加队友
    UIButton *addBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:18] normalColor:[UIColor whiteColor] selectColor:nil title:@"添加队友" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(addAction)];
    [self.view addSubview:addBtn];
    UIImage *nornamlImage = [UIImage imageGradientWithFrame:CGRectMake(0, 0, E_RealWidth(300), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
    [addBtn setBackgroundImage:nornamlImage forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
    addBtn.cornerRadius = E_RealHeight(25);
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(E_RealHeight(20));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(E_RealWidth(300));
        make.height.mas_equalTo(E_RealHeight(50));
    }];
    
    
    
}

#pragma mark - *** Actions
- (void)rightItemAction{
    [self.navigationController pushViewController:[[EAddMemberViewController alloc]init] animated:YES];
}

- (void)sureAction{
    __block BOOL hasSelect = NO;
    [self.lists enumerateObjectsUsingBlock:^(EMyTeamListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            hasSelect = YES;
        }
    }];
    
    if (!hasSelect) {
        [self showHint:@"请选择~"];
        return;
    }
    
    
    NSMutableString *childUserIdStr = [NSMutableString string];
    [self.lists enumerateObjectsUsingBlock:^(EMyTeamListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            [childUserIdStr appendString:obj.childUserId];
            [childUserIdStr appendString:@","];
        }
        
    }];
    [childUserIdStr deleteCharactersInRange:NSMakeRange(childUserIdStr.length - 1, 1)];
    [EMyTeamViewModel demandAddMemberWithChildUserIdStr:childUserIdStr demandPriceId:self.demandPriceId completion:^{
        
    }];
}
/// 搜索
- (void)searchTextAction:(UITextField *)searchTextF{
    
    NSString *searchText = searchTextF.text;
    //需要事先清空存放搜索结果的数组
    [self.searchResult removeAllObjects];
    
    //加个多线程，否则数量量大的时候，有明显的卡顿现象
    //这里最好放在数据库里面再进行搜索，效率会更快一些
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        if (searchText !=nil && searchText.length>0) {
             self.isShowSearchResult = YES;
            
            //遍历需要搜索的所有内容
            for (EMyTeamListModel *model in self.lists) {
                
                NSString *tempStr = model.childUserName;
                
                // 是否是纯数字
                if ([JXCheckTool isPureFloat:searchText]) {
                    tempStr = model.childUserMobile;
                }
                
                //----------->把所有的搜索结果转成成拼音
                NSString *pinyin = [self transformToPinyin:tempStr];
                JXLog(@"pinyin--%@",pinyin);
                
                if ([pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                    //把搜索结果存放self.searchResult数组
                    [self.searchResult addObject:model];
                }
                
               
            }
        }else{
            self.isShowSearchResult = NO;
            self.searchResult = [NSMutableArray arrayWithArray:self.lists];
        }
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    });
    
    
}

- (NSString *)transformToPinyin:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];
                //区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
        }
        [allString appendString:@","];
        count ++;
    }
    NSMutableString *initialStr = [NSMutableString new];
    //拼音首字母
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    return allString;
}


/// 添加成员
- (void)addAction{
    [self.navigationController pushViewController:[[EAddMemberViewController alloc]init] animated:YES];
}
- (void)allSelectAction:(UIButton *)button{
    button.selected = !button.selected;
    self.selectBtn.selected = button.selected;
    [self.lists enumerateObjectsUsingBlock:^(EMyTeamListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = button.selected;
    }];
    [self.tableView reloadData];
}

- (void)changeSelectBtnStatu{
    __block BOOL isSelect = YES;
    [self.lists enumerateObjectsUsingBlock:^(EMyTeamListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect == NO) {
            isSelect = NO;
        }
    }];
    self.selectBtn.selected = isSelect;
    self.bgBtn.selected = isSelect;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isShowSearchResult) {
        return self.searchResult.count;
    }
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMyTeamCell *cell = [EMyTeamCell cellForTableView:tableView];
    if (self.isShowSearchResult) {
        cell.model = self.searchResult[indexPath.row];
        // cell背景颜色
        if (self.isDemandAddMember) {
            cell.backgroundColor = self.searchResult[indexPath.row].isSelect == YES ? [UIColor colorWithHexString:@"#eeeeee"] : [UIColor whiteColor];
        }
    }
    else{
        cell.model = self.lists[indexPath.row];
        // cell背景颜色
        if (self.isDemandAddMember) {
            cell.backgroundColor = self.lists[indexPath.row].isSelect == YES ? [UIColor colorWithHexString:@"#eeeeee"] : [UIColor whiteColor];
        }
    }
    
    cell.selectBtn.hidden = !self.isDemandAddMember;
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return !self.isDemandAddMember;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JXWeak(self);
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该成员？" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        /// 在这里实现删除操
        [EMyTeamViewModel delGroupMemberWithId:weakself.lists[indexPath.row].childUserId completion:^{
            
            [weakself.lists removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            /// 加载数据
            [weakself loadData];
        }];
        
    }]];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isDemandAddMember) {
        EMyTeamListModel *model = self.lists[indexPath.row];
        model.isSelect = !model.isSelect;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        /// 监听全部按钮
        [self changeSelectBtnStatu];
    }
}

#pragma mark - *** UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
