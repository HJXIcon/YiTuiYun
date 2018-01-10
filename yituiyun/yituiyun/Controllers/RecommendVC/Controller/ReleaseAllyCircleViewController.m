//
//  ReleaseAllyCircleViewController.m
//  yituiyun
//
//  Created by 张强 on 2017/2/7.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "ReleaseAllyCircleViewController.h"
#import "ChooseImageOrVideoCell.h"
#import "ZYQAssetPickerController.h"
#import "KNPickerController.h"
#import "ShowImageViewController.h"
#import "ImageOrVideoModel.h"
#import "HFAliyunOSS.h"
#import "PlayVideoViewController.h"

@interface ReleaseAllyCircleViewController ()<UITableViewDataSource,UITableViewDelegate,ChooseImageOrVideoCellDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate,ShowImageViewControllerDelegate,PlayVideoViewControllerDelegate>

@property (nonatomic, strong) ChooseImageOrVideoCell *chooseImageCell;
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger where;//1 是添加 2 是修改
@property (nonatomic, copy) NSString *textString;
@property (nonatomic, copy) NSString *labelString;
@property (nonatomic, copy) NSString *demandId;//需求id
@property (nonatomic, assign) NSInteger buttonIndex;

@end

@implementation ReleaseAllyCircleViewController

- (instancetype)initWithWhere:(NSInteger)where{
    if (self = [super init]) {
        self.where = where;
        self.dataArray = [NSMutableArray array];
        self.labelString = @"500";
        self.textString = @"这一刻的想法...";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextViewTextDidChangeNotification object:nil];
    
    self.title = @"发布盟友圈";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(popAction)];
    
    [self setUpTabView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, ZQ_Device_Height - 64 - 55, ZQ_Device_Width - 20, 45);
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTintColor:kUIColorFromRGB(0xffffff)];
    button.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[button layer] setCornerRadius:4];
    [[button layer] setMasksToBounds:YES];
    button.backgroundColor = kUIColorFromRGB(0xf16156);
    [button addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemAction:(UIButton *)button
{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    
    NSString *string = @"";
    if (![_textView.text isEqualToString:@"这一刻的想法..."] && ![ZQ_CommonTool isEmpty:_textView.text]) {
        string = _textView.text;
    } else {
        if ([ZQ_CommonTool isEmptyArray:_dataArray]) {
            [self showHint:@"不能发布空盟友圈..."];
            return;
        }
    }
    
    NSInteger imageOrVideo = 0;
    for (ImageOrVideoModel *model in _dataArray) {
        if ([model.type integerValue] == 2) {
            imageOrVideo = 1;
        }
    }
    
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    __weak ReleaseAllyCircleViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (![ZQ_CommonTool isEmpty:string]) {
        params[@"content"] = string;
    }
    params[@"memberid"] = infoModel.userID;
    if (imageOrVideo == 0 && ![ZQ_CommonTool isEmptyArray:_dataArray]) {
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        for (NSInteger i = 0 ; i < _dataArray.count; i++) {
            ImageOrVideoModel *model = _dataArray[i];
            NSDictionary *dic = @{@"url":model.dataUrl,
                                  @"sort":[NSString stringWithFormat:@"%zd",i],
                                  @"alt":[NSString stringWithFormat:@"%zd",i]
                                  };
            [value setValue:dic forKey:[NSString stringWithFormat:@"%zd", i]];
        }
        params[@"showImages"] = value;
    } else if (imageOrVideo == 1 && ![ZQ_CommonTool isEmptyArray:_dataArray]) {
        ImageOrVideoModel *model = _dataArray.firstObject;
        params[@"video"] = model.videoName;
        params[@"thumb"] = model.dataUrl;
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost,@"api.php?m=add.dynamic"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [weakSelf showHint:responseObject[@"errmsg"]];
            if (_deleagete && [_deleagete respondsToSelector:@selector(gobackTableViewReload)]) {
                [_deleagete gobackTableViewReload];
                [weakSelf popAction];
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

#pragma mark----UITabView
-(void)setUpTabView{
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [_tabView setDelegate:(id<UITableViewDelegate>) self];
    [_tabView setDataSource:(id<UITableViewDataSource>) self];
    [_tabView setShowsVerticalScrollIndicator:NO];
    _tabView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabView];
}

#pragma mark ------ UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _chooseImageCell.height;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 160;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section == 0) {
    ChooseImageOrVideoCell *cell = [ChooseImageOrVideoCell cellWithTableView:tableView];
    _chooseImageCell = cell;
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell.imageArray removeAllObjects];
    [cell.imageArray addObjectsFromArray:_dataArray];
    cell.nameLabel.frame = ZQ_RECT_CREATE(12, 0, ZQ_Device_Width - 24, 0.0000001);
    [cell makeView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    //    }
    
    //    static NSString* identifier = @"ChooseImageCell1";
    //    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    //    }
    //
    //    cell.textLabel.text = @"出价";
    //    cell.textLabel.font = [UIFont systemFontOfSize:15];
    //    NSString *string = nil;
    //    if ([self.amount integerValue] == 0 || [ZQ_CommonTool isEmpty:self.amount]) {
    //        string = @"¥0";
    //        cell.detailTextLabel.textColor = kUIColorFromRGB(0x888888);
    //    } else {
    //        string = [NSString stringWithFormat:@"¥%@", _amount];
    //        cell.detailTextLabel.textColor = kUIColorFromRGB(0x34b87f);
    //    }
    //    cell.detailTextLabel.text = string;
    //    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 160)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.textView = [[UITextView alloc] initWithFrame:ZQ_RECT_CREATE(12, 12, ZQ_Device_Width - 24, 150 - 40)];
        _textView.delegate = self;
        _textView.text = self.textString;
        _textView.backgroundColor = [UIColor clearColor];
        if ([_textView.text isEqualToString:@"这一刻的想法..."]) {
            _textView.textColor = kUIColorFromRGB(0x999999);
        } else {
            _textView.textColor = kUIColorFromRGB(0x000000);
        }
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.returnKeyType = UIReturnKeyDone;
        [view addSubview:_textView];
        
        self.label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width - 80, 150 - 40, 68, 40)];
        _label.textAlignment = NSTextAlignmentRight;
        _label.text = self.labelString;
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = kUIColorFromRGB(0x999999);
        [view addSubview:_label];
        
        UIView *view1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 150, ZQ_Device_Width, 10)];
        view1.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        [view addSubview:view1];
        
        return view;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"这一刻的想法..."]) {
        textView.text = @"";
    }
    textView.textColor = kUIColorFromRGB(0x000000);
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        if ([ZQ_CommonTool isEmpty:textView.text]) {
            textView.text = @"这一刻的想法...";
            textView.textColor = kUIColorFromRGB(0x999999);
        }
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([ZQ_CommonTool isEmpty:textView.text]) {
        textView.text = @"这一刻的想法...";
        textView.textColor = kUIColorFromRGB(0x999999);
    }
}

- (void)infoAction
{
    
    UITextRange *selectedRange = [_textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [_textView positionFromPosition:selectedRange.start offset:0];
    
    if (!position) {
        if (_textView.text.length > 500) {
            _label.text = @"0";
            _labelString = _label.text;
            _textView.text = self.textString;
        } else {
            _label.text = [NSString stringWithFormat:@"%zd", 500 - _textView.text.length];
            _labelString = _label.text;
            self.textString = _textView.text;
        }
    }
    
}

#pragma mark - ChooseImageOrVideoCellDelegate
- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *browseItemArray = [NSMutableArray array];
    //    for (int i = 0; i < [_dataArray count]; i ++) {
    //        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
    //        browseItem.bigImageUrl = [kHost stringByAppendingString:_dataArray[i]];// 加载网络图片大图地址
    //        [browseItem.smallImageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[i]] placeholderImage:nil];// 小图
    //        [browseItemArray addObject:browseItem];
    //    }
    //    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:tag - 1];
    //    bvc.delegate = self;
    //    [bvc showDeleteButton];
    //    [bvc showBrowseViewController];
    
    ImageOrVideoModel *model = _dataArray[tag];
    if ([model.type integerValue] == 1) {
        NSMutableArray *array = [NSMutableArray array];
        for (ImageOrVideoModel *model in _dataArray) {
            [array addObject:model.dataUrl];
        }
        ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
        vc.delegate = self;
        vc.indexPath = indexPath;
        [vc seleImageLocation:tag];
        [vc showDeleteButton];
        pushToControllerWithAnimated(vc)
    } else if ([model.type integerValue] == 2) {
        //        PlayVideoViewController *vc = [[PlayVideoViewController alloc] initWithVideo:model.videoUrl];
        //        vc.delegate = self;
        //        vc.indexPath = indexPath;
        //        [vc showDeleteButton];
        //        pushToControllerWithAnimated(vc)
        
        //        [WCAlertView showAlertWithTitle:@"提示"
        //                                message:@"是否要删除该视频"
        //                     customizationBlock:^(WCAlertView *alertView) {
        //
        //                     } completionBlock:
        //         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
        //             if (buttonIndex == 1) {
        //                 [self deleteVideo];
        //             }
        //         } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        NSString *urlStr = [model.videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [moviePlayerController.moviePlayer prepareToPlay];
        moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
    }
}

- (void)longPressButtonWithIndexPath:(NSIndexPath *)indexPath
{
    [WCAlertView showAlertWithTitle:@"提示"
                            message:@"是否要删除该视频"
                 customizationBlock:^(WCAlertView *alertView) {
                     
                 } completionBlock:
     ^(NSUInteger buttonIndex, WCAlertView *alertView) {
         if (buttonIndex == 1) {
             [self deleteVideo];
         }
     } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

#pragma mark -- 删除照片的代理
- (void)deleteImageTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    [_dataArray removeObjectAtIndex:tag];
    [_tabView reloadData];
}

- (void)deleteVideo
{
    [_dataArray removeAllObjects];
    [_tabView reloadData];
}

- (void)addImageButtonClickWithIndexPath:(NSIndexPath *)indexPath{
    
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄", @"本地照片", @"本地视频", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _buttonIndex = nil;
    _buttonIndex = buttonIndex;
    if (buttonIndex == 0) {  // 拍摄模式
        [self delete];
    }else if (buttonIndex == 1 || buttonIndex == 2){  // 手机相册
        [self modify:buttonIndex];
    }
}

- (void)modify:(NSInteger)buttonIndex{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.delegate = self;
    if (buttonIndex == 1) {
        if (_dataArray.count < 9) {
            NSInteger i = 0;
            for (ImageOrVideoModel *model in _dataArray) {
                if ([model.type integerValue] == 2) {
                    i = 1;
                    break;
                }
            }
            if (i == 0) {
                picker.assetsFilter = [ALAssetsFilter allPhotos];
                [KNPickerController imagePickerController:self withTakePicturePickerViewController:picker subViewsCount:_dataArray.count maxCount:9];
            } else {
                [self showHint:@"图片和视频不可以同时发布"];
            }
        } else {
            [self showHint:@"最多发布9张图片"];
        }
    } else if (buttonIndex == 2) {
        if ([ZQ_CommonTool isEmptyArray:_dataArray]) {
            //            picker.assetsFilter = [ALAssetsFilter allVideos];
            //            [KNPickerController imagePickerController:self withTakePicturePickerViewController:picker subViewsCount:_dataArray.count maxCount:1];
            
            UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
            videoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            videoPicker.mediaTypes = @[@"public.movie"];
            videoPicker.delegate = self;
            [self presentViewController:videoPicker animated:YES completion:nil];
            
        } else {
            [self showHint:@"图片和视频不可以同时发布"];
        }
    }
}

- (void)delete{
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有摄像头" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
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
        ALAssetRepresentation * representation = asset.defaultRepresentation;
        UIImage *image = [UIImage imageWithCGImage:representation.fullScreenImage];
        [array addObject:image];
    }
    
    [self modifyPicture:array];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *resultImage = nil;
    NSURL *movieURL = nil;
    //判断是照片or视频
    if ([mediaType isEqualToString:@"public.image"]) {
        
        resultImage = info[UIImagePickerControllerOriginalImage];
        [self modifyPicture:[NSArray arrayWithObject:resultImage]];
        
    } else if ([mediaType isEqualToString:@"public.movie"]){
        
        movieURL = info[UIImagePickerControllerMediaURL];
        [self modifyVideo:movieURL.path];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

//上传图片
- (void)modifyPicture:(NSArray *)array
{
    [self showHudInView1:self.view hint:@"上传中..."];
    
    [self imgSubmit:array count:0];
}

//上传视频
- (void)modifyVideo:(NSString *)filePath
{
    
    __weak typeof(self) weakSelf = self;
    [weakSelf showHudInView1:self.view hint:@"上传中..."];
    
    [[HFAliyunOSS sharInstance] uploadOSSPutObjectFilePath:filePath progress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
    } finish:^(NSString *fileUrl, NSError *error) {
        
        
        
        [weakSelf hideHud];
        UIImage *image = [weakSelf getImage:filePath];
        [weakSelf upDataVideoCover:image WithFilePath:filePath WithFileUrl:fileUrl];
    }];
}

- (void)upDataVideoCover:(UIImage *)image WithFilePath:(NSString *)filePath WithFileUrl:(NSString *)fileUrl{
    __weak typeof(self) weakSelf = self;
    [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject) {
        NSString *string = [NSString stringWithFormat:@"%@", responseObject[@"url"]];
        if ([string rangeOfString:@","].location == NSNotFound) {
            ImageOrVideoModel *model = [[ImageOrVideoModel alloc] init];
            model.type = @"2";
            model.videoName = [NSString stringWithFormat:@"%@", fileUrl];
            model.dataUrl = [NSString stringWithFormat:@"%@", string];
            model.videoUrl = [NSString stringWithFormat:@"http://yituiyun.oss-cn-shanghai.aliyuncs.com/video/%@", fileUrl];
            [_dataArray addObject:model];
        }
        [_tabView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"上传失败"];
    }];
}

- (UIImage *)getImage:(NSString *)videoURL

{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}

#pragma mark -- 上传图片 获取url地址
- (void)imgSubmit:(NSArray *)array count:(NSInteger)i{
    if(i == [array count]){
        [self hideHud];
        return;
    }
    
    UIImage *image = array[i];
    
    NSInteger is = i + 1;
    
    NSInteger array_count = [array count];
    
    __weak typeof(self) weakSelf = self;
    
    if(array_count != i){
        
        [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject) {
            NSString *string = [NSString stringWithFormat:@"%@", responseObject[@"url"]];
            if ([string rangeOfString:@","].location == NSNotFound) {
                ImageOrVideoModel *model = [[ImageOrVideoModel alloc] init];
                model.type = @"1";
                model.dataUrl = [NSString stringWithFormat:@"%@", string];
                [_dataArray addObject:model];
            }
            [_tabView reloadData];
            [weakSelf imgSubmit:array count:is];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            [weakSelf hideHud];
            [weakSelf showHint:@"上传失败"];
        }];
    }
}

@end
