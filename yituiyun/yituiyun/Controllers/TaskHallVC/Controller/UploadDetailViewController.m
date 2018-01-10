//
//  UploadDetailViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/21.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "UploadDetailViewController.h"
#import "TaskNodeModel.h"
#import "ShowImageViewController.h"
#import "ChooseImageCell.h"
#import "CancelTaskCell.h"
#import "UploadTextModel.h"
#import "UploadImageModel.h"
#import "UploadViewController.h"
#import "TaskNodeHeadView.h"
#import "NodeUpdateVc.h"
#import "NodeError.h"

@interface UploadDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ChooseImageCellDelegate>
@property (nonatomic, strong) TaskNodeModel *model;
@property (nonatomic, strong) ChooseImageCell *chooseImageCell;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *textDataArray;
@property (nonatomic, strong) NSMutableArray *imageDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *seledIndexPath;
@property (nonatomic, assign) NSInteger where;
/**头部空间 */
@property(nonatomic,strong) TaskNodeHeadView * headView;




@end

@implementation UploadDetailViewController

#pragma mark-headView
-(TaskNodeHeadView *)headView{
    if (_headView == nil) {
        _headView = [TaskNodeHeadView nodeHeadView];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 135);
        if ([self.model.nodeState isEqualToString:@"2"]) {
            _headView.descLabel.text = @"该节点已失效,请重新添加节点";
            _headView.timePanLabel.hidden = NO;
        }else if ([self.model.nodeState isEqualToString:@"1"]){
            _headView.descLabel.text = @"任务资料已审核通过,工资3个工作日内发到易推云账号上";
            _headView.timePanLabel.hidden = YES;

        }else if ([self.model.nodeState isEqualToString:@"3"]){
            _headView.descLabel.text = @"任务资料凭证审核中，请耐心等待";
            _headView.timePanLabel.hidden = YES;
        }else if ([self.model.nodeState isEqualToString:@"4"]){
            _headView.descLabel.text = @"上传的任务资料凭证不符合要求,请重新提交";
            _headView.timePanLabel.hidden = NO;
        }
    }
    return _headView;
}

- (instancetype)initWithTaskNodeModel:(TaskNodeModel *)taskNodeModel WithDataArray:(NSArray *)dataArray WithWhere:(NSInteger)where{
    self = [super init];
    if (self) {
        self.model = taskNodeModel;
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        self.textDataArray = [NSMutableArray array];
        self.imageDataArray = [NSMutableArray array];
        self.where = where;
    }
    return self;
}

#pragma mark 请求网络数据
- (void)dataArrayFromNetwork {
    [self showHudInView:self.view hint:@"加载中..."];
    __weak UploadDetailViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"nodeid"] = _model.nodeId;
    if (![ZQ_CommonTool isEmptyArray:_dataArray]) {
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        for (NSInteger i = 0 ; i < _dataArray.count; i++) {
            NSDictionary *dic = _dataArray[i];
            [value setValue:dic forKey:[NSString stringWithFormat:@"%zd", i]];
        }
        params[@"setting"] = value;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.collectData"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            
            

            NSDictionary *dic = [responseObject objectForKey:@"rst"];
            
           dispatch_async(dispatch_get_main_queue(), ^{
               
               if ([self.model.nodeState isEqualToString:@"4"]) {
                   _headView.dict = dic[@"node"];
                   [weakSelf nodeStatePanDuan:4];
                 
               }else if ([self.model.nodeState isEqualToString:@"3"]){
                                      [weakSelf nodeStatePanDuan:[self.model.nodeState integerValue]];
               }else if ([self.model.nodeState isEqualToString:@"1"]){
                   [weakSelf nodeStatePanDuan:[self.model.nodeState integerValue]];
               }

               
               
           });
            NSArray *imgs = [dic objectForKey:@"imgs"];
            NSArray *text = [dic objectForKey:@"text"];
            if (![ZQ_CommonTool isEmptyArray:text]) {
                [_textDataArray removeAllObjects];
                for (NSDictionary *subDic in text) {
                    UploadTextModel *model = [[UploadTextModel alloc] init];
                    model.taskName = [NSString stringWithFormat:@"%@",  subDic[@"name_zh"]];
                    model.taskField = [NSString stringWithFormat:@"%@",  subDic[@"name_en"]];
                    model.taskId = _model.nodeId;
                    model.taskText = [NSString stringWithFormat:@"%@",  subDic[@"value"]];
                    [_textDataArray addObject:model];
                }
            }
            if (![ZQ_CommonTool isEmptyArray:imgs]) {
                [_imageDataArray removeAllObjects];
                for (NSDictionary *subDic in imgs) {
                    UploadImageModel *model = [[UploadImageModel alloc] init];
                    model.taskName = [NSString stringWithFormat:@"%@",  subDic[@"name_zh"]];
                    model.taskField = [NSString stringWithFormat:@"%@",  subDic[@"name_en"]];
                    model.taskId = _model.nodeId;
                    model.imageArray = [NSMutableArray array];
                    for (NSDictionary *dic in subDic[@"value"]) {
                        [model.imageArray addObject:dic[@"url"]];
                    }
                    [_imageDataArray addObject:model];
                }
            }
            [_tableView reloadData];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}


-(void)nodeStatePanDuan:(NSInteger)status{
   MJWeakSelf
    switch (status) {
        case 1:
        {
            weakSelf.headView.FistBtn.selected = YES;
            weakSelf.headView.SecondBtn.selected = YES;
            weakSelf.headView.threeBtn.selected = YES;
            weakSelf.headView.arrorw1Btn.selected = YES;
            weakSelf.headView.arrorw2Btn.selected = YES;
        }
            
            break;
        case 2:
        {
            weakSelf.headView.FistBtn.selected = NO;
            weakSelf.headView.SecondBtn.selected = NO;
            weakSelf.headView.threeBtn.selected = NO;
            weakSelf.headView.arrorw1Btn.selected = NO;
            weakSelf.headView.arrorw2Btn.selected = NO;

        }
            break;
        case 3:
        {
            weakSelf.headView.FistBtn.selected = YES;
            weakSelf.headView.SecondBtn.selected = YES;
            weakSelf.headView.threeBtn.selected = NO;
            weakSelf.headView.arrorw1Btn.selected = NO;
            weakSelf.headView.arrorw2Btn.selected = YES;

        }
            break;
        case 4:
        {
            weakSelf.headView.FistBtn.selected = YES;
            weakSelf.headView.SecondBtn.selected = NO;
            weakSelf.headView.threeBtn.selected = NO;
            weakSelf.headView.arrorw1Btn.selected = NO;
            weakSelf.headView.arrorw2Btn.selected = NO;
            
        }

            break;


            
        default:
            break;
    }
}
#pragma mark-viewDid

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self setupNav];
    [self setupTableView];
    [self dataArrayFromNetwork];
}

#pragma mark - setupNav
- (void)setupNav{
   
    if ([self.model.nodeState isEqualToString:@"1"]) {
        self.navigationItem.title = @"已审核";
    }else if ([self.model.nodeState isEqualToString:@"2"]){
        self.navigationItem.title = @"已失效";
    }else if ([self.model.nodeState isEqualToString:@"3"]){
        self.navigationItem.title = @"审核中";
    }else if ([self.model.nodeState isEqualToString:@"4"]){
        self.navigationItem.title = @"审核失败";
    }


    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    if ([_model.nodeState isEqualToString:@"3"] ) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    }
    
    if ([_model.nodeState isEqualToString:@"4"] ) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"重新提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAgain)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    }
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-again

//审核失败
-(void)rightBarButtonItemAgain{
    //审核失败
    [SVProgressHUD showWithStatus:@"加载中..."];
    MJWeakSelf
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"nodeid"] = self.model.nodeId;
    
    [XKNetworkManager POSTToUrlString:TaskNodeTimeDetail parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];

        NSDictionary *josnDict = JSonDictionary;
        NSDictionary *timeDict = josnDict[@"rst"][@"node"];
      
           NodeError  *vc = [[NodeError alloc] initWithTaskNodeModel:_model WithTextDataArray:_textDataArray WithImageDataArray:_imageDataArray WithWhere:3];
     
            vc.nodeStatus = self.model.nodeState;
        vc.timeDict = timeDict;
     [weakSelf.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}

- (void)rightBarButtonItem
   {
            //审核中修改
        NodeUpdateVc *vc = [[NodeUpdateVc alloc] initWithTaskNodeModel:_model WithTextDataArray:_textDataArray WithImageDataArray:_imageDataArray WithWhere:3];
        vc.nodeStatus = self.model.nodeState;
        pushToControllerWithAnimated(vc);
    }

- (void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 135, ZQ_Device_Width, ZQ_Device_Height - 64-135) style:UITableViewStylePlain];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.tableFooterView = [UIView new];

    [self.view addSubview:_tableView];
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
    if (indexPath.section == 0 ) {
        CancelTaskCell *cell = [CancelTaskCell cellWithTableView:tableView];

            UploadTextModel *model = _textDataArray[indexPath.row];
        NSString *taskString = [NSString stringWithFormat:@"%@:",model.taskName];
            cell.nameLabel.text = taskString;
            NSString *string = nil;
            if ([ZQ_CommonTool isEmpty:model.taskText]) {
                string = @"";
            } else {
                string = model.taskText;
            }
            cell.textField.text = string;
        cell.textField.userInteractionEnabled = NO;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    ChooseImageCell *cell = [ChooseImageCell cellWithTableView:tableView];
    _chooseImageCell = cell;
    cell.indexPath = indexPath;
    cell.delegate = self;
    UploadImageModel *imageModel = _imageDataArray[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(最多上传10张)", imageModel.taskName];
    [cell.imageArray removeAllObjects];
    
    if (![ZQ_CommonTool isEmptyArray:imageModel.imageArray]) {
        [cell.imageArray addObjectsFromArray:imageModel.imageArray];
    }
    [cell readOnlyMakeView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {

        return _chooseImageCell.height;
    }
    return 44;
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


#pragma mark - ChooseImageCellDelegate
- (void)picturesButtonClickTag:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    UploadImageModel *model = _imageDataArray[indexPath.row];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:model.imageArray];
    [vc seleImageLocation:tag];
    pushToControllerWithAnimated(vc)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.headView) {
        [self.headView closeTime];
    }

}

@end
