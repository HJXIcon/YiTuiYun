//
//  EAddMemberViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EAddMemberViewController.h"
#import "EMyTeamListModel.h"
#import "EAddMemberCell.h"
#import "EAddMemberViewModel.h"
#import "EUserModel.h"

@interface EAddMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchTextF;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <EMyTeamListModel *>*lists;
@property (nonatomic, strong) EUserModel *model;
@end

@implementation EAddMemberViewController
#pragma mark - *** lazy load
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
        [_searchTextF addTarget:self action:@selector(searchTextAction:) forControlEvents:UIControlEventEditingChanged];
        _searchTextF.placeholder = @"请输入手机号搜索";
        _searchTextF.delegate = self;
    }
    return _searchTextF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - *** Private Method
- (void)setupUI{
    self.navigationItem.title = @"添加成员";
    
    [self.view addSubview:self.searchTextF];
    [self.searchTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 + E_StatusBarAndNavigationBarHeight);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(330), E_RealHeight(40)));
    }];
   
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchTextF.mas_bottom).offset(10);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    
}

#pragma mark - *** Actions
- (void)searchTextAction:(UITextField *)textF{
    if (textF.text.length < 11) {
        self.model = nil;
        [self.tableView reloadData];
        return;
    }
    
    [EAddMemberViewModel searchMemberWithMobile:self.searchTextF.text completion:^(EUserModel *model) {
        
        self.model = model;
        [self.tableView reloadData];
    }];
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model == nil ? 0 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JXWeak(self);
    EAddMemberCell *cell = [EAddMemberCell cellForTableView:tableView];
    
    cell.model = self.model;
    cell.addBlock = ^{
        [EAddMemberViewModel addGroupMemberWithChildUserId:self.model.userId completion:^{
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    };
    return cell;
    
    
}

#pragma mark - *** UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.searchTextF) {
         if (range.location >= 11) return NO;
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

@end
