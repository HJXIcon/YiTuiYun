//
//  FXUploadPhotoController.m
//  yituiyun
//
//  Created by fx on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXUploadPhotoController.h"
#import "FXUpLoadImageCell.h"
#import "ShowImageViewController.h"
#import "ZYQAssetPickerController.h"
#import "KNPickerController.h"
#import "FXNeedsListController.h"
#import "FXInsureTaskListController.h"

@interface FXUploadPhotoController ()<UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,FXUpLoadImageCellDelegate,ShowImageViewControllerDelegate,ZYQAssetPickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *imageBackgroundView;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, strong) FXUpLoadImageCell *imageCell;

@property (nonatomic, strong) UIView *headTipView;

@end

@implementation FXUploadPhotoController

- (NSMutableArray *)imageUrlArray{
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray new];
    }
    return _imageUrlArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.backBarButtonItem  = NULL;
    
//    if ([self.title isEqualToString:@"上传截图"]) {
//       self.navigationItem.hidesBackButton = YES;
//    }else{
//    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];

    [self.view addSubview:self.tableView];
    [self setRightButton];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightButton{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(upLoadClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
}
- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        if ([self.title isEqualToString:@"上传截图"] || [self.title isEqualToString:@"重新上传截图"]) {
            _tableView.tableHeaderView = self.headTipView;
        }
    }
    return _tableView;
}
- (UIView *)headTipView{
    if (!_headTipView) {
        _headTipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
        _headTipView.backgroundColor = kUIColorFromRGB(0xffffff);
        
        UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 20, 20)];
        starLabel.text = @"*";
        starLabel.textColor = MainColor;
        starLabel.textAlignment = NSTextAlignmentCenter;
        [_headTipView addSubview:starLabel];
        
        UILabel *tipFirLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 30, 50)];
        tipFirLabel.text = @"请截图证明您已成功向易推云支付相应金额，并将截图上传给我们";
        tipFirLabel.numberOfLines = 0;
        tipFirLabel.lineBreakMode = NSLineBreakByWordWrapping;
        tipFirLabel.textColor = kUIColorFromRGB(0x404040);
        tipFirLabel.textAlignment = NSTextAlignmentLeft;
        tipFirLabel.font = [UIFont systemFontOfSize:15];
        [_headTipView addSubview:tipFirLabel];
        
        UILabel *tipSecLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tipFirLabel.frame), self.view.frame.size.width - 30, 60)];
        tipSecLabel.text = @"若您使用实付宝支付：请点击支付宝首页左上角“账单”，找到向易推云支付的账单，点击到账单详情，截图";
        tipSecLabel.numberOfLines = 0;
        tipSecLabel.lineBreakMode = NSLineBreakByWordWrapping;
        tipSecLabel.textColor = kUIColorFromRGB(0x808080);
        tipSecLabel.textAlignment = NSTextAlignmentLeft;
        tipSecLabel.font = [UIFont systemFontOfSize:13];
        [_headTipView addSubview:tipSecLabel];
        
        UILabel *tipThdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tipSecLabel.frame), self.view.frame.size.width - 30, 60)];
        tipThdLabel.text = @"若您使用微信支付：请点击微信“我”，点击钱包，点击左上角“...”，选择“交易记录”，找到向易推云支付的记录，点击到交易详情，截图";
        tipThdLabel.numberOfLines= 0;
        tipThdLabel.lineBreakMode = NSLineBreakByWordWrapping;
        tipThdLabel.textColor = kUIColorFromRGB(0x808080);
        tipThdLabel.textAlignment = NSTextAlignmentLeft;
        tipThdLabel.font = [UIFont systemFontOfSize:13];
        [_headTipView addSubview:tipThdLabel];
    }
    return _headTipView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _imageCell.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXUpLoadImageCell *idCell = [FXUpLoadImageCell cellWithTableView:tableView];
    _imageCell = idCell;
    idCell.indexPath = indexPath;
    idCell.delegate = self;
    idCell.nameLabel.text = self.tipStr;
    idCell.maxNum = 3;
    [idCell.imageArray removeAllObjects];
    [idCell.imageArray addObjectsFromArray:self.imageUrlArray];
    [idCell makeView];
    idCell.selectionStyle = UITableViewCellSelectionStyleNone;
    idCell.accessoryType = UITableViewCellAccessoryNone;
    return idCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
//    UploadImageModel *model = _idImageArray[indexPath.row];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:_imageUrlArray];
    vc.delegate = self;
    vc.indexPath = indexPath;
    [vc seleImageLocation:tag];
    [vc showDeleteButton];
    pushToControllerWithAnimated(vc)
}
- (void)deleteImageTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath
{
//    UploadImageModel *model = _imageUrlArray[indexPath.row];
    [_imageUrlArray removeObjectAtIndex:tag];
    [_tableView reloadData];
}

- (void)addImageButtonClickWithIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {  // 拍照模式
        [self cameraClick];
    }else if (buttonIndex == 1){  // 手机相册
        [self albumForIDClick];
    }
}
- (void)cameraClick{//打开相机
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self.navigationController presentViewController:ipc animated:YES completion:nil];
    
}

- (void)albumForIDClick{//打开相册 id照 多张
    //    UploadImageModel *model = _idImageArray[_seledIndexPath.row];
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.delegate = self;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    [KNPickerController imagePickerController:self withTakePicturePickerViewController:picker subViewsCount:self.imageUrlArray.count maxCount:4];
}
- (BOOL) doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - ZYQAssetPickerControllerDelegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < assets.count;i++) {
        ALAsset *asset = assets[i];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [array addObject:image];
    }
    
    [self modifyPicture:array];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.1.1判断图片选择器是否允许编辑
    UIImage *resultImage = nil;
    if (picker.allowsEditing) {
        // 允许编辑
        resultImage = info[UIImagePickerControllerEditedImage];
    }else{
        resultImage = info[UIImagePickerControllerOriginalImage];
    }
    
    [self modifyPicture:[NSArray arrayWithObject:resultImage]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)modifyPicture:(NSArray *)array
{
    for (UIImage *image in array) {
        [self upLoadIcon:image];
    }
}

#pragma mark 上传
- (void)upLoadIcon:(UIImage *)image{
    [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *string = [NSString stringWithFormat:@"%@", responseObject[@"url"]];
        if ([string rangeOfString:@","].location == NSNotFound) {
            [self.imageUrlArray addObject:string];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [self upLoadIcon:image];//失败的时候重试
    }];
}
//提交 一种是需求上传凭证 一种是购买保险上传截图
- (void)upLoadClick{
    if ([self.title isEqualToString:@"上传付款凭证"] || [self.title isEqualToString:@"重新上传付款凭证"]) {
        __block typeof(self) weakSelf = self;
        NSMutableDictionary *mutDic = [NSMutableDictionary new];
        for (NSInteger i = 0 ; i < self.imageUrlArray.count; i++) {
            NSDictionary* dic = @{@"url":_imageUrlArray[i],
                                  @"sort":[NSString stringWithFormat:@"%zd",i],
                                  @"alt":[NSString stringWithFormat:@"%zd",i]
                                  };
            [mutDic setObject:dic forKey:[NSString stringWithFormat:@"%zd", i]];
        }
        NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=add.demand"];
        UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
        NSDictionary *dic = @{@"demandid":self.dataID,
                              @"paymentImg":mutDic,
                              @"certificate":@"3",
                              };
        [weakSelf showHudInView:weakSelf.view hint:@"提交中..."];
        [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [weakSelf hideHud];
            if ([responseObject[@"errno"] isEqualToString:@"0"]) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(uploadSuccess)]) {
                    [self.delegate uploadSuccess];
                }
                for (UIViewController *viewC in self.navigationController.viewControllers) {
                    if ([viewC isKindOfClass:[FXNeedsListController class]]) {
                        [self.navigationController popToViewController:viewC animated:YES];
                    }
                }
            } else {
                [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            [weakSelf hideHud];
            [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        }];

    }else if ([self.title isEqualToString:@"上传截图"]){//初次 购买保险上传
        __block typeof(self) weakSelf = self;
        NSMutableDictionary *mutDic = [NSMutableDictionary new];
        for (NSInteger i = 0 ; i < self.imageUrlArray.count; i++) {
            NSDictionary* dic = @{@"url":_imageUrlArray[i],
                                  @"sort":[NSString stringWithFormat:@"%zd",i],
                                  @"alt":[NSString stringWithFormat:@"%zd",i]
                                  };
            [mutDic setObject:dic forKey:[NSString stringWithFormat:@"%zd",i]];
        }
        NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=user.updateInsurance"];
        UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
        NSDictionary *dic = @{@"orderNo":self.dataID,
                              @"payImg":mutDic,
                              @"payStatus":@"1"
                              };
        [weakSelf showHudInView:weakSelf.view hint:@"提交中..."];
        [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [weakSelf hideHud];
            if ([responseObject[@"errno"] isEqualToString:@"0"]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"截图已上传，后台人员会进行审核，审核通过即为您投保" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                alertView.tag = 20;
                [alertView show];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            [weakSelf hideHud];
            NSLog(@"%@",error);
        }];
    }else if ([self.title isEqualToString:@"重新上传截图"]){//保险审核失败  重新上传截图，仅修改截图
        __block typeof(self) weakSelf = self;
        NSMutableDictionary *mutDic = [NSMutableDictionary new];
        for (NSInteger i = 0 ; i < self.imageUrlArray.count; i++) {
            NSDictionary* dic = @{@"url":_imageUrlArray[i],
                                  @"sort":[NSString stringWithFormat:@"%zd",i],
                                  @"alt":[NSString stringWithFormat:@"%zd",i]
                                  };
            [mutDic setObject:dic forKey:[NSString stringWithFormat:@"%zd",i]];
        }
        NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=user.updateInsurance"];
        UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
        NSDictionary *dic = @{@"orderNo":self.dataID,
                              @"payImg":mutDic,
                              @"payStatus":@"1"
                              };
        [weakSelf showHudInView:weakSelf.view hint:@"提交中..."];
        [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [weakSelf hideHud];
            if ([responseObject[@"errno"] isEqualToString:@"0"]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"截图已上传，后台人员会进行审核，审核通过即为您投保" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                alertView.tag = 20;
                [alertView show];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            [weakSelf hideHud];
            NSLog(@"%@",error);
        }];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 20) {
        if (buttonIndex == 0) {
            for (UIViewController *viewC in self.navigationController.viewControllers) {
                if ([viewC isKindOfClass:[FXInsureTaskListController class]]) {
                    [self.navigationController popToViewController:viewC animated:YES];
                }
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
