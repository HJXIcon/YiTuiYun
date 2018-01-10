//
//  BankNameListVC.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/4.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "BankNameListVC.h"
#import "FXCityModel.h"
#import "YYModel.h"

@interface BankNameListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray * datas;
@property(nonatomic,strong) NSString * keyword;
@property(nonatomic,strong) UIButton * deletBtn;

@end

@implementation BankNameListVC
-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 34)];
    [deleteBtn addTarget:self action:@selector(delteTextField:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"homecancel"] forState:UIControlStateNormal];
    self.deletBtn = deleteBtn;
    self.deletBtn.hidden = YES;
    self.textField.rightView = deleteBtn;
    self.textField.rightViewMode=UITextFieldViewModeAlways;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.textField.leftView = view1;
    self.textField.leftViewMode=UITextFieldViewModeAlways;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.keyword = @"";
    self.textField.layer.cornerRadius = 34*0.5;
    self.textField.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;

    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tablecell"];
    
    [self getDataFromServer];
}

-(void)delteTextField:(UIButton *)btn{
    btn.hidden = YES;
    self.textField.text = @"";
}

-(void)getDataFromServer{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"keyword"] = self.keyword;
    [XKNetworkManager POSTToUrlString:GetBankListName parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
        if ([code isEqualToString:@"0"]) {
            
            [weakSelf.datas removeAllObjects];
            
            weakSelf.datas = [NSArray yy_modelArrayWithClass:[ChinaBankModel class] json:resultDict[@"rst"]];
            
            if (weakSelf.datas.count == 0) {
                [weakSelf showHint:@"无搜索结果"];
                [weakSelf.view endEditing:YES];
            }else{
                [weakSelf.view endEditing:YES];
            }
            [weakSelf.tableView reloadData];
            
            
        }else{
            [weakSelf showHint:code];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
        [textField resignFirstResponder];
        return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tablecell"];
    
    ChinaBankModel *model = self.datas[indexPath.row];
    cell.textLabel.text =model.bank_name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
    
}

- (IBAction)backup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)textFiedChange:(UITextView *)textField {
    
    
    
    UITextRange *selectedRange =textField.markedTextRange;
    if (selectedRange == nil || selectedRange.empty) {
            if (self.textField.text.length>=2) {
                self.keyword =self.textField.text;
                [self getDataFromServer];

        }
        
        
    }
    if (textField.text.length>0) {
        self.deletBtn.hidden = NO;
    }else{
        self.deletBtn.hidden = YES;
    }
    
    
}
- (BOOL)deptNameInputShouldChinese
{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:self.textField.text]) {
        return YES;
    }
    return NO;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChinaBankModel *model = self.datas[indexPath.row];
    [self.view endEditing:YES];
    if (self.blanknameblock) {
        self.blanknameblock(model.bank_name,model.bank_code);
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
@end
