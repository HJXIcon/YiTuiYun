//
//  ShowImageViewController.m
//  tongmenyiren
//
//  Created by 张强 on 16/8/26.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ShowImageViewController.h"
#import "ShowImageCell.h"

@interface ShowImageViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;         //集合视图
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;   //
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger number;

@end

static NSString *ShowImageView = @"showImageView";

@implementation ShowImageViewController
- (instancetype)initWithImageArray:(NSMutableArray *)imageArray
{
    self = [super init];
    if (self) {
        self.imageArray = [NSMutableArray arrayWithArray:imageArray];
//        [self setUpCollectionView];
        
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
//    [self.navigationController.navigationBar setTranslucent:YES];
//    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
//    {
//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    }
//}

//滚动就会触发
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.tag = scrollView.contentOffset.x / ZQ_Device_Width;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//            self.imageArray = [NSMutableArray arrayWithArray:imageArray];
            [self setUpCollectionView];

    self.title = @"图片展示";
    
                self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];


    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showDeleteButton
{
    
    if (self.hideRightBtn) {
        
    }else{
           self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"delete_icon" selectedImage:@"delete_icon" target:self action:@selector(rightBarButtonDidClick)]; 
    }


}

- (void)showMoreButton{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"moreAndMore" selectedImage:@"moreAndMore" target:self action:@selector(rightBarButtonDidClick1)];
}

- (void)setUpCollectionView
{
    //初始化flowLayout
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.itemSize = CGSizeMake(ZQ_Device_Width, ZQ_Device_Height - 64);
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, ZQ_Device_Height - 64) collectionViewLayout:_flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces = false;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delaysContentTouches = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[ShowImageCell class] forCellWithReuseIdentifier:ShowImageView];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource
//设置每个分组中有多少个item
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

#pragma mark 设置每个item上显示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShowImageView forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[ShowImageCell alloc] initWithFrame:self.view.frame];
    }
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@" , kHost, _imageArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"logo-juxing"]];
    
    return cell;
}

#pragma mark 点击实现
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)rightBarButtonDidClick
{
    if (_imageArray.count <= _tag) {
        _tag --;
    }

    if (_imageArray.count != 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_tag inSection:0];
        [_imageArray removeObjectAtIndex:indexPath.row];
        [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } else {
        [self leftBarButtonItem];
    }
    if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(deleteImageTag:WithIndexPath:)])
    {
        [_delegate deleteImageTag:_tag WithIndexPath:_indexPath];
    }
}

- (void)rightBarButtonDidClick1
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {  // 拍照模式
        [self cameraClick];
    }else if (buttonIndex == 1){  // 手机相册
        [self albumClick];
    }
}

- (void)seleImageLocation:(NSInteger)location
{
    _collectionView.contentOffset = CGPointMake(ZQ_Device_Width*location, 0);
    self.tag = location;
}

- (void)albumClick{//选择相册
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
- (void)cameraClick{//打开相机
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:NO completion:nil];
    
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
    }
    self.number = 3;
    [self upLoadIcon:resultImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 上传
- (void)upLoadIcon:(UIImage *)image{
    [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *string = [NSString stringWithFormat:@"%@", responseObject[@"url"]];
        if ([string rangeOfString:@","].location == NSNotFound) {
            [_imageArray removeAllObjects];
            [_imageArray addObject:string];
            [_collectionView reloadData];
            if(_delegate && [_delegate respondsToSelector:@selector(refreshImageUrl:)])
            {
                [_delegate refreshImageUrl:string];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        _number --;
        if (_number == 0) {
            [self showHint:@"网络状况较差，上传失败"];
            return ;
        }
        [self upLoadIcon:image];//失败的时候重试
    }];
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
