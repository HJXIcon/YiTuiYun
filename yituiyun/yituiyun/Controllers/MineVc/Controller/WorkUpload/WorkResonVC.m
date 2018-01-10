//
//  WorkResonVC.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/30.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "WorkResonVC.h"

@interface WorkResonVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property(nonatomic,strong) NSString * textString;

@end

@implementation WorkResonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyBorad)];
    [self.view addGestureRecognizer:tap];
}


-(void)cancelKeyBorad{
    [self.view endEditing:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.textViewPlaLabel.hidden  = YES;
    
}

-(void)textViewDidChange:(UITextView *)textView{
    
    
    
    
    UITextRange *selectedRange = [_textView markedTextRange];
    
    
    //获取高亮部分
    UITextPosition *position = [_textView positionFromPosition:selectedRange.start offset:0];
    
    
    if (!position) {
        if (_textView.text.length >= 500) {
            self.numberLabel.text = @"0个字";
            self.textView.text = self.textString;
        } else {
            
            if (textView.text.length == 0) {
                self.textViewPlaLabel.hidden = NO;
            }else{
                self.textViewPlaLabel.hidden = YES;
            }
            
            NSInteger number = 500 -textView.text.length;
            self.numberLabel.text = [NSString stringWithFormat:@"%zd个字", number];
            self.textString = textView.text;
           }
    }

    

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text
{
    //如果为回车则将键盘收起
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)dataFromServer{
    
    
    if ([self.textString isEqualToString:@""]) {
        [self showHint:@"请填写不通过原因"];
        return ;
    }
    
    [SVProgressHUD showWithStatus:@"加载中.."];
    MJWeakSelf
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parm[@"nodeid"] = self.nodeID;
    parm[@"user_id"] = model.userID;
    parm[@"t"] = @(2);
    parm[@"remark"] = self.textString;
    
    
    
    [XKNetworkManager POSTToUrlString:CompanyNeedShenHeSucess parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
        NSString *reson = [NSString stringWithFormat:@"%@",resultDict[@"errmsg"]];
       
//        NSLog(@"------_%@---",JSonDictionary);
        if ([code isEqualToString:@"0"]) {
            [weakSelf showHint:@"已提交不通过审核理由"];
            
    [weakSelf.navigationController popToViewController:weakSelf.navigationController.childViewControllers[1] animated:YES];
        
        
        }else{
            [weakSelf showHint:reson];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];

    
}
- (IBAction)makeSureClick:(id)sender {
    
    [self dataFromServer];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
