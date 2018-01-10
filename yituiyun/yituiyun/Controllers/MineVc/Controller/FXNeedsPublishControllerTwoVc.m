//
//  FXNeedsPublishControllerTwoVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "FXNeedsPublishControllerTwoVc.h"
#import "CompanyPublishTwoforoneCell.h"
#import "CompanyPublishTwofortw0Cell.h"
#import "CompanyTwoFootView.h"
#import "CompanyTwoSectionView.h"
#import "UploadImageModel.h"
#import "KNPickerController.h"
#import "ZYQAssetPickerController.h"
#import "ShowImageViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "FXNeedPublisThreeVc.h"
#import "CompanyNeedscontainer.h"

@interface FXNeedsPublishControllerTwoVc ()<UITableViewDelegate,UITableViewDataSource,CompanyPublishTwofortw0CellDelegate,UIActionSheetDelegate,ShowImageViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) CompanyTwoFootView * footView;
@property(nonatomic,strong) CompanyTwoSectionView   * sectionView;
@property(nonatomic,assign)BOOL  isDetail;


/**选择的index */
@property(nonatomic,strong) NSIndexPath * selectIndexPath;

@end



@implementation FXNeedsPublishControllerTwoVc

-(NSMutableArray *)allDatas{
    if (_allDatas == nil) {
        _allDatas = [NSMutableArray array];
//        UploadImageModel *model = [[UploadImageModel alloc]init];
//        model.imageArray = [NSMutableArray array];
//        [_allDatas addObject:model];
    }
    return _allDatas;
}

#pragma mark - footView

-(CompanyTwoFootView *)footView{
    MJWeakSelf
    if (_footView == nil) {
        _footView = [CompanyTwoFootView footView];
        _footView.frame = CGRectMake(0, 0, ScreenWidth, 177);
        _footView.add_block = ^{
            
            [MobClick event:@"dieryetianjiabuzhou"];
            
            if (weakSelf.allDatas.count>3) {
                [weakSelf showHint:@"最多添加4个"];
                return  ;
            }
            
            if (weakSelf.allDatas.count>0) {
                UploadImageModel *lastModel = [weakSelf.allDatas lastObject];
                if ([ZQ_CommonTool isEmpty:lastModel.taskField]) {
                    [weakSelf showHint:@"请先完成上一步骤的文字内容"];
                    return ;
                }
            }
            
            UploadImageModel *model = [[UploadImageModel alloc]init];
            model.imageArray = [NSMutableArray array];
            
        

            [weakSelf.allDatas addObject:model];
            [weakSelf.tableView reloadData];
        };
    }
    return _footView;
}

-(CompanyTwoSectionView *)sectionView{
    if (_sectionView == nil) {
        _sectionView = [CompanyTwoSectionView sectionView];
        _sectionView.frame = CGRectMake(0, 0, ScreenWidth, 40);
    }
    return _sectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = 50;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CompanyPublishTwoforoneCell" bundle:nil] forCellReuseIdentifier:@"CompanyPublishTwoforoneCell"];
    
      [self.tableView registerNib:[UINib nibWithNibName:@"CompanyPublishTwofortw0Cell" bundle:nil] forCellReuseIdentifier:@"CompanyPublishTwofortw0Cell"];
    self.tableView.tableFooterView = self.footView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextToVC)];
    
    self.isDetail = NO;
    
}
-(void)setDescModel:(CompanyNeedDesc *)descModel{
    _descModel = descModel;
    
    if (descModel  !=nil) {
        CompanyPublishTwoforoneCell *oncell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] ];
        oncell.textView.editable = self.isCanEding;
        oncell.textView.text = descModel.desc;
        oncell.textPlacLabel.hidden = YES;
       
        self.isDetail = !self.isCanEding;
        
        if (self.isCanEding) {
            
            //任务介绍
            [NeedDataModel shareInstance].taskDesc = descModel.desc;
            
        }else{
             self.tableView.tableFooterView = [UIView new];
        }
        
        if (descModel.execute_step.count>0) {
            
            [self.allDatas removeAllObjects];
            
            for (NSDictionary *dict in descModel.execute_step) {
                UploadImageModel *model = [[UploadImageModel alloc]init];
                model.imageArray = [NSMutableArray array];
                model.taskField = dict[@"text"];
                for (NSDictionary *imgdict in dict[@"img"] ) {
                    [model.imageArray addObject:imgdict[@"url"]];
                }
                
                [self.allDatas addObject:model];
            }
            
            [self.tableView reloadData];
            
            if (self.isCanEding) {
                
                //任务介绍
                [NeedDataModel shareInstance].taskSetpArray = self.allDatas;
                
            }

        }

    }
    
    
    
    
    
}
-(void)nextToVC{
    [self.navigationController pushViewController:[FXNeedPublisThreeVc new] animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return  self.allDatas.count;

}

#pragma mark - 处理第二个cell 添加相机的代理

-(void)addImageButtonClickWithIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"dieryetianjiatupian"];
    [self.view endEditing:YES];
    _selectIndexPath = nil;
    _selectIndexPath = indexPath;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
    

}

#pragma mark - 处理actionsheet的代理

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UploadImageModel *model = self.allDatas[_selectIndexPath.row];

    if (model.imageArray.count>=MaxCountPicToNeeds) {
        [self showHint:@"照片已超过9张"];
        return ;
    }

    switch (buttonIndex) {
        case 0://照相机
        {
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.containVc presentViewController:imagePicker animated:YES completion:nil];
            }else{
                //如果没有提示用户
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有摄像头" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert show];
            }
            
        }
            break;
        case 1://本地相簿
        {
            UploadImageModel *model = self.allDatas[_selectIndexPath.row];
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.delegate = self;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            [KNPickerController imagePickerController:self.containVc withTakePicturePickerViewController:picker subViewsCount:model.imageArray.count maxCount:MaxCountPicToNeeds];
        }
            break;
        default:
            break;
    }
}

#pragma mark - viewWillapper

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
}

#pragma mark - 点击图片的回调

-(void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    
    UploadImageModel *model = self.allDatas[indexPath.row];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:model.imageArray];
    vc.delegate = self;
    vc.indexPath = indexPath;
    if (self.descModel  !=nil) {
        vc.hideRightBtn = YES;
    }else{
        vc.hideRightBtn = NO;
    }
    
    [vc seleImageLocation:tag];
    [vc showDeleteButton];
    [self.containVc.navigationController pushViewController:vc animated:YES];
}

- (void)deleteImageTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath
{
    UploadImageModel *model = self.allDatas[indexPath.row];
    [model.imageArray removeObjectAtIndex:tag];
    [self.tableView reloadData];
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
    UploadImageModel *model = self.allDatas[_selectIndexPath.row];
    
    if (model.imageArray.count>MaxCountPicToNeeds) {
        [self showHint:@"照片已超过9张"];
        return ;
    }
    MJWeakSelf

    [SVProgressHUD showWithStatus:@"上传中.."];
    
    [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSString *string = [NSString stringWithFormat:@"%@", responseObject[@"url"]];
        if ([string rangeOfString:@","].location == NSNotFound) {
            [model.imageArray addObject:string];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf imgSubmit:image];//失败的时候重试
        [SVProgressHUD dismiss];
    }];
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



#pragma mark - 相机授权的操作方法

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

  #pragma mark - tableView cell数据源的方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 0) {
        CompanyPublishTwoforoneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"CompanyPublishTwoforoneCell"];
        oneCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return oneCell;
    }
    //第二个cell
    UploadImageModel *model = self.allDatas[indexPath.row];
    
        MJWeakSelf

    CompanyPublishTwofortw0Cell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"CompanyPublishTwofortw0Cell"];
    twoCell.delegate = self;
    //cell当前所处在的位置
    twoCell.indexPath = indexPath;
    twoCell.isDetail = self.isDetail;
    //给模型数据
    twoCell.model = model;
    //左上角的标签
    twoCell.numberLabel.font = [UIFont systemFontOfSize:12];

    twoCell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    twoCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    
    twoCell.deleteBlock = ^{
        [MobClick event:@"dieryeshanchubuzhou"];
        [weakSelf.allDatas removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
    };
    
    return  twoCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 207;
    }
    return  UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return  40;
    }
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return  self.sectionView;
    }
    return [UIView new];
}


@end
