//
//  NodeError.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/3.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "NodeError.h"
#import "TaskNodeModel.h"
#import "ChooseImageCell.h"
#import "CancelTaskCell.h"
#import "UploadTextModel.h"
#import "UploadImageModel.h"
#import "InputTextFieldViewController.h"
#import "ShowImageViewController.h"
#import "ZYQAssetPickerController.h"
#import "KNPickerController.h"
#import "TaskNodeHeadView.h"

@interface NodeError ()<UITableViewDataSource,UITableViewDelegate,ChooseImageCellDelegate,InputTextFieldViewControllerDelegate,ShowImageViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>
@property (nonatomic, strong) TaskNodeModel *model;
@property (nonatomic, strong) ChooseImageCell *chooseImageCell;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *seledIndexPath;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) NSMutableArray *textDataArray;
@property (nonatomic, strong) NSMutableArray *imageDataArray;


/**头部控件 */
@property(nonatomic,strong) TaskNodeHeadView * headView;
@end

@implementation NodeError
#pragma mark-headView
-(TaskNodeHeadView *)headView{
    if (_headView == nil) {
        _headView = [TaskNodeHeadView nodeHeadView];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 135);
        _headView.FistBtn.selected = YES;
        _headView.SecondBtn.selected = NO;
        _headView.arrorw2Btn.selected = NO;
        _headView.threeBtn.selected= NO;
        _headView.arrorw1Btn.selected = NO;
        _headView.descLabel.text = @"上传的任务资料凭证不符合要求,请重新提交";
        _headView.timePanLabel.hidden = NO;
    }
    return _headView;
}


- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithWhere:(NSInteger)where{
    self = [super init];
    if (self) {
        self.model = taskNodeModel;
        self.textDataArray = [NSMutableArray array];
        self.imageDataArray = [NSMutableArray array];
        self.textArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.where = where;
    }
    return self;
}

- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithTextDataArray:(NSArray *)textDataArray WithImageDataArray:(NSArray *)imageDataArray WithWhere:(NSInteger)where{
    self = [super init];
    if (self) {
        self.model = taskNodeModel;
        self.where = where;
       
        self.textDataArray = [NSMutableArray arrayWithArray:textDataArray];
        self.imageDataArray = [NSMutableArray arrayWithArray:imageDataArray];
    }
    return self;
}

#pragma mark 请求网络数据
- (void)dataArrayFrom {
  
    [_textDataArray removeAllObjects];
    [_imageDataArray removeAllObjects];
    for (NSDictionary *subDic in _textArray) {
        UploadTextModel *model = [[UploadTextModel alloc] init];
        model.taskName = [NSString stringWithFormat:@"%@",  subDic[@"name_zh"]];
        model.taskField = [NSString stringWithFormat:@"%@",  subDic[@"name_en"]];
        [_textDataArray addObject:model];
    }
    for (NSDictionary *subDic in _imageArray) {
        UploadImageModel *model = [[UploadImageModel alloc] init];
        model.taskName = [NSString stringWithFormat:@"%@",  subDic[@"name_zh"]];
        model.taskField = [NSString stringWithFormat:@"%@",  subDic[@"name_en"]];
        model.imageArray = [NSMutableArray array];
        [_imageDataArray addObject:model];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self setupNav];
    [self setupTableView];
    [self setUpFooterView];
    if (_where == 1) {
        [self dataArrayFrom];
    }
    self.headView.dict = self.timeDict;
    
    
//监控到键盘的弹起
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)nofice{
    self.tableView.transform =CGAffineTransformMakeTranslation(0, -135);
}
-(void)keyboardHide:(NSNotification *)nofice{
    self.tableView.transform =CGAffineTransformIdentity;
}


#pragma mark - setupNav
- (void)setupNav{
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.title = @"审核失败";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 135, ZQ_Device_Width, ZQ_Device_Height - 64 - 135 - 60) style:UITableViewStylePlain];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (void)setUpFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, ZQ_Device_Height - 64 - 60, ZQ_Device_Width, 60)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    uploadButton.frame = CGRectMake(12, 10, ZQ_Device_Width - 24, 40);
    uploadButton.backgroundColor = kUIColorFromRGB(0xf16156);
    uploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [uploadButton addTarget:self action:@selector(uploadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    uploadButton.layer.cornerRadius = 3;
    uploadButton.layer.masksToBounds = YES;
    if (_where == 1) {
        [uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    } else {
        [uploadButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    [uploadButton setTitleColor:kUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [view addSubview:uploadButton];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _textDataArray.count;
    } else if (section == 1) {
        return _imageDataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJWeakSelf
    if (indexPath.section == 0) {
        CancelTaskCell *cell = [CancelTaskCell cellWithTableView:tableView];
        __block  UploadTextModel *model = _textDataArray[indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@:",model.taskName];
        cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@", model.taskName];
        cell.textField.text = model.taskText;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        //nodeText回调
        cell.nodetextBlock = ^(NSString *text) {
            model.taskText = text;
        } ;
        return cell;
    }
    
    ChooseImageCell *cell = [ChooseImageCell cellWithTableView:tableView];
    _chooseImageCell = cell;
    cell.indexPath = indexPath;
    cell.delegate = self;
    UploadImageModel *imageModel = _imageDataArray[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(最多上传10张)", imageModel.taskName];
    [cell.imageArray removeAllObjects];
    [cell.imageArray addObjectsFromArray:imageModel.imageArray];
    [cell makeView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return 10;
//    }
//    return 0.00001;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return _chooseImageCell.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0 || section == 1) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 50)];
        view1.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ZQ_Device_Width, 40)];
        view.backgroundColor = kUIColorFromRGB(0xffffff);
        [view1 addSubview:view];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(12, 12.5, 15, 15)];
        [view addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, ZQ_Device_Width - 33, 39)];
        label.textColor = kUIColorFromRGB(0x000000);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:15.f];
        [view addSubview:label];
        
        if (section == 0) {
            label.text = @"文字信息";
            imageV.image = [UIImage imageNamed:@"tasknode_title"];
        } else if (section == 1) {
            label.text = @"图片信息";
            imageV.image = [UIImage imageNamed:@"tasknode_pic"];
        }
        return view1;
    }
    return nil;
}

#pragma mark - InputTextFieldViewControllerDelegate
- (void)inputTextFieldString:(NSString *)string WithIndex:(NSIndexPath *)index
{
    UploadTextModel *model = _textDataArray[index.row];
    model.taskText = string;
    [_tableView reloadData];
}

#pragma mark - ChooseImageCellDelegate
- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    UploadImageModel *model = _imageDataArray[indexPath.row];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:model.imageArray];
    vc.delegate = self;
    vc.indexPath = indexPath;
    [vc seleImageLocation:tag];
    [vc showDeleteButton];
    pushToControllerWithAnimated(vc)
}

- (void)deleteImageTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath
{
    UploadImageModel *model = _imageDataArray[indexPath.row];
    [model.imageArray removeObjectAtIndex:tag];
    [_tableView reloadData];
}

- (void)addImageButtonClickWithIndexPath:(NSIndexPath *)indexPath{
    _seledIndexPath = nil;
    _seledIndexPath = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://照相机
        {
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }else{
                //如果没有提示用户
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有摄像头" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert show];
            }
            
        }
            break;
        case 1://本地相簿
        {
            UploadImageModel *model = _imageDataArray[_seledIndexPath.row];
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.delegate = self;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            [KNPickerController imagePickerController:self withTakePicturePickerViewController:picker subViewsCount:model.imageArray.count maxCount:10];
        }
            break;
        default:
            break;
    }
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
        [self imgSubmit:image];
    }
}

#pragma mark -- 上传图片 获取url地址
- (void)imgSubmit:(UIImage*)image{
    UploadImageModel *model = _imageDataArray[_seledIndexPath.row];
    [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *string = [NSString stringWithFormat:@"%@", responseObject[@"url"]];
        if ([string rangeOfString:@","].location == NSNotFound) {
            [model.imageArray addObject:string];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [self imgSubmit:image];//失败的时候重试
    }];
}

//上传
- (void)uploadButtonClick
{
    
    if ([self.headView.hourTime.text isEqualToString:@"00"] &&[self.headView.miuteTime.text isEqualToString:@"00"] && [self.headView.secondTime.text isEqualToString:@"00"]) {
        [self showHint:@"已经过时间了"];
        return;

    }
    
    if (![ZQ_CommonTool isEmptyArray:_textArray]) {
        NSInteger nu = 0;
        for (UploadTextModel *model in _textDataArray) {
            if ([ZQ_CommonTool isEmpty:model.taskText]) {
                nu = 1;
            }
        }
        if (nu == 1) {
            [self showHint:@"请完善文字资料信息"];
            return;
        }
    }
    
    
    if (![ZQ_CommonTool isEmptyArray:_imageArray]) {
        NSInteger nu = 0;
        for (UploadImageModel *model in _imageDataArray) {
            if ([ZQ_CommonTool isEmptyArray:model.imageArray]) {
                nu = 1;
            }
        }
        if (nu == 1) {
            [self showHint:@"请完善图片资料信息"];
            return;
        }
    }
    
    __weak NodeError *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"nodeid"] = _model.nodeId;
    if (![ZQ_CommonTool isEmptyArray:_textDataArray]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (int i = 0; i<_textDataArray.count; i++) {
            UploadTextModel *model = _textDataArray[i];
            NSString *key = model.taskField;
            NSString *value =model.taskText;
            dic[key]= value;
        }
        params[@"text"] = dic;
    }
    if (![ZQ_CommonTool isEmptyArray:_imageDataArray]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (UploadImageModel *model in _imageDataArray) {
            NSString *key = model.taskField;
            NSMutableDictionary *value = [NSMutableDictionary dictionary];
            if (![ZQ_CommonTool isEmptyArray:model.imageArray]) {
                for (NSInteger i = 0 ; i < model.imageArray.count; i++) {
                    NSDictionary *dic = @{@"url":model.imageArray[i],
                                          @"sort":[NSString stringWithFormat:@"%zd",i],
                                          @"alt":[NSString stringWithFormat:@"%zd",i]
                                          };
                    [value setValue:dic forKey:[NSString stringWithFormat:@"%zd", i]];
                }
            }
            dic[key] = value;
        }
        params[@"imgs"] = dic;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=add.collectData"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [MobClick event:@"uploadNode"];
            
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"上传成功"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 0) {
                     if (_where == 1) {
                         [self leftBarButtonItem];
                     } else if (_where == 2) {
                         [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                     } else if (_where == 3) {
                         [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
                     }
                 }
             } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.headView) {
        [self.headView closeTime];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

@end
