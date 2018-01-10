//
//  GuideViewController.m
//  yituiyun
//
//  Created by NIT on 15-4-3.
//  Copyright (c) 2015年 ZQ. All rights reserved.
//

#import "GuideViewController.h"
#import "MainViewController.h"
#import "GuideCell.h"
#import "AppDelegate.h"

@interface GuideViewController ()<UICollectionViewDelegate,GuideCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;         //集合视图
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;   //
/**datas */
@property(nonatomic,strong) NSArray * datas;


@end
static NSString *showImageView = @"GuideCell";
@implementation GuideViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView * imageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    if (iPhone6P) {
        imageVeiw.image = [UIImage imageNamed:@"1242_2208"];
    } else if (iPhone6) {
        imageVeiw.image = [UIImage imageNamed:@"750_1334"];
    } else if (iPhone5) {
        imageVeiw.image = [UIImage imageNamed:@"640_1136"];
    } else if (iPhone4) {
        imageVeiw.image = [UIImage imageNamed:@"640_960"];
    }
    [self.view insertSubview:imageVeiw atIndex:0];
    //
    
    
    //发送网络请求 引导页
    
    [self setupRequest];

    
}



-(void)setupRequest{
    MJWeakSelf
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"cid"]=@(2);
    [XKNetworkManager GETDataFromUrlString:AppGuideRequestURL parameters:dict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        
        self.datas = dict[@"rst"];
        [weakSelf setUpCollectionView];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
- (void)setUpCollectionView
{
    //初始化flowLayout
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.itemSize = CGSizeMake(ZQ_Device_Width, ZQ_Device_Height);
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, ZQ_Device_Height) collectionViewLayout:_flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delaysContentTouches = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[GuideCell class] forCellWithReuseIdentifier:showImageView];
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
    return self.datas.count;
}

#pragma mark 设置每个item上显示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MJWeakSelf
    GuideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showImageView forIndexPath:indexPath];
    cell.delegate = self;

    NSDictionary *dict = self.datas[indexPath.item];
    NSString *imagePath =[NSString imagePathAddPrefix:dict[@"imgurl"]];
    
   
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"moren"] options:EMSDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat precent = receivedSize*1.0f/expectedSize ;
        [SVProgressHUD showProgress:precent status:@"加载中.."];
    } completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
        if (error !=nil) {
            [SVProgressHUD dismiss];
            [weakSelf showHint:@"图片下载失败"];
        }else{
            [SVProgressHUD dismiss];
 
        }
    }];
    if (indexPath.row == (self.datas.count-1)) {
        cell.button.hidden = NO;
    } else {
        cell.button.hidden = YES;
    }
    
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
        return cell;
}

#pragma mark 点击实现
- (void)buttonClick
{
    //第一次启动结束
    UserInfoModel *model = [ZQ_AppCache userInfoVo] ;
    
    if (model == nil) {
      
        model = [[UserInfoModel alloc]init];
    }
    model.userID = @"0";
    model.identity = @"6";
    [ZQ_AppCache save:model];
    
    MainViewController *tabBarVc = [[MainViewController alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.viewController = tabBarVc;
    appDelegate.window.rootViewController = tabBarVc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
