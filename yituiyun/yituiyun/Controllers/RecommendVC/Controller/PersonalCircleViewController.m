//
//  PersonalCircleViewController.m
//  yituiyun
//
//  Created by 张强 on 2017/1/4.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "PersonalCircleViewController.h"
#import "ZHPersonShowTableViewCell.h"
#import "CommentsModel.h"
#import "CollectModel.h"
#import "ReplyModel.h"
#import "ZHShareTextView.h"
#import "UserInfoModel.h"
#import "ZHPriseTableViewCell.h"
#import "ZHReplayTableViewCell.h"
#import "HFTextView.h"
#import "ZHReigonTableViewCell.h"
#import "ReleaseAllyCircleViewController.h"
#import "FXPersonDetailController.h"
#import "FXCompanyDetailController.h"
#import "ShowImageViewController.h"
#import "CommentsAndPraiseAllCircleViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
@interface PersonalCircleViewController ()<UITableViewDelegate, UITableViewDataSource, ZQPersonCommentsCellDelegate, UITextViewDelegate,UIAlertViewDelegate, ZHReplayTableViewCellDeleagete, ZHPriseTableViewCellDeleagete,ZHReigonTableViewCellDelegete,ReleaseAllyCircleViewControllerDeleagete,CommentsAndPraiseAllCircleViewControllerDeleagete>

@property (nonatomic, strong) UITableView *workTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ZHPersonShowTableViewCell *topicCommentsCell;
@property (nonatomic, strong) ZHPriseTableViewCell *priseCell;
@property (nonatomic, strong) ZHReplayTableViewCell *replayCell;

@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) ZHShareTextView *textView;
@property (nonatomic, strong) UserInfoModel *model;

@property (nonatomic, strong) UILabel *thereLabel;

@property (nonatomic, strong) UILabel *thereLabel1;

@property (nonatomic, copy) NSString *isReplay;

@property (nonatomic, assign) CGFloat keyboardY;
@property (nonatomic, strong) UIButton *putBtn;

@property (nonatomic, strong) UIButton *morrBtn;

@property (nonatomic, strong) UIView *upView;

@property (nonatomic, strong) HFTextView *hfView;

@property (nonatomic, strong) NSMutableArray *indPathArray;

@property (nonatomic, strong) UIView *backHeadView;
@property (nonatomic, strong) UIView *xiaoView;

@property (nonatomic, copy) NSString *avater;
@property (nonatomic, copy) NSString *numString;

@property (nonatomic, assign) NSInteger where;
@property (nonatomic, copy) NSString *titleString;


@end

@implementation PersonalCircleViewController
- (instancetype)initWithWhere:(NSInteger)where{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.model = [[UserInfoModel alloc] init];
        self.indPathArray = [NSMutableArray array];
        self.isremo = YES;
        self.page = @"1";
        self.where = where;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [ZQ_CallMethod setupNewMessageBoxCount];
}

- (void)dealloc{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)isReadXiao{
//    __weak PersonalCircleViewController *weakSelf = self;
//    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"uid"] = infoModel.userID;
//    [weakSelf showHudInView:self.navigationController.view hint:@"加载中..."];
//    NSString *URL = [kHost stringByAppendingString:@"api.php?m=get.get_nums"];
//    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
//            NSDictionary *dic = responseObject[@"rst"];
//            _numString = [NSString stringWithFormat:@"%@", dic[@"sums"]];
//            if ([_numString integerValue] != 0) {
//                [weakSelf.view addSubview:weakSelf.backHeadView];
//                [weakSelf.backHeadView addSubview:weakSelf.xiaoView];
//            } else {
//                weakSelf.backHeadView.frame = CGRectMake(0, 0, 0, 0.0001);
//            }
//        } else {
//            weakSelf.backHeadView.frame = CGRectMake(0, 0, 0, 0.0001);
//        }
//        [weakSelf tableArrayFromNetwork];
//        [weakSelf setupTableView];
//        [weakSelf setupRefresh];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
//        weakSelf.backHeadView.frame = CGRectMake(0, 0, 0, 0.0001);
//        [weakSelf tableArrayFromNetwork];
//        [weakSelf setupTableView];
//        [weakSelf setupRefresh];
//    }];
    
    self.backHeadView.frame = CGRectMake(0, 0, 0, 0.0001);
    [self tableArrayFromNetwork];
    [self setupTableView];
    [self setupRefresh];
}

- (UIView *)backHeadView{
    if (!_backHeadView) {
        _backHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 50)];
        _backHeadView.backgroundColor = [UIColor clearColor];
    }
    return _backHeadView;
}

- (UIView *)xiaoView{
    if (!_xiaoView) {
        _xiaoView = [[UIView alloc] initWithFrame:CGRectMake((ZQ_Device_Width - 130)/2, 10, 130, 30)];
        _xiaoView.backgroundColor = MainColor;
        _xiaoView.layer.cornerRadius = 5;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkDetail1)];
        [_xiaoView addGestureRecognizer:tap];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _xiaoView.width, _xiaoView.height)];
        lable.text = [NSString stringWithFormat:@"您有%@条新消息",_numString];
        lable.font = [UIFont systemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [_xiaoView addSubview:lable];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_xiaoView.width - 18, 9, 12, 12)];
        imageView1.image = [UIImage imageNamed:@"right_icon_03"];
        [_xiaoView addSubview:imageView1];
    }
    return _xiaoView;
}

- (void)checkDetail1
{
    self.backHeadView.frame = CGRectMake(0, 0, 0, 0.0001);
    if (_where == 1) {
        self.workTableView.frame = CGRectMake(0, CGRectGetMaxY(self.backHeadView.frame), ZQ_Device_Width, ZQ_Device_Height - 64 - CGRectGetMaxY(self.backHeadView.frame));
    } else {
        self.workTableView.frame = CGRectMake(0, CGRectGetMaxY(self.backHeadView.frame), ZQ_Device_Width, ZQ_Device_Height - 64 - 44 - CGRectGetMaxY(self.backHeadView.frame));
    }
    CommentsAndPraiseAllCircleViewController *vc = [[CommentsAndPraiseAllCircleViewController alloc] init];
    pushToControllerWithAnimated(vc)
}

- (void)getBuddyListArray
{
    __weak PersonalCircleViewController *weakSelf = self;
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            NSMutableArray *contactsSource = [NSMutableArray array];
            NSArray *blockList = [[EMClient sharedClient].contactManager getBlackList];
            for (NSString *buddy in aList) {
                if (![blockList containsObject:buddy]) {
                    [contactsSource addObject:buddy];
                }
            }
            _buddyListString = [NSString stringWithFormat:@"%@", infoModel.userID];
            for (NSString *string in contactsSource) {
                if ([ZQ_CommonTool isEmpty:_buddyListString]) {
                    _buddyListString = [NSString stringWithFormat:@"%@", string];
                } else {
                    _buddyListString = [NSString stringWithFormat:@"%@,%@", _buddyListString, string];
                }
            }
            [weakSelf tableArrayFromNetwork];
        }
    }];
}

#pragma mark ---- 秀数据
- (void)tableArrayFromNetwork {
//    if ([ZQ_CommonTool isEmpty:_buddyListString]) {
//        [self getBuddyListArray];
//        return;
//    }
    
    __weak PersonalCircleViewController *weakSelf = self;
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = _page;
    params[@"uid"] = infoModel.userID;
    params[@"type"] = @"all";
    params[@"uidStr"] = _buddyListString;
    NSString *URL = [kHost stringByAppendingString:@"api.php?m=get.dynamicList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *diccc = [responseObject objectForKey:@"rst"];
            NSString *string = [diccc objectForKey:@"nums"];
            [USERDEFALUTS setInteger:[string integerValue] forKey:@"allyCircleCount"];
            [USERDEFALUTS synchronize];
            [ZQ_CallMethod setupNewMessageBoxCount];
            
            NSArray *listData = [diccc objectForKey:@"info"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *dic in listData) {
                    CommentsModel *model = [[CommentsModel alloc] init];
                    model.evaluationName = dic[@"nickname"];//发布人的姓名
                    model.evaluationId = dic[@"memberid"];//发布人id
                    model.evaluationHeadPortrait = dic[@"avatar"];//头像
                    model.uModelid = dic[@"uModelid"];
                    model.isShow = @"0";
                    model.evaluationContent = dic[@"content"];//发布内容
                    model.evaluationTime = dic[@"inputtime"];//发布时间
                    model.isPrise = dic[@"isFav"];//是否点赞
                    model.region = dic[@"place"];//位置
                    model.dynamicID = dic[@"dynamicId"];//动态ID
                    model.isMoreComment = dic[@"commentNum"];//是否有更多评论
                    model.evaluationImagesArray = [NSMutableArray array];
                    model.praiseArray = [NSMutableArray array];
                    model.replyArray = [NSMutableArray array];
                    model.isEditMore = @"0";
                    model.video = dic[@"video"];
                    model.videoThumb = dic[@"thumb"];
                    //评论图片数组
                    for (NSDictionary *albumDic in dic[@"showImages"]) {
                        [model.evaluationImagesArray addObject:albumDic];
                    }
                    //点赞人的数组
                    for (NSDictionary *collDic in dic[@"favsUsers"]) {
                        CollectModel *collModel = [[CollectModel alloc] init];
                        collModel.collectID = collDic[@"uid"];
                        collModel.uModelid = collDic[@"uModelid"];
                        collModel.collectHeadtrid = collDic[@"avatar"];
                        [model.praiseArray addObject:collModel];
                    }
                    //回复的内容
                    NSArray *commContArray = dic[@"commentUsers"];
                    for (NSDictionary *comDic in commContArray) {
                        ReplyModel *replymodel = [[ReplyModel alloc] init];
                        replymodel.dynamicid = comDic[@"dynamicid"];
                        replymodel.cid = comDic[@"commentId"];
                        replymodel.evaluationName = comDic[@"nickname"];//评论人的姓名
                        replymodel.evaluationUModelid = comDic[@"uModelid"];
                        replymodel.evaluationId = comDic[@"memberid"];
                        replymodel.replyid = comDic[@"rid"];
                        replymodel.replyUModelid = comDic[@"uModelid2"];
                        replymodel.replyName = comDic[@"nickname2"];//被评论人的姓名
                        replymodel.replyContent = comDic[@"content"];
                        if ([infoModel.userID integerValue] == [comDic[@"memberid"] integerValue]) {
                            replymodel.isdelte = @"1";//1:可删;0:不可删
                        }
                        [model.replyArray addObject:replymodel];
                    }
                    [listDataArray addObject:model];
                }
            }
            [weakSelf configuration:listDataArray];
        } else {
            if (![_page isEqualToString:@"1"]) {
                int i = [_page intValue];
                self.page = [NSString stringWithFormat:@"%d", i - 1];
            }
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        if (![_page isEqualToString:@"1"]) {
            int i = [_page intValue];
            self.page = [NSString stringWithFormat:@"%d", i - 1];
        }
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)configuration:(NSArray *)array
{
    if (_isremo == YES) {
        if ([_dataArray count] != 0) {
            [_dataArray removeAllObjects];
        }
    }
    if (![ZQ_CommonTool isEmptyArray:array]) {
        [_dataArray addObjectsFromArray:array];
    }
    if (_dataArray.count == 0) {
        self.workTableView.tableHeaderView = self.thereLabel;
    } else {
        self.workTableView.tableHeaderView = self.thereLabel1;
    }
    [self.workTableView reloadData];
}

//没有评论时提示
- (UILabel *)thereLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 150)];
    label.text = @"还没有发布盟友圈";
    label.textColor = [UIColor blackColor];
    label.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.f];
    return label;
}

- (UILabel *)thereLabel1
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 0.1)];
    return label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"盟友圈";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    // 先判断有没有未读的消息
    [self isReadXiao];
    [self setupNav];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//创建导航栏
- (void)setupNav{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"add_icon2" selectedImage:@"add_icon2" target:self action:@selector(topRightAction)];
}

- (void)leftBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topRightAction{
    ReleaseAllyCircleViewController *vc = [[ReleaseAllyCircleViewController alloc] initWithWhere:1];
    vc.deleagete = self;
    pushToControllerWithAnimated(vc)
}

- (void)tableViewDataReload
{
    self.isremo = YES;
    self.page = @"1";
    [self tableArrayFromNetwork];
}

- (void)gobackTableViewReload
{
    [self tableViewDataReload];
}

- (void)setupTableView{
    if (_where == 1) {
        self.workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backHeadView.frame), ZQ_Device_Width, ZQ_Device_Height - 64 - CGRectGetMaxY(self.backHeadView.frame)) style:UITableViewStyleGrouped];
    } else {
        self.workTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backHeadView.frame), ZQ_Device_Width, ZQ_Device_Height - 64 - 44 - CGRectGetMaxY(self.backHeadView.frame)) style:UITableViewStyleGrouped];
    }
    [_workTableView setDelegate:(id<UITableViewDelegate>) self];
    [_workTableView setDataSource:(id<UITableViewDataSource>) self];
    [_workTableView setShowsVerticalScrollIndicator:NO];
    _workTableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _workTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_workTableView];
}

#pragma mark - 添加刷新
- (void)setupRefresh{
    [_workTableView setHeadRefreshWithTarget:self withAction:@selector(loadNewStatus)];
    [_workTableView setFootRefreshWithTarget:self withAction:@selector(loadMoreStatus)];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark 下拉刷新
- (void)loadNewStatus
{
    self.isremo = YES;
    self.page = @"1";
    [_workTableView endRefreshing];
    [self tableArrayFromNetwork];
}

#pragma mark 上拉加载
- (void)loadMoreStatus
{
    self.isremo = NO;
    int i = [_page intValue];
    self.page = [NSString stringWithFormat:@"%d", i + 1];
    [_workTableView endRefreshing];
    [self tableArrayFromNetwork];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CommentsModel *model = _dataArray[section];
    if (![ZQ_CommonTool isEmptyArray:model.praiseArray]) {
        if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
            return model.replyArray.count + 3;
        } else {
            return 3;
        }
    } else {
        if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
            return model.replyArray.count + 2;
        } else {
            return 2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsModel *model = _dataArray[indexPath.section];
    ReplyModel *replayModel;
    if (indexPath.row == 0) {
        return model.commentCellH;
    } else if (indexPath.row == 1) {
        return model.reginHeight;
    } else {
        if (![ZQ_CommonTool isEmptyArray:model.praiseArray]) {
            if (indexPath.row == 2) {
                if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
                    return model.priseCellH - 10;
                } else {
                    return model.priseCellH;
                }
            } else {
                replayModel = model.replyArray[indexPath.row - 3];
                if (model.replyArray.count > 1) {
                    if (indexPath.row - 2 != model.replyArray.count) {
                        return replayModel.replyCellH;
                    } else {
                        return replayModel.replyCellH + 10;
                    }
                }
            }
        } else {
            replayModel = model.replyArray[indexPath.row - 2];
            if (model.replyArray.count > 1) {
                if (indexPath.row - 1 != model.replyArray.count) {
                    return replayModel.replyCellH;
                } else {
                    return replayModel.replyCellH + 10;
                }
            }
        }
    }
    
    return replayModel.replyCellH + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    CommentsModel *model = _dataArray[indexPath.section];
    if (indexPath.row == 0) {
        ZHPersonShowTableViewCell * cell = [ZHPersonShowTableViewCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.commentsModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 1) {
        ZHReigonTableViewCell *cell = [[ZHReigonTableViewCell alloc] init];
        cell.delegete = self;
        cell.indexPath = indexPath;
        cell.commentsModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if (![ZQ_CommonTool isEmptyArray:model.praiseArray]) {
            if (indexPath.row == 2) {
                ZHPriseTableViewCell *cell = [[ZHPriseTableViewCell alloc] init];
                cell.deleagete = self;
                cell.indexPath = indexPath;
                cell.model = model;
                _priseCell = cell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
                    ZHReplayTableViewCell *cell = [[ZHReplayTableViewCell alloc] init];
                    cell.delegate = self;
                    cell.indexPath = indexPath;
                    _priseCell.lineView.hidden = false;
                    cell.commentsModel = model.replyArray[indexPath.row - 3];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
        } else {
            if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
                ZHReplayTableViewCell *cell = [[ZHReplayTableViewCell alloc] init];
                cell.delegate = self;
                cell.indexPath = indexPath;
                cell.commentsModel = model.replyArray[indexPath.row - 2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                _priseCell.lineView.hidden = true;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self shuaXingSection];
}

//收起更多小界面
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self shuaXingSection];
}

- (void)shuaXingSection{
    for (NSIndexPath *path in _indPathArray) {
        CommentsModel *com = _dataArray[path.section];
        ZHReigonTableViewCell *cell = [_workTableView cellForRowAtIndexPath:path];
        com.isEditMore = @"0";
        cell.btnView.hidden = true;
    }
    [_indPathArray removeAllObjects];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -- 第一个cell预览图片/头像点击
//预览图片
- (void)reviewImagesButtonClickWithIndex:(NSIndexPath *)index WithImageTag:(NSInteger)tag{
    CommentsModel *model = _dataArray[index.section];
    if ([ZQ_CommonTool isEmpty:model.video]) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in model.evaluationImagesArray) {
            [array addObject:dic[@"url"]];
        }
        ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
        vc.delegate = self;
        vc.indexPath = index;
        [vc seleImageLocation:tag];
        pushToControllerWithAnimated(vc)
    } else {
        NSString *string = [NSString stringWithFormat:@"http://yituiyun.oss-cn-shanghai.aliyuncs.com/video/%@", model.video];
        NSString *urlStr = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [moviePlayerController.moviePlayer prepareToPlay];
        moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
    }
}

//点击头像
- (void)gotoPersonAction:(NSIndexPath *)indexPath WithBtnTag:(NSInteger)tag{
    CommentsModel *model = _dataArray[indexPath.section];
    if ([model.uModelid integerValue] == 6) {
        FXPersonDetailController *detailVc = [[FXPersonDetailController alloc] initPersonId:model.evaluationId];
        pushToControllerWithAnimated(detailVc)
    } else if ([model.uModelid integerValue] == 5) {
        FXCompanyDetailController *vc = [[FXCompanyDetailController alloc] initCompanyID:model.evaluationId];
        pushToControllerWithAnimated(vc)
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -- 第二个cell里的button点击
- (void)btnPersonShowButtonClickWithIndex:(NSIndexPath *)indexPath WithBtnTag:(UIButton *)button{
    
    _selectIndexPath = nil;
    _selectIndexPath = indexPath;
    CommentsModel *model = _dataArray[indexPath.section];
    if (button.tag == 1000) {//删除盟友圈
        __weak PersonalCircleViewController *weakSelf = self;
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"是否确认删除该条盟友圈"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 CommentsModel *model = _dataArray[_selectIndexPath.section];
                 [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
                 
                 NSMutableDictionary *params = [NSMutableDictionary dictionary];
                 UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
                 params[@"memberid"] = userInfo.userID;
                 params[@"dynamicid"] = model.dynamicID;
                 NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.delDynamic"];
                 [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                     [weakSelf hideHud];
                     if ([responseObject[@"errno"] isEqualToString:@"0"]) {
                         [weakSelf.workTableView beginUpdates];
                         [weakSelf.dataArray removeObject:model];
                         [weakSelf.workTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                         [weakSelf.workTableView endUpdates];
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     [weakSelf hideHud];
                     [weakSelf showHint:@"网络状况较差，加载失败"];
                 }];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    } else if (button.tag == 1001) {//赞
        [self shuaXingSection];
        [self priseDynmc];
    } else if (button.tag == 1002) {//评论
        [self shuaXingSection];
        _isReplay = @"1";
        [self.view addSubview:self.upView];//全屏收键盘手势
        [self.view addSubview:self.backView];//输入框背景
        [self.backView addSubview:self.textView];//输入框
        [self.backView addSubview:self.putBtn];//发送键
        self.textView.placeHolder = @"评论";
        [self.textView becomeFirstResponder];
    } else if (button.tag == 1003) {//分享
        [self shuaXingSection];
        [self forwarding:button];
    } else if (button.tag == 1004) {//更多
        self.morrBtn = nil;
        self.morrBtn = button;
        for (CommentsModel *com in _dataArray) {
            if ([com.dynamicID isEqualToString:model.dynamicID]) {
                if ([model.isEditMore isEqualToString:@"1"]) {
                    com.isEditMore = @"0";
                } else if ([model.isEditMore isEqualToString:@"0"]) {
                    com.isEditMore = @"1";
                }
            } else {
                com.isEditMore = @"0";
            }
        }
        
        BOOL isHave = true;
        for (NSIndexPath *path in _indPathArray) {
            if ([path isEqual:indexPath]) {
                isHave = false;
            }
        }
        if (isHave == true) {
            if (_indPathArray.count >= 3) {
                [_indPathArray removeObjectAtIndex:0];
                [_indPathArray addObject:indexPath];
            } else {
                [_indPathArray addObject:indexPath];
            }
        }
        for (NSIndexPath *path in _indPathArray) {
            CommentsModel *com = _dataArray[path.section];
            ZHReigonTableViewCell * cell = [_workTableView cellForRowAtIndexPath:path];
            if ([com.isEditMore isEqualToString:@"1"]) {
                cell.btnView.hidden = false;
            } else if ([com.isEditMore isEqualToString:@"0"]) {
                cell.btnView.hidden = true;
            }
        }
    }
}

#pragma mark-- 点赞/取消赞
- (void)priseDynmc{
    
    __weak PersonalCircleViewController *weakSelf = self;
    NSString *string = nil;
    CommentsModel *model = _dataArray[_selectIndexPath.section];
    if ([model.isPrise isEqualToString:@"1"]) {
        string = @"0";
    } else {
        string = @"1";
    }
    NSString *url = [kHost stringByAppendingString:@"api.php?m=user.dynamicFavour"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
    parameters[@"uid"] = userInfo.userID;
    parameters[@"did"] = model.dynamicID;
    parameters[@"uid2"] = model.evaluationId;
    parameters[@"nickname"] = userInfo.nickname;
    parameters[@"status"] = string;
    [HFRequest requestWithUrl:url parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            
            if ([model.isPrise isEqualToString:@"1"]) {
                for (CollectModel *collModel in model.praiseArray) {
                    if ([collModel.collectID isEqualToString:userInfo.userID]) {
                        [model.praiseArray removeObject:collModel];
                        break;
                    }
                }
                
                model.isPrise = @"0";
                
                if ([ZQ_CommonTool isEmptyArray:model.praiseArray]) {
                    [weakSelf.workTableView beginUpdates];
                    [weakSelf.workTableView reloadSections:[NSIndexSet indexSetWithIndex:_selectIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                    [weakSelf.workTableView endUpdates];
                } else {
                    [weakSelf.workTableView beginUpdates];
                    NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:1 inSection:_selectIndexPath.section];
                    NSIndexPath *indexPath_2 = [NSIndexPath indexPathForRow:2 inSection:_selectIndexPath.section];
                    NSArray *indexArray = @[indexPath_1, indexPath_2];
                    [weakSelf.workTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                    [weakSelf.workTableView endUpdates];
                }
            } else {
                CollectModel *collModel = [[CollectModel alloc] init];
                collModel.collectID = userInfo.userID;
                collModel.collectHeadtrid = userInfo.avatar;
                collModel.uModelid = userInfo.identity;
                [model.praiseArray addObject:collModel];
                model.isPrise = @"1";
                
                if (model.praiseArray.count == 1) {
                    [weakSelf.workTableView beginUpdates];
                    [weakSelf.workTableView reloadSections:[NSIndexSet indexSetWithIndex:_selectIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                    [weakSelf.workTableView endUpdates];
                } else {
                    NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:1 inSection:_selectIndexPath.section];
                    NSIndexPath *indexPath_2 = [NSIndexPath indexPathForRow:2 inSection:_selectIndexPath.section];
                    NSArray *indexArray = @[indexPath_1, indexPath_2];
                    [self.workTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败"];
    }];
}

- (void)forwarding:(UIButton *)button{
    [self showHudInView:self.view hint:@"加载中..."];
    __weak PersonalCircleViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"share";
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost, @"api.php?m=data.config"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        model.shareTitle = [NSString stringWithFormat:@"%@", responseObject[@"shareTitle"]];
        model.shareDescription = [NSString stringWithFormat:@"%@", responseObject[@"shareDescription"]];
        model.shareImg = [NSString stringWithFormat:@"%@%@", kHost, responseObject[@"shareImg"]];
        model.shareUrl = [NSString stringWithFormat:@"%@index.php?m=default.download", kHost];
        [ZQ_AppCache save:model];
        [weakSelf share:button];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)share:(UIButton *)button{
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [SSUIShareActionSheetStyle setStatusBarStyle:UIStatusBarStyleLightContent];
    [SSUIShareActionSheetStyle setActionSheetColor:kUIColorFromRGB(0xeeeeee)];
    [SSUIShareActionSheetStyle setItemNameColor:kUIColorFromRGB(0x777777)];
    [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:11]];
    [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:kUIColorFromRGB(0xeeeeee)];
    [SSUIShareActionSheetStyle setCancelButtonLabelColor:kUIColorFromRGB(0x666666)];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:model.shareDescription
                                     images:@[model.shareImg]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.shareUrl]]
                                      title:model.shareTitle
                                       type:SSDKContentTypeAuto];
    
    
    [shareParams SSDKSetupQQParamsByText:model.shareDescription
                                   title:model.shareTitle
                                     url:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.shareUrl]]
                              thumbImage:[NSURL URLWithString:model.shareImg]
                                   image:nil
                                    type:SSDKContentTypeWebPage
                      forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    NSArray * platforms =@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatFav),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)];
    //2、分享
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:button
                                                                     items:platforms
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                               {
                                                                   [MobClick event:@"shareObjectNums"];
                                                                   
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                               case SSDKResponseStateFail:
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                                   
                                                               default:
                                                                   break;
                                                           }
                                                       }];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark --- 点赞人员点击头像
- (void)goToPerson:(NSIndexPath *)indexPath WithPerTag:(NSInteger)perTag{
    CommentsModel *model = _dataArray[indexPath.section];
    CollectModel *collModel = model.praiseArray[perTag];
    if ([collModel.uModelid integerValue] == 6) {
        FXPersonDetailController *detailVc = [[FXPersonDetailController alloc] initPersonId:collModel.collectID];
        pushToControllerWithAnimated(detailVc)
    } else if ([collModel.uModelid integerValue] == 5) {
        FXCompanyDetailController *vc = [[FXCompanyDetailController alloc] initCompanyID:collModel.collectID];
        pushToControllerWithAnimated(vc)
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -- 第三个cell评论人名字和长按删除点击
//点击评论的名字
//- (void)replayWithUserId:(NSString*)userId withUserName:(NSString*)userName{
//    if ([userId isEqualToString:UserDefaultsGet(UserId)]) { // 工作室
////        GRPreviewViewController *zh = [[GRPreviewViewController alloc] init];
////        [self.navigationController pushViewController:zh animated:true];
//    } else {
//        NSString *string = nil;
//        if ([ZQ_CommonTool isEmpty:userId]) {
//            string = UserDefaultsGet(ReplayID);
//        } else {
//            string = userId;
//        }
////        ZHFanceDetailViewController *fa = [[ZHFanceDetailViewController alloc] initWithPersonID:string];
////        [self.navigationController pushViewController:fa animated:true];
//    }
//}

//点击评论的名字
- (void)clickCommentPeopleWithIndexPath:(NSIndexPath*)indexPath
{
    CommentsModel *model = _dataArray[indexPath.section];
    ReplyModel *replayModel;
    if (![ZQ_CommonTool isEmptyArray:model.praiseArray]) {
        if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
            replayModel = model.replyArray[indexPath.row - 3];
        }
    } else {
        if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
            replayModel = model.replyArray[indexPath.row - 2];
        }
    }
    
    if ([replayModel.evaluationUModelid integerValue] == 6) {
        FXPersonDetailController *detailVc = [[FXPersonDetailController alloc] initPersonId:replayModel.evaluationId];
        pushToControllerWithAnimated(detailVc)
    } else if ([replayModel.evaluationUModelid integerValue] == 5) {
        FXCompanyDetailController *vc = [[FXCompanyDetailController alloc] initCompanyID:replayModel.evaluationId];
        pushToControllerWithAnimated(vc)
    }
}

//长按删除,只能删除自己的评论
- (void)longPressWithIndexPath:(NSIndexPath*)indexPath{
    [WCAlertView showAlertWithTitle:@"提示"
                            message:@"是否确认删除该条评论"
                 customizationBlock:^(WCAlertView *alertView) {
                     
                 } completionBlock:
     ^(NSUInteger buttonIndex, WCAlertView *alertView) {
         if (buttonIndex == 1) {
             [self deleateActionShowReply:indexPath];
         }
     } cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
}

- (void)deleateActionShowReply:(NSIndexPath*)indexPath {
    [self showHudInView:self.view hint:@"加载中..."];
    __weak PersonalCircleViewController *weakSelf = self;
    
    CommentsModel *model = _dataArray[indexPath.section];
    ReplyModel *replayModel;
    if (![ZQ_CommonTool isEmptyArray:model.praiseArray]) {
        if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
            replayModel = model.replyArray[indexPath.row - 3];
        }
    } else {
        if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
            replayModel = model.replyArray[indexPath.row - 2];
        }
    }
    NSString *url = [kHost stringByAppendingString:@"api.php?m=my.delDynamicComment"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
    parameters[@"memberid"] = userinfo.userID;// 用户ID
    parameters[@"dynamicid"] = replayModel.dynamicid;//动态ID
    parameters[@"commentid"] = replayModel.cid;//评论ID
    [HFRequest requestWithUrl:url parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            [model.replyArray removeObject:replayModel];
            [weakSelf.workTableView beginUpdates];
            [weakSelf.workTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.workTableView endUpdates];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

//#pragma mark --- 点击回复评论
///** 点击回复评论 */
//- (void)replayCommentWithIndexPath:(NSIndexPath*)indexPath WithtextView:(HFTextView *)textView{
//
//    self.hfView = nil;
//    self.hfView = textView;
//
//    _isReplay = @"2";
//
//    _selectIndexPath = nil;
//    _selectIndexPath = indexPath;
//    // 这个需要判断
//
//    CommentsModel *model = _dataArray[indexPath.section];
//
//
//    ReplyModel *replayModel;
//    if (![ZQ_CommonTool isEmptyArray:model.praiseArray]) {
//        if (_selectIndexPath.row == 1) {
//        } else {
//            if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
//                replayModel = model.replyArray[_selectIndexPath.row - 3];
//            }
//        }
//    } else {
//        if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
//            replayModel = model.replyArray[_selectIndexPath.row - 2];
//        }
//    }
//    NSString *string;
//    if (![ZQ_CommonTool isEmpty:replayModel.replyName]) {
//        if ([replayModel.replyid isEqualToString:UserDefaultsGet(UserId)]) {
//            return;
//        }
//        string = replayModel.replyName;
//
//    } else {
//        if ([replayModel.evaluationId isEqualToString:UserDefaultsGet(UserId)]) {
//            return;
//        }
//        string = replayModel.evaluationName;
//    }
//    [self.view addSubview:self.backView];
//    [self.view addSubview:self.upView];
//    [self.backView addSubview:self.textView];
//    [self.textView becomeFirstResponder];
//    [self.backView addSubview:self.putBtn];
//    self.textView.placeHolder = [NSString stringWithFormat:@"回复%@",string];
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark- 创建输入框
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
        _backView.backgroundColor = kUIColorFromRGB(0xF7F7F7);
        _backView.layer.borderColor =kUIColorFromRGB(0xDCDCDC).CGColor;
        _backView.layer.borderWidth = 1.0f;
    }
    return _backView;
}

- (UIView *)upView{
    if (!_upView) {
        _upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ZQ_Device_Height)];
        _upView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_upView addGestureRecognizer:tap];
    }
    return _upView;
}

- (ZHShareTextView *)textView{
    if (!_textView) {
        _textView = [[ZHShareTextView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth - 70, 30)];
        [_textView becomeFirstResponder];
        _textView.delegate = self;
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.cornerRadius = 3;
        _textView.delegate = self;
        _textView.placeHolder = @"评论";
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderColor = kUIColorFromRGB(0xe4e4e4).CGColor;
        _textView.font = [UIFont systemFontOfSize:14];
    }
    return _textView;
}

- (UIButton *)putBtn{
    if (!_putBtn) {
        _putBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_putBtn setFrame:CGRectMake(ZQ_Device_Width - 50, 5, 38, 30)];
        [_putBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_putBtn setTitleColor:kUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _putBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_putBtn addTarget:self action:@selector(putBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _putBtn;
}

- (void)hideView{
    [self.textView resignFirstResponder];
    [self.backView removeAllSubviews];
    [self.upView removeFromSuperview];
    self.upView = nil;
    self.textView = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *string = [textView.text stringByAppendingString:text];
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        [self putBtnClick];
        return NO;
    }
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth - 70, MAXFLOAT)];
    if (size.height >= 32) {
        CGRect rect = CGRectMake(10, 5, ScreenWidth - 70, size.height);
        _textView.frame = rect;
        CGRect rect1 = self.backView.frame;
        CGFloat fo = size.height + 22 - rect1.size.height;
        self.backView.frame = CGRectMake(rect1.origin.x, rect1.origin.y - fo, ZQ_Device_Width, size.height + 22);
    }
    self.upView.frame = CGRectMake(0, 0, ZQ_Device_Width, CGRectGetMinY(self.backView.frame));
    return YES;
}

#pragma mark -- 监听键盘的高度
- (void)willShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    CGRect keyboardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
    
    CGFloat keyboardHeight = [self.view convertRect:keyboardRect fromView:nil].size.height;
    
    CommentsModel *model = _dataArray[_selectIndexPath.section];
    ReplyModel *replayModel;
    
    CGFloat replyCellHeight = 0.01;
    CGFloat maxReplyCellHeight = 0.01;
    CGFloat getMaxY;
    
    if ([_isReplay isEqualToString:@"2"]) {// 点击回复
        if (![ZQ_CommonTool isEmptyArray:model.praiseArray]){//赞的
            // 点击上面的高度
            replayModel = model.replyArray[_selectIndexPath.row - 3];
            
            for (NSInteger i = 0; i < _selectIndexPath.row - 2; i ++) {
                ReplyModel *replayModel = model.replyArray[i];
                replyCellHeight = replyCellHeight +replayModel.replyCellH;
            }
            // 点击下面的高度
            for (NSInteger i = _selectIndexPath.row - 2; i < model.replyArray.count; i ++) {
                ReplyModel *replayModel = model.replyArray[i];
                maxReplyCellHeight = maxReplyCellHeight +replayModel.replyCellH;
            }
            
        } else {
            replayModel = model.replyArray[_selectIndexPath.row - 2];
            // 点击上面的高度
            for (NSInteger i = 0; i < _selectIndexPath.row - 1; i ++) {
                ReplyModel *replayModel = model.replyArray[i];
                replyCellHeight = replyCellHeight +replayModel.replyCellH;
            }
            // 点击下面的高度
            for (NSInteger i = _selectIndexPath.row - 1; i < model.replyArray.count; i ++) {
                ReplyModel *replayModel = model.replyArray[i];
                maxReplyCellHeight = maxReplyCellHeight +replayModel.replyCellH;
            }
        }
        
        self.backView.frame = CGRectMake(0, _keyboardY - 40, ScreenWidth, 40);
        self.upView.frame = CGRectMake(0, 0, ZQ_Device_Width, CGRectGetMinY(self.backView.frame));
        
        
        CGRect rect = [self.hfView.superview convertRect:CGRectMake(self.hfView.x, self.hfView.y, self.hfView.width, self.hfView.height) toView:self.view];
        
        CGFloat maxY = 0.01;
        // 距离屏幕的距离应该是 ZQ_Device_Height - rect.origin.y 是这个数
        // 键盘弹起来的距离应该是 keyboardHeight  + 40 +  rect.size.height + 11;
        
        maxY = (keyboardHeight  + 40 +  rect.size.height)  - (ZQ_Device_Height - rect.origin.y - 64);
        
        // 获取现在的偏移量
        CGFloat offSectY = self.workTableView.contentOffset.y;
        
        if (offSectY + maxY > 0) {
            self.workTableView.contentOffset = CGPointMake(0, offSectY + maxY);
        }
        
    } else if ([_isReplay isEqualToString:@"1"]) {
        if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
            for ( ReplyModel *replay in model.replyArray) {
                getMaxY = getMaxY + replay.replyCellH;
            }
        }
        // 先获取 按钮相对于偏移量的高度
        CGRect rect = [self.morrBtn.superview convertRect:CGRectMake(self.morrBtn.x, self.morrBtn.y, self.morrBtn.width, self.morrBtn.height) toView:self.view];
        
        CGFloat maxY = 0.01;
        
        maxY = rect.origin.y - (_keyboardY - model.priseCellH - getMaxY - 40 -  rect.size.height - 16);
        // 获取现在的偏移量
        CGFloat offSectY = self.workTableView.contentOffset.y;
        
        if (offSectY + maxY > 0) {
            self.workTableView.contentOffset = CGPointMake(0, offSectY + maxY);
        }
        self.backView.frame = CGRectMake(0, _keyboardY - 40, ScreenWidth, 40);
        self.upView.frame = CGRectMake(0, 0, ZQ_Device_Width, CGRectGetMinY(self.backView.frame));
    }
    [UIView commitAnimations];
}
- (void)hideShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.backView.frame = CGRectMake(0, ScreenHeight  - 64, ScreenWidth, 40);
    [UIView commitAnimations];
}

#pragma mark -- 发送评论
- (void)putBtnClick{
    // 发送的评论 以及回复评论
    CommentsModel *model = _dataArray[_selectIndexPath.section];
    if ([_isReplay isEqualToString:@"1"]) {// 提交评论
        if ([ZQ_CommonTool isEmpty:_textView.text]) {
            [self showHint:@"请输入您要发送的评论"];
        } else {
            NSString *string =  [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            __weak PersonalCircleViewController *weakSelf = self;
            NSString *url = [kHost stringByAppendingString:@"api.php?m=add.dynamicComment"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
            parameters[@"memberid"] = infoModel.userID;
            parameters[@"did"] = model.dynamicID;
            parameters[@"content"] = string;
            parameters[@"uid2"] = model.evaluationId;
            [HFRequest requestWithUrl:url parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [weakSelf hideHud];
                if ([responseObject[@"errno"] isEqualToString:@"0"]) {
                    NSDictionary *dic = responseObject[@"rst"];
                    ReplyModel *replymodel = [[ReplyModel alloc] init];
                    replymodel.evaluationName = infoModel.nickname;
                    replymodel.evaluationId = infoModel.userID;//评论人的ID
                    replymodel.evaluationUModelid = infoModel.identity;
                    replymodel.replyContent = string;//评论人的内容
                    replymodel.cid = dic[@"commentId"];//评论id
                    replymodel.dynamicid = model.dynamicID;
                    replymodel.isdelte = @"1";//可以删除
                    [model.replyArray addObject:replymodel];
                    [weakSelf.workTableView reloadData];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                [weakSelf hideHud];
            }];
        }
    } else if ([_isReplay isEqualToString:@"2"]){// 回复评论
        ReplyModel *replayModel;
        if (![ZQ_CommonTool isEmptyArray:model.praiseArray]) {
            if (_selectIndexPath.row == 1) {
            } else {
                if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
                    replayModel = model.replyArray[_selectIndexPath.row - 3];
                }
            }
        } else {
            if (![ZQ_CommonTool isEmptyArray:model.replyArray]) {
                replayModel = model.replyArray[_selectIndexPath.row - 2];
            }
        }
        [self.view endEditing:true];
        __weak PersonalCircleViewController *weakSelf = self;
        
        ReplyModel *model1 = [[ReplyModel alloc] init];
        NSString *string =  [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        model1.replyContent = string;//评论人的内容
        [model.replyArray addObject:model1];
        [self.workTableView reloadData];
        
        NSString *url = [kHost stringByAppendingString:@"api.php?m=work_actor.publishShowComment"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"uid"] = UserDefaultsGet(UserId);
        //        if ([ZQ_CommonTool isEmpty:model.dynamicID]) {
        //            parameters[@"tid"] = UserDefaultsGet(ModelCid);
        //        } else {
        //            parameters[@"tid"] = model.dynamicID;
        //        }
        
        parameters[@"contents"] =  model1.replyContent;
        if ([replayModel.replyid isEqualToString:@"0"]) {
            parameters[@"aitmemberid"] = replayModel.evaluationId;
        } else {
            parameters[@"aitmemberid"] = replayModel.replyid;
        }
        [HFRequest requestWithUrl:url parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [weakSelf hideHud];
            if ([responseObject[@"errno"] isEqualToString:@"0"]) {
                
                [_workTableView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            [weakSelf hideHud];
            [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        }];
    }
    [self hideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
