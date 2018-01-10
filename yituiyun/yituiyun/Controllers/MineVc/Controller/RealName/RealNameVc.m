//
//  RealNameVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/20.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "RealNameVc.h"
#import "NSString+LHKExtension.h"

@interface RealNameVc ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *zhengmianicon;
@property (weak, nonatomic) IBOutlet UIButton *fanmianicon;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *shengnumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *registeredAdressField;

@property(nonatomic,assign) NSInteger * type; //1 正面  //2反面

@property(nonatomic,strong) UIImage * zhengImage;
@property(nonatomic,strong) UIImage * fangImage;
@property(nonatomic,strong) NSMutableArray * imgsArray;

//几个面板
@property (weak, nonatomic) IBOutlet UIView *panViewing;
@property (weak, nonatomic) IBOutlet UIView *panViewSuccess;
@property (weak, nonatomic) IBOutlet UIView *panViewError;
@property (weak, nonatomic) IBOutlet UILabel *successnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *successShenNoLabel;

//审核中的内容
@property (weak, nonatomic) IBOutlet UILabel *nameIngLabel;
@property (weak, nonatomic) IBOutlet UILabel *shenNoIngLabel;
@property (weak, nonatomic) IBOutlet UILabel *upIngLabel;

@property(nonatomic,strong) UIView * coverView;

@end

@implementation RealNameVc


-(UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _coverView.backgroundColor = [UIColor whiteColor];
        
    }
    return _coverView;
}

- (IBAction)errorPanViewClick:(id)sender {
    
    self.panViewing.hidden = YES;
    self.panViewError.hidden = YES;
    self.panViewSuccess.hidden = YES;
    
    

}
- (IBAction)makesureClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self.nameTextField.text isEqualToString:@""]||self.nameTextField.text.length<2 ) {
        [self showHint:@"请填写合法姓名"];
        return ;
    }
    
    if ([self.shengnumberTextField.text isEqualToString:@""]) {
        [self showHint:@"请填写身份证号码"];
        return;
    }
    
    if ([self.registeredAdressField.text isEqualToString:@""]) {
        [self showHint:@"请填写户口所在地"];
        return;
    }

    
    if (![NSString judgeIdentityStringValid:self.shengnumberTextField.text]) {
        [self showHint:@"身份证不合法"];
        return ;
    }
    
    if (self.fangImage == nil ) {
        [self showHint:@"请上传反面身份证"];
        return;
    }
    if (self.zhengImage == nil ) {
        [self showHint:@"请上传证面身份证"];
        return;
    }
    
    
    [self uploadImageWith:self.zhengImage];

}

-(NSMutableArray *)imgsArray{
    if (_imgsArray == nil) {
        _imgsArray = [NSMutableArray array];
    }
    return _imgsArray;
}


-(void)uploadImageWith:(UIImage *)image{
    //上传图片
    
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"上传中.."];
    
    [XKNetworkManager xk_uploadImages:@[image] toURL:FileUpload parameters:nil progress:^(CGFloat progress) {
        
        NSString *progresstr = [NSString stringWithFormat:@"%.2f%%",progress*100];
        
        
        
    } success:^(id responseObject) {
        
        NSDictionary *dictdata = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [SVProgressHUD dismiss];
        if ([dictdata[@"errno"] isEqualToString:@"0"]) {
            
            if (weakSelf.imgsArray.count<2) {
                
                [weakSelf.imgsArray addObject:dictdata[@"url"]];
                [weakSelf uploadImageWith:weakSelf.fangImage];
 
            }else{
                //其他操作
                [weakSelf upLoadToServer];
            }
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        [SVProgressHUD dismiss];
        
    }];
  
}

-(void)upLoadToServer{
    MJWeakSelf
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict[@"memberid"] = model.userID;
    parmDict[@"idcard_no"] = self.shengnumberTextField.text;
    parmDict[@"real_name"] = self.nameTextField.text;
    parmDict[@"ascription"] = self.registeredAdressField.text;
    parmDict[@"identityCard1"] = self.imgsArray[0];
    parmDict[@"identityCard2"] = self.imgsArray[1];
    
    
    [XKNetworkManager POSTToUrlString:RealNameCerfi parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
//        NSLog(@"=========%@=======",JSonDictionary);
        
        NSDictionary *resutDic = JSonDictionary;
        
        NSString *errnoString = [NSString stringWithFormat:@"%@",resutDic[@"errno"] ];
        
        if ([errnoString isEqualToString:@"0"]) {
        
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelf showHint:errnoString];
        }

        
        
    } failure:^(NSError *error) {
//        NSLog(@"----%@",error.localizedDescription);
        [weakSelf showHint:error.localizedDescription];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.coverView];
    self.type=100;
    self.zhengImage =nil;
    self.fangImage = nil;
    [MobClick event:@"gerenzhongxinshiming"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyborad)];
    [self.view addGestureRecognizer:tap];
    
    [self getRealNameStaus];
   
    [self setupNav];
}
- (void)setupNav{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(leftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)leftBarButtonItem{
    if (self.where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];

    } else {
        
        [self.navigationController popViewControllerAnimated:YES];

    }
}





-(void)getRealNameStaus{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parmDict[@"memberid"] = model.userID;
    [XKNetworkManager POSTToUrlString:RealNameCerfiStatus parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
    NSDictionary *resutDic=JSonDictionary;
        
        
       
        NSString *errnoString = [NSString stringWithFormat:@"%@",resutDic[@"errno"] ];
        
        if ([errnoString isEqualToString:@"0"]) {
            //0 未认证 //1 审核中  //2 已认证 //3 认证失败
            
            self.coverView.hidden = YES;
            
            NSInteger status = [resutDic[@"rst"][@"is_authentication"] integerValue];
            
            if (status == 0) {
                weakSelf.panViewing.hidden = YES;
                weakSelf.panViewError.hidden = YES;
                weakSelf.panViewSuccess.hidden = YES;
            }else if (status == 1){
                weakSelf.panViewSuccess.hidden = YES;
                weakSelf.panViewError.hidden = YES;
                weakSelf.panViewing.hidden = NO;
                
                
                //
                //名字
                NSString *name_zhing=resutDic[@"rst"][@"real_name"];
                NSRange localRnager = NSMakeRange(1, name_zhing.length-1);
                NSString *nameshijiNo = [name_zhing stringByReplacingCharactersInRange:localRnager withString:@"**"];
                weakSelf.nameIngLabel.text = nameshijiNo;
                
                //身份证
                NSString *shenfenNo=resutDic[@"rst"][@"idcard_no"];
                NSRange shenRnager = NSMakeRange(3, shenfenNo.length-6);
                NSString *shenfenshijiNo = [shenfenNo stringByReplacingCharactersInRange:shenRnager withString:@"*************"];
                weakSelf.shenNoIngLabel.text = shenfenshijiNo;

                
                
                NSString  *timeStr =resutDic[@"rst"][@"auth_apply_time"];
                
                NSString *timeString = [NSString stringWithFormat:@"(提交时间:%@;预计1到2个工作日审核完成)",timeStr];
                
                weakSelf.upIngLabel.text = timeString;
                
                
                
            }else if (status == 2){
                weakSelf.panViewSuccess.hidden = NO;
                weakSelf.panViewError.hidden = YES;
                weakSelf.panViewing.hidden = YES;

                
                //名字
                NSString *name_zh=resutDic[@"rst"][@"real_name"];
                NSRange localRnager = NSMakeRange(1, name_zh.length-1);
                NSString *nameshijiNo = [name_zh stringByReplacingCharactersInRange:localRnager withString:@"**"];
                weakSelf.successnameLabel.text = nameshijiNo;
                
                //身份证
                NSString *shenfenNo=resutDic[@"rst"][@"idcard_no"];
                NSRange shenRnager = NSMakeRange(3, shenfenNo.length-6);
                NSString *shenfenshijiNo = [shenfenNo stringByReplacingCharactersInRange:shenRnager withString:@"*************"];
                weakSelf.successShenNoLabel.text = shenfenshijiNo;

                [[NSUserDefaults standardUserDefaults] setObject:name_zh forKey:PersonCenterName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:shenfenNo forKey:PersonCenterCarId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }else if (status == 3){
                weakSelf.panViewing.hidden = YES;
                weakSelf.panViewError.hidden = NO;
                weakSelf.panViewSuccess.hidden = YES;

            }
            
        }else{
            [weakSelf showHint:@"服务器连接错误"];
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf showHint:error.localizedDescription];
        [SVProgressHUD dismiss];
    }];
}
-(void)closeKeyborad{
    [self.view endEditing:YES];
}
- (IBAction)zhengmainClick:(id)sender {
    self.type = 1;
    [self.view endEditing:YES];
    [self actionsheetDidClick];
}

- (IBAction)fanmianClick:(id)sender {
    self.type = 2;
    [self.view endEditing:YES];
    [self actionsheetDidClick];
}

-(void)actionsheetDidClick{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:self.view];
 }

#pragma mark---actionSheet的代理

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {//相机
        
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType =   UIImagePickerControllerSourceTypeCamera;
        ipc.allowsEditing = YES;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
        
        
    }else if (buttonIndex == 1){//相册
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        [self.navigationController presentViewController:ipc animated:YES completion:nil];
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //从系统相册拿到一张图片 用于头像
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *resultImage = nil;
    
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        if(picker.allowsEditing){
            resultImage = info[UIImagePickerControllerEditedImage];
        }else{
            resultImage = info[UIImagePickerControllerOriginalImage];
        }
        
        if (self.type == 1) {
            [self.zhengmianicon setImage:resultImage forState:UIControlStateNormal];
            self.zhengImage = resultImage;
        }else{
            [self.fanmianicon setImage:resultImage forState:UIControlStateNormal];
            self.fangImage = resultImage;

        }

    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}



@end
