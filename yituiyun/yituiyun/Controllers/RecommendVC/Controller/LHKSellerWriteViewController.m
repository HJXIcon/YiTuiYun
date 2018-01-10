//
//  LHKSellerWriteViewController.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKSellerWriteViewController.h"
#import "LHKSellerWriteCell.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "LHKFieldPickView.h"
#import "LHKImageUpHandle.h"
#import "DALabeledCircularProgressView.h"


@interface LHKSellerWriteViewController ()<UITableViewDelegate,UITableViewDataSource,LHKFieldPickViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKSuggestionSearchDelegate,BMKPoiSearchDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrolloview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightContstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewConstant;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *navBtn;

/**保存的图片 */
@property(nonatomic,strong) UIImage * saveImage;

/**数据源 */
@property(nonatomic,strong) NSArray * datas;

/**商家的名称 */
@property(nonatomic,strong) NSString * bussinessName;

/*商家的负责人 */
@property(nonatomic,strong) NSString * responesPeple;

/**联系电话 */
@property(nonatomic,strong) NSString * tel;

/**所在行业 */
@property(nonatomic,strong) NSString * field;

/**商家的地址 */
@property(nonatomic,strong)  NSString * address;

/**fieldPickView */
@property(nonatomic,strong) LHKFieldPickView * filedPickView;

/**filePickView */
@property(nonatomic,strong) NSArray * fieldDatas;

@property(nonatomic,strong) NSString *fieldType;

@property(nonatomic,assign)CLLocationCoordinate2D    coordinate;

/**导航的*/
@property(nonatomic,assign)CLLocationCoordinate2D    navcoordinate;
/**导航的地址 */
@property(nonatomic,strong) NSString * navAddress;


/**定位locationView */
@property(nonatomic,strong) BMKLocationService * locservice;

@property(nonatomic,strong) BMKGeoCodeSearch *searcher;

/**建议查询 */
@property(nonatomic,strong) BMKSuggestionSearch * suggestionSearch;

/**poi */
@property(nonatomic,strong) BMKPoiSearch * poiSearch;

/**重新定位的btn */
@property(nonatomic,strong) UIButton * aginLocation;

/**进度条试图 */
@property(nonatomic,strong) DALabeledCircularProgressView * progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;

/**zhen该 */
@property(nonatomic,strong) UIView * coverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeBtnToConstant;

@end

@implementation LHKSellerWriteViewController

#pragma mark--程序入口
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.writeBtnToConstant.constant = HRadio(40);
    [self setupNav];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"LHKSellerWriteCell" bundle:nil] forCellReuseIdentifier:@"sellcell"];
    self.tableView.rowHeight = 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mapView addSubview:self.aginLocation];
    [self setupMapView];
     [MobClick event:@"MerchantinputNums"];
    
    [self.view addSubview:self.progressLabel];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //添加遮盖 商家详情
    if (self.where == 2) {
        self.aginLocation.hidden = YES; //左下角的定位按钮
        [self dealwithMapWhenDetail];
        [self.view addSubview:self.coverView];
        [self.view insertSubview:self.coverView belowSubview:self.navBtn];
        
        [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString imagePathAddPrefix:self.model.avatar]]forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"]];
        
        self.writeBtn.hidden = YES;
        self.navBtn.hidden = NO;

        //复制数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            for ( int i = 0; i<5; i++) {
                [self setDataToCell:i with:self.model];
            }
        });
    }
    
    //编辑功能
    if ([ZQ_AppCache canSellerWrite] && _where == 2) {
        [self SellerWirteEdting];
    }

    
}


-(void)dealwithMapWhenDetail{
    
    CLLocationCoordinate2D coor =  CLLocationCoordinate2DMake(self.model.lat, self.model.lng);

    
    BMKPointAnnotation *annotation1 = [[BMKPointAnnotation alloc]init];
    
    annotation1.coordinate = coor;
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    [self.mapView removeAnnotations:array];
    
    [self.mapView addAnnotation:annotation1];
    
    
    //地址位置反向编码
    CLLocationCoordinate2D pt =coor;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
    
    
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.02, 0.02));
    
    [_mapView setRegion:region animated:YES];

}
#pragma mark--查看导航
- (IBAction)navBtnClick:(id)sender {
    
    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"商家位置导航" message:@"将调用百度app进行导航" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
    
   
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
            BMKOpenWalkingRouteOption *opt = [[BMKOpenWalkingRouteOption alloc] init];
            opt.appScheme = @"yituiyunclientmap://mapsdk.baidu.com";
            //初始化起点节点
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            //指定起点经纬度
            start.pt = self.navcoordinate;
            //指定起点名称
            start.name = self.navAddress;
            //指定起点
            opt.startPoint = start;
        
            //初始化终点节点
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            CLLocationCoordinate2D coor2;
            coor2.latitude = self.model.lat;
            coor2.longitude = self.model.lng;
            end.pt = coor2;
            //指定终点名称
            end.name = self.model.address;
            opt.endPoint = end;
            
            BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapWalkingRoute:opt];
//            NSLog(@"%d", code);

    }

}


#pragma mark--懒加载

-(DALabeledCircularProgressView *)progressLabel{
    
    if (_progressLabel == nil) {
        _progressLabel =[[DALabeledCircularProgressView alloc]initWithFrame:CGRectMake(ScreenWidth*0.5, ScreenHeight*0.5, 100, 100)];
        _progressLabel.center = CGPointMake(ScreenWidth*0.5, ScreenHeight*0.5-100);
        _progressLabel.progressTintColor = [UIColor lightGrayColor];
        _progressLabel.thicknessRatio = 0.2;
        _progressLabel.hidden = YES;
        _progressLabel.roundedCorners = YES;
    }
    return _progressLabel;
}
-(UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}


-(NSArray *)datas{
    
    if (_datas==nil) {
        _datas = @[@{@"title":@"商家名称:",@"desc":@"请输入商家名称"},@{@"title":@"负责人: ",@"desc":@"请输入负责人"},@{@"title":@"联系电话:",@"desc":@"请输入联系电话"},@{@"title":@"所在行业:",@"desc":@"请输入所在行业"},@{@"title":@"商家地址:",@"desc":@"请输入商家地址"}];
    }
    return _datas;
}

-(BMKGeoCodeSearch *)searcher{
    if(_searcher == nil){
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}
-(BMKSuggestionSearch *)suggestionSearch{
    if (_suggestionSearch == nil) {
        _suggestionSearch  =[[BMKSuggestionSearch alloc]init];
        _suggestionSearch.delegate = self;
    }
    return _suggestionSearch;
}

-(BMKPoiSearch *)poiSearch{
    if (_poiSearch == nil) {
        _poiSearch = [[BMKPoiSearch alloc]init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}

-(UIButton *)aginLocation{
    if(_aginLocation == nil){
        _aginLocation = [[UIButton alloc]init];
        [_aginLocation setImage:[UIImage imageNamed:@"map_normal"] forState:UIControlStateNormal];
        [_aginLocation setImage:[UIImage imageNamed:@"map_helight"] forState:UIControlStateHighlighted];
        
        [_aginLocation addTarget:self action:@selector(aginLocationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _aginLocation;
    
    
}

#pragma mark--处理编辑状态

-(void)SellerWirteEdting{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [btn setTitle:@"重新保存" forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(s_editing:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)s_editing:(UIButton*)btn{
   
    
    if (!btn.selected) {
        if (self.coverView) {
            self.aginLocation.hidden = NO;
            [self.coverView removeFromSuperview];
            
            if (self.tableView) {
                //cell上的重定位按钮
                LHKSellerWriteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                cell.againBtn.hidden = NO;
            }
            
        }
        if (self.navBtn) {
            self.navBtn.hidden = YES;
        }
    btn.selected = !btn.selected;
    }else{
        //写代码
        [self editingRequest];
    }
    
    

}

-(void)editingRequest{
    
    
    if ([self.bussinessName isEqualToString:@""] || self.bussinessName == nil) {
        [self showHint:@"商家名称不能为空"];
        return;
    }
    if ([self.responesPeple isEqualToString:@""] || self.responesPeple == nil) {
        [self showHint:@"负责人的名字不能为空"];
        return;
    }
    
    if ([self.tel isEqualToString:@""] || self.tel == nil || ![NSString valiMobile:self.tel]) {
        [self showHint:@"请输入正确的电话号码"];
        return;
    }
    
    if ([self.fieldType isEqualToString:@""] || self.fieldType == nil) {
        [self showHint:@"请选择行业"];
        return;
    }
    
    if (self.coordinate.latitude == 0 || self.coordinate.longitude == 0 ) {
        [self showHint:@"请输入正确的位置"];
        return;
    }
    
    if (![XKNetworkManager networkStateChange]) {
        [self showHint:@"无网络"];
        return;
    }
    
    MJWeakSelf
    
    
    if (self.saveImage) {
        [XKNetworkManager xk_uploadImages:@[self.saveImage] toURL:FileUpload parameters:nil progress:^(CGFloat progress) {
            weakSelf.progressLabel.hidden =NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *progresstr = [NSString stringWithFormat:@"%.2f%%",progress*100];
                weakSelf.progressLabel.progress = progress;
                weakSelf.progressLabel.progressLabel.text = progresstr;
            });
            
            
        } success:^(id responseObject) {
            
            NSDictionary *dictdata = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSString *image = dictdata[@"url"];
            
            weakSelf.progressLabel.hidden = YES;
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"nickname"] = self.bussinessName;
            dict[@"realName"] = self.responesPeple;
            dict[@"mobile"] = self.tel;
            dict[@"industry"] =self.fieldType;
            dict[@"address"] =self.address;
            dict[@"lng"]=@(self.coordinate.longitude);
            dict[@"lat"]=@(self.coordinate.latitude);
            dict[@"uid"] =[ZQ_AppCache getUid];
            dict[@"avatar"] = image;
            
            [weakSelf updateToServer:dict];
            
            
        } failure:^(NSError *error) {
            
            weakSelf.progressLabel.hidden = YES;
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
            
            
        }];
        

    }else{
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"nickname"] = self.bussinessName;
        dict[@"realName"] = self.responesPeple;
        dict[@"mobile"] = self.tel;
        dict[@"industry"] =self.fieldType;
        dict[@"address"] =self.address;
        dict[@"lng"]=@(self.coordinate.longitude);
        dict[@"lat"]=@(self.coordinate.latitude);
        dict[@"uid"] =[ZQ_AppCache getUid];
        dict[@"avatar"] = weakSelf.model.avatar;
        dict[@"id"] = weakSelf.model.pid;
        
        [weakSelf updateToServer:dict];

    }

}

#pragma mark---领域选择 以及代理
-(LHKFieldPickView *)filedPickView{
    if (_filedPickView == nil) {
        _filedPickView = [LHKFieldPickView pickView];
        _filedPickView.delegate = self;
    }
    return _filedPickView;
}

-(void)fieldPickViewFieldSelect:(NSInteger)row withFieldView:(LHKFieldPickView *)fieldView{
    MJWeakSelf
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.filedPickView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-64);
    } completion:^(BOOL finished) {
        [weakSelf.filedPickView removeAllSubviews];
        weakSelf.filedPickView = nil;
        
    }];
    
    //
    if (self.fieldDatas.count == nil) {
        LHKSellerWriteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [cell.fieldBtn setTitle:@"选择失败" forState:UIControlStateNormal];
         [cell.fieldBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        
        
        LHKSellerWriteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [cell.fieldBtn setTitle:self.fieldDatas[row][@"name"] forState:UIControlStateNormal];
        [cell.fieldBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.fieldType = self.fieldDatas[row][@"linkageid"];
        self.field = self.fieldDatas[row][@"name"];
    }
    
}

#pragma 重新定位的点击方法
-(void)aginLocationBtnClick{
    
    if ([ZQ_AppCache canSellerWrite] && _where == 2) {
       [self dealwithMapWhenDetail];
        LHKSellerWriteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        cell.descLabel.text = self.model.address;

    }else{
    
    
    LHKSellerWriteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    cell.descLabel.text = @"";
        [self.locservice startUserLocationService];}
}

- (instancetype)initWith:(NSInteger)where
{
    if (self = [super init]) {
        self.where = where;
    }
    return self;
}
- (void)setupNav{
    _where ==1 ? ({self.title = @"商家录入";}):({self.title = @"商家详情";});
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(leftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MJWeakSelf
    
    LHKSellerWriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sellcell"];
    if (indexPath.row == 4) {
        
        if (self.where == 2) {
                    cell.againBtn.hidden = YES;
        }else{
                   cell.againBtn.hidden = NO;
        }

        
        ScreenWidth>375?(cell.descLabel.font = [UIFont systemFontOfSize:14]):(cell.descLabel.font = [UIFont systemFontOfSize:12]);
        
    }else{
        cell.againBtn.hidden = YES;
    }
    
    if (indexPath.row == 3) {
        cell.descLabel.hidden = YES;
        cell.fieldBtn.hidden = NO;
    }else{
        cell.descLabel.hidden = NO;
        cell.fieldBtn.hidden = YES;
    }
    
    
    cell.titleLabel.text = self.datas[indexPath.row][@"title"];
    cell.descLabel.placeholder = self.datas[indexPath.row][@"desc"];
   
    //处理定位block的事件
    
    cell.aginBlock = ^{

        if ([cell.descLabel.text isEqualToString:@""]) {
            
            if( [XKNetworkManager networkStateChange]){
                [weakSelf.locservice startUserLocationService];
                
                [weakSelf showHudInView:weakSelf.view hint:@"重新定位中..."];
            
            }else{
                    [weakSelf showHint:@"无网络"];
                }

        }else{
            
            
            if( [XKNetworkManager networkStateChange]){
                [weakSelf geoAddress:cell.descLabel.text];
                 [weakSelf showHudInView:weakSelf.view hint:@"重新定位中..."];

            }else{
                    [weakSelf showHint:@"无网络"];
                }

        }
    };
    
    //处理fieldBlock的回调
    
        cell.fieldBlock = ^{
            
            if (![XKNetworkManager networkStateChange]) {
                [weakSelf showHint:@"无网络"];
                return ;
            }
        
            [weakSelf.view endEditing:YES];

        [weakSelf showHudInView1:weakSelf.view hint:@"正在加载数据.."];
      
        if ([XKNetworkManager networkStateChange]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"keyid"] = @(3360);
            dict[@"parentid"]=@"";
            [XKNetworkManager POSTToUrlString:GetFieldURL parameters:dict progress:^(CGFloat progress) {
                
            } success:^(id responseObject) {
                
                [weakSelf hideHud];
                //如果有数据的时候
                NSArray *arry = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
                
                weakSelf.fieldDatas = arry;
                
                
                weakSelf.filedPickView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-64);
                [weakSelf.view addSubview:weakSelf.filedPickView];
                [UIView animateWithDuration:0.5 animations:^{
                    weakSelf.filedPickView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
                    weakSelf.filedPickView.dataArray = arry;
                
                }];
                    
                
                
            } failure:^(NSError *error) {
                
                [weakSelf hideHud];
                [weakSelf showHint:@"网络加载失败"];
                
            }];
            

        }        
        

        
        
    };
    
    //处理textblock的会掉
    cell.textBlock = ^(NSString *text) {
//        NSLog(@"-------%@--%ld-",text,indexPath.row);
        
        switch (indexPath.row) {
            case 0:
                weakSelf.bussinessName = text;
                break;
            case 1:
                weakSelf.responesPeple = text;
                break;

            case 2:
                weakSelf.tel = text;
                break;

            case 3:
                weakSelf.field = text;
                break;

            case 4:
                weakSelf.address = text;
                break;

                
            default:
                break;
        }
        
    };
    
    return cell;
}

#pragma mark--录入按钮

- (IBAction)writeBtnClick:(id)sender {
    
    
            if ([ZQ_CommonTool isEmpty:self.bussinessName] || self.bussinessName == nil) {
                [self showHint:@"商家名称不能为空"];
                return;
            }
            if ([ZQ_CommonTool isEmpty:self.responesPeple] || self.responesPeple == nil) {
                [self showHint:@"负责人的名字不能为空"];
                return;
            }
        
            if ([ZQ_CommonTool isEmpty:self.tel] || self.tel == nil || ![NSString valiMobile:self.tel]) {
                [self showHint:@"请输入正确的电话号码"];
                return;
            }
        
            if ([ZQ_CommonTool isEmpty:self.field] || self.fieldType == nil) {
                [self showHint:@"请选择行业"];
                return;
            }
        
            if (self.coordinate.latitude == 0 || self.coordinate.longitude == 0 ) {
                [self showHint:@"请输入正确的位置"];
                return;
            }
    if (self.saveImage == nil ) {
        [self showHint:@"请选择图片"];
        return;
    }


    
            if (![XKNetworkManager networkStateChange]) {
                [self showHint:@"无网络"];
                return;
            }

    MJWeakSelf
    
    
        [XKNetworkManager xk_uploadImages:@[self.saveImage] toURL:FileUpload parameters:nil progress:^(CGFloat progress) {
            weakSelf.progressLabel.hidden =NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *progresstr = [NSString stringWithFormat:@"%.2f%%",progress*100];
                weakSelf.progressLabel.progress = progress;
                weakSelf.progressLabel.progressLabel.text = progresstr;
            });
            
            
        } success:^(id responseObject) {
            
            NSDictionary *dictdata = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSString *image = dictdata[@"url"];
            
            weakSelf.progressLabel.hidden = YES;
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"nickname"] = self.bussinessName;
            dict[@"realName"] = self.responesPeple;
            dict[@"mobile"] = self.tel;
            dict[@"industry"] =self.fieldType;
            dict[@"address"] =self.address;
            dict[@"lng"]=@(self.coordinate.longitude);
            dict[@"lat"]=@(self.coordinate.latitude);
            dict[@"uid"] =[ZQ_AppCache getUid];
            dict[@"avatar"] = image;
            dict[@"id"] = weakSelf.model.pid;
            [weakSelf updateToServer:dict];
            
            
        } failure:^(NSError *error) {
            
            weakSelf.progressLabel.hidden = YES;
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
            
            
        }];
        

    

}

-(void)updateToServer:(NSDictionary *)dict{
    MJWeakSelf
    [XKNetworkManager POSTToUrlString:GetSellerWriteURL parameters:dict progress:^(CGFloat progress) {
        
                } success:^(id responseObject) {
        
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
        
                    if (dict == nil) {
                        [weakSelf showHint:@"服务器异常"];
        
                        [weakSelf hideHud];
        
                        return ;
                    }
        
        
        
                    NSString *error = [NSString stringWithFormat:@"%@",dict[@"errno"]];
        
                    if (![error isEqualToString:@"0"]) {
                        [weakSelf hideHud];
                        [weakSelf showHint:dict[@"errmsg"]];
                        return ;
                    }
                    [weakSelf hideHud];
        
        
        
                    [weakSelf showHint:@"保存成功"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                    
                    
                } failure:^(NSError *error) {
                  [weakSelf hideHud];
                    
                }];
            

    
}

#pragma mark--viewlayout
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.aginLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mapView.mas_left).offset(10);
        make.bottom.equalTo(self.mapView.mas_bottom).offset(-10);
        make.width.height.equalTo(@(50));
    }];
    
    
    if (ScreenWidth<414) {
        self.mapViewConstant.constant = 180;
        self.contentViewHeightContstant.constant = ScreenHeight+20;

    }else{
        self.mapViewConstant.constant = 220;
        self.contentViewHeightContstant.constant = ScreenHeight-64;

    }
    
  
    
    
}


-(void)setDataToCell:(NSInteger)index with:(LHKMapAnoModel*)model{
    
    LHKSellerWriteCell *cell = (LHKSellerWriteCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    switch (index) {
        case 0:
            cell.descLabel.text = model.nickname;
            self.bussinessName = model.nickname;
            break;
        case 1:
            cell.descLabel.text = model.realName;
            self.responesPeple = model.realName;
            break;

        case 2:
            cell.descLabel.text = model.mobile;
            self.tel = model.mobile;
            break;

        case 3:
        {
            NSString *str =  [NSString returnFiledString:model.industry.integerValue];
            [cell.fieldBtn setTitle:str forState:UIControlStateNormal];
            [cell.fieldBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.fieldType=model.industry;
        }
            
            break;

        case 4:
            cell.descLabel.text = model.address;
            self.coordinate = CLLocationCoordinate2DMake(model.lat, model.lng);
            break;


            
        default:
            break;
    }
    
}



#pragma mark---mapView

-(void)setupMapView{
    
    _mapView.delegate = self;
    _mapView.delegate = self;
    _mapView.zoomLevel = 10;
    
    
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    
    
    [self.locservice startUserLocationService];
 
}

-(BMKLocationService *)locservice{
    if (_locservice == nil) {
        _locservice = [[BMKLocationService alloc]init];
        _locservice.distanceFilter =kCLLocationAccuracyNearestTenMeters;
        _locservice.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        
        _locservice.delegate = self;
        
    }
    return _locservice;
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
   
    if (_where == 1) {
        
        self.coordinate = userLocation.location.coordinate;
        BMKPointAnnotation *annotation1 = [[BMKPointAnnotation alloc]init];
        
        annotation1.coordinate = userLocation.location.coordinate;
        
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        
        [self.mapView removeAnnotations:array];
        
        [self.mapView addAnnotation:annotation1];
        
        
        //地址位置反向编码
        CLLocationCoordinate2D pt = userLocation.location.coordinate;
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                                BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
        
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        
        
        
        BMKCoordinateRegion region = BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.02, 0.02));
        
        [_mapView setRegion:region animated:YES];

    }else{
        //地址位置反向编码
        CLLocationCoordinate2D pt = userLocation.location.coordinate;
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                                BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
        
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }

        
        self.navcoordinate = userLocation.location.coordinate;
    }
    
    
    [self.locservice stopUserLocationService];
    
    
    
}




- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
        
        if (newAnnotationView == nil) {
            newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        }
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
//-(void)viewWillAppear:(BOOL)animated {
//    [_mapView viewWillAppear];
//    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _locservice.delegate = self;
//}
//
//-(void)viewWillDisappear:(BOOL)animated {
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
//    _locservice.delegate = nil;
//    _searcher.delegate = nil;
//    _suggestionSearch.delegate = nil;
//
//}

#pragma mark--地理编码的代理方法
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
//      NSLog(@"------%@---地址--",result.address);
              LHKSellerWriteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
      cell.descLabel.text = result.address;
      
      self.address = result.address;
      
      if(_where == 2){
          
          self.navAddress = result.address;
      }
     
      
 
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}
#pragma mark---正向的地理编码
-(void)geoAddress:(NSString *)address{
    [self.view endEditing:YES];
    
    BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
    
    option.keyword  = address;
    BOOL flag = [self.suggestionSearch suggestionSearch:option];
    if(flag)
    {
        NSLog(@"建议检索发送成功");
    }
    else
    {
        NSLog(@"建议检索发送失败");
    }

    
    
}


//实现Delegate处理回调结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
   
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        
        NSValue *value = [result.ptList firstObject];
        CLLocationCoordinate2D coordinate;
        [value getValue:&coordinate];
        
        
        self.coordinate = coordinate;
        
        BMKPointAnnotation *annotation1 = [[BMKPointAnnotation alloc]init];
        
        annotation1.coordinate = coordinate;
        
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        
        [self.mapView removeAnnotations:array];
        
        [self.mapView addAnnotation:annotation1];
        
        
        BMKCoordinateRegion region = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.02, 0.02));
        
        [_mapView setRegion:region animated:YES];
        

                LHKSellerWriteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        
        NSString *dist = [NSString stringWithFormat:@"%@-%@",[result.keyList firstObject],[result.districtList firstObject]];
       
        cell.descLabel.text = dist;
        self.address = dist;
        
        
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}


-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    
    
    if (![XKNetworkManager networkStateChange]) {
        [self showHint:@"无网络"];
        return;
    }
    
    self.coordinate = coordinate;
    
    
    BMKPointAnnotation *annotation1 = [[BMKPointAnnotation alloc]init];
    
    annotation1.coordinate = coordinate;
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    [self.mapView removeAnnotations:array];
    
    [self.mapView addAnnotation:annotation1];
    
    
    //地址位置反向编码
    CLLocationCoordinate2D pt = coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
    
    
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.02, 0.02));
    
    [self.mapView setRegion:region animated:YES];
    
    
}
#pragma mark---点击上传图片
- (IBAction)iconBtnClick:(UIButton *)sender {
    
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
        [self presentViewController:ipc animated:YES completion:nil];
        
           
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
        [self.iconBtn setImage:resultImage forState:UIControlStateNormal];
    }
    self.saveImage = resultImage;

    
    
  
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}


@end
