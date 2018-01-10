//
//  HomeSearchProjectVcView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/6.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "HomeSearchProjectVcView.h"
#import "HomeTableViewCell.h"
#import "ProjectDetailViewController.h"

@interface HomeSearchProjectVcView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
/**textField */
@property(nonatomic,strong) UITextField * textfield;
/**<#type#> */
@property(nonatomic,strong) UIButton * deleBtn;
/** */
@property(nonatomic,strong) UIButton * searchBtn;

/**tableView */
@property(nonatomic,strong) UITableView * tableView;

/**数据源 */
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong) UIView * coverView;

@end

@implementation HomeSearchProjectVcView
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
        _coverView.backgroundColor = UIColorFromRGBString(@"0xededed");
    }
    return _coverView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGBString(@"0xededed");
    [self setupView];
 [self.view addSubview:self.coverView];
    
   }

#pragma mark - 收索数据
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
                [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homecell"];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGBString(@"0xededed");
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(void)setupView{
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(40), 44)];
   
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchDatas) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
   
    self.searchBtn = btn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WRadio(270), 32)];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.layer.cornerRadius = 16;
    titleView.clipsToBounds = YES;
    self.navigationItem.titleView = titleView;
    
    UITextField *textField = [[UITextField alloc]initWithFrame:titleView.bounds];
    textField.placeholder = @"请输入项目名称";
    [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    textField.tintColor = [UIColor blueColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.returnKeyType=UIReturnKeySearch;
    textField.delegate = self;
    textField.textColor = [UIColor blackColor];
    self.textfield = textField;
    
    [titleView addSubview:textField];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 32)];
    textField.leftView = leftView;
    textField.leftViewMode=UITextFieldViewModeAlways;
    
    UIButton *rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(65), HRadio(15))];
    self.deleBtn = rightbtn;
    self.deleBtn.hidden = YES;
    [rightbtn setImage:[UIImage imageNamed:@"homecancel"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(rightDelte:) forControlEvents:UIControlEventTouchUpInside];
    textField.rightView = rightbtn;
    textField.rightViewMode=UITextFieldViewModeAlways;

}

-(void)textFieldChange:(UITextField *)text{
    if (text.text.length>0) {
        self.deleBtn.hidden = NO;
    }else{
        self.deleBtn.hidden = YES;
    }
}
-(void)rightDelte:(UIButton *)btn{
    btn.hidden = YES;
    self.textfield.text = @"";
}
#pragma mark - textField代理

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchDatas];
    return YES;
}

#pragma mark - 发送查找请求
-(void)searchDatas{
    
    [_textfield resignFirstResponder];

    if ([_textfield.text isEqualToString:@""] ) {
        [self showHint:@"请输入收索的内容"];
        return;
    }

    [self.dataArray removeAllObjects];
    
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    NSDictionary *dic = [USERDEFALUTS objectForKey:@"location"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"t"] = @"1";
    params[@"status"] = @"6";
    params[@"provid"] = dic[@"provinceId"];
    params[@"cityid"] = dic[@"cityId"];
    params[@"keyword"] = self.textfield.text;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.taskList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"errno"] integerValue] == 0) {
            
            self.coverView.hidden = YES;
            
             weakSelf.dataArray = [homeTableModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
            [weakSelf.view addSubview:self.tableView];
            
            [weakSelf.tableView reloadData];
            if (weakSelf.dataArray.count == 0) {
                [weakSelf showHint:@"无相关内容"];
            
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
       
        
    }];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"homecell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    homeTableModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count == 0) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   return HRadio(141);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    homeTableModel *projectModel = self.dataArray[indexPath.row];
    
    UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
    if ([userInfoModel.userID isEqualToString:@"0"]) {
        [ZQ_CallMethod againLogin];
    } else {
        ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] initWithDataId:projectModel.demandid WithType:userInfoModel.identity WithWhere:1];
        pushToControllerWithAnimated(vc)
    }

}

@end
