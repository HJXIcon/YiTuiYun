//
//  FXPersonDetailController.m
//  yituiyun
//
//  Created by fx on 16/11/15.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXPersonDetailController.h"
#import "FXUserInfoModel.h"
#import "ChatViewController.h"
//#import "FXPersonInfoController.h"
#import "JXPersonInfoViewController.h"
#import "ApplyViewController.h"
#import "InvitationManager.h"
#import "LatestDynamicCell.h"
#import "PersonalCircleViewController.h"
#import "InformationDetailsCell.h"
@interface FXPersonDetailController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *iconBGView;

@property (nonatomic, strong) UIButton *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, copy) NSString *isLimit;//查看权限

@property (nonatomic, strong) FXUserInfoModel *detailModel;
@property (nonatomic, strong) LatestDynamicCell *cell;

@property (nonatomic, copy) NSString *personId;
@end

@implementation FXPersonDetailController
- (instancetype)initPersonId:(NSString *)personId{
    self = [super init];
    if (self) {
        self.personId = personId;
    }
    return self;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
//        _titleArray = [NSMutableArray arrayWithObjects:@"电话",@"通讯地址",@"行业",@"工作年限",@"求职类型",@"兴趣爱好",@"身高",@"个人简介", nil];
        _titleArray = [NSMutableArray arrayWithObjects:@"电话",@"通讯地址",@"行业",@"工作年限",@"个人简介", nil];

    }
    return _titleArray;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    self.detailModel = [[FXUserInfoModel alloc]init];
    self.title = @"资料详情";//bd的详情
    [self getPersonDetail];
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView{
    if (!_tableView) {
        UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
        if ([userModel.identity integerValue] == 5) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        } else {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStyleGrouped];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setShowsVerticalScrollIndicator:NO];
    }
    return _tableView;
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
        _headView.backgroundColor = kUIColorFromRGB(0xededed);
        
        // 背景 view
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        bgView.tag = 1;
        bgView.userInteractionEnabled = YES;
        bgView.backgroundColor = MainColor;
        [_headView addSubview:bgView];
        
        self.iconView = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconView.frame = CGRectMake((ScreenWidth - 70) / 2, 20, 70, 70);
        _iconView.layer.cornerRadius = self.iconView.frame.size.height / 2;
        [_iconView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, _detailModel.personIcon]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"morenIcon"]];
        _iconView.clipsToBounds = YES;
        _iconView.tag = 99998;
        _iconView.backgroundColor = kUIColorFromRGB(0xffffff);
        [_iconView addTarget:self action:@selector(iconViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_iconView];
        
        CGSize nameSize = [_detailModel.nickName sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(CGFLOAT_MAX, 20)];
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - nameSize.width) / 2, CGRectGetMaxY(_iconView.frame) + 20, nameSize.width, 20)];
        self.nameLabel.text = _detailModel.nickName;
        self.nameLabel.textColor = kUIColorFromRGB(0xffffff);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:self.nameLabel];
        
        UIImageView *sexView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - nameSize.width) / 2 - 24, CGRectGetMaxY(_iconView.frame) + 23, 14, 14)];
        if ([_detailModel.sex isEqualToString:@"1"]) {//1男 2女
            sexView.image = [UIImage imageNamed:@"man.png"];
        }else if ([_detailModel.sex isEqualToString:@"2"]){
            sexView.image = [UIImage imageNamed:@"woman.png"];
        }else{
            
        }
        [bgView addSubview:sexView];
        
    }
    return _headView;
}

- (void)iconViewClick:(UIButton *)button{
    
    if (button.tag == 99998) {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:[self setIconBGView]];
    } else if (button.tag == 99999) {
        if (_iconBGView) {
            [_iconBGView removeFromSuperview];
        }
    }
}

- (UIButton *)setIconBGView
{
    self.iconBGView = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconBGView.frame = CGRectMake(0, 0, ZQ_Device_Width, ZQ_Device_Height);
    _iconBGView.backgroundColor = [UIColor blackColor];
    _iconBGView.tag = 99999;
    [_iconBGView addTarget:self action:@selector(iconViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (ZQ_Device_Height - ZQ_Device_Width)/2, ZQ_Device_Width, ZQ_Device_Width)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, _detailModel.personIcon]] placeholderImage:[UIImage imageNamed:@"morenIcon"]];
    iconView.backgroundColor = kUIColorFromRGB(0xffffff);
    [_iconBGView addSubview:iconView];
    
    return _iconBGView;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        _footView.backgroundColor = kUIColorFromRGB(0xffffff);
        
        UIButton *addBuddyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBuddyBtn.frame = CGRectMake(12, 5, _footView.frame.size.width/2 - 24, 40);
        addBuddyBtn.layer.cornerRadius = 5;
        addBuddyBtn.backgroundColor = MainColor;
        [addBuddyBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
            if (!aError) {
                    BOOL ret = YES;
                    for (NSString *str in aList) {
                        if ([str isEqualToString:self.personId]) {
                            ret = NO;
                            break;
                        }
                    }
                if (ret == YES) {
                    [addBuddyBtn setTitle:@"加好友" forState:UIControlStateNormal];
                } else {
                    [addBuddyBtn setTitle:@"已是好友" forState:UIControlStateNormal];
                    addBuddyBtn.backgroundColor = kUIColorFromRGB(0xcccccc);
                    addBuddyBtn.userInteractionEnabled = NO;
                }
            } else {
                [addBuddyBtn setTitle:@"加好友" forState:UIControlStateNormal];
            }
        }];
        addBuddyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [addBuddyBtn addTarget:self action:@selector(addBuddyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:addBuddyBtn];
        
        UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        connectBtn.frame = CGRectMake(CGRectGetMaxX(addBuddyBtn.frame) + 24, 5, _footView.frame.size.width/2 - 24, 40);
        connectBtn.layer.cornerRadius = 5;
        connectBtn.backgroundColor = MainColor;
        [connectBtn setTitle:@"联系他" forState:UIControlStateNormal];
        connectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [connectBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [connectBtn addTarget:self action:@selector(connectClick) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:connectBtn];
    }
    return _footView;
}

//加好友
- (void)addBuddyBtnClick
{
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    if ([userModel.userID integerValue] == [self.personId integerValue]) {
        [ZQ_UIAlertView showMessage:@"不能加自己为好友" cancelTitle:@"知道了"];
        return;
    }

    //判断是否已发来申请
    NSArray *applyArray = [[ApplyViewController shareController] dataSource];
    if (applyArray && [applyArray count] > 0) {
        for (ApplyEntity *entity in applyArray) {
            ApplyStyle style = [entity.style intValue];
            BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
            if (!isGroup && [entity.applicantUsername isEqualToString:self.personId]) {
                NSString *str = [NSString stringWithFormat:@"'%@'正在申请加您为好友", _detailModel.nickName];
                [ZQ_UIAlertView showMessage:str cancelTitle:@"确定"];
                return;
            }
        }
    }
    
    if ([self didBuddyExist:self.personId]) {
        NSString *message = [NSString stringWithFormat:@"'%@'已经是您的好友", _detailModel.nickName];
        [ZQ_UIAlertView showMessage:message cancelTitle:@"确定"];
    } else if([self hasSendBuddyRequest:self.personId]) {
        NSString *message = [NSString stringWithFormat:@"您已经向 '%@' 发送了好友申请!", _detailModel.nickName];
        [ZQ_UIAlertView showMessage:message cancelTitle:@"确定"];

    } else {
        [self showMessageAlertView];
    }
}

- (BOOL)hasSendBuddyRequest:(NSString *)buddyName
{
    NSArray *userlist = [[EMClient sharedClient].contactManager getContacts];
    for (NSString *username in userlist) {
        if ([username isEqualToString:buddyName]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)didBuddyExist:(NSString *)buddyName
{
    NSArray *userlist = [[EMClient sharedClient].contactManager getContacts];
    for (NSString *username in userlist) {
        if ([username isEqualToString:buddyName]){
            return YES;
        }
    }
    return NO;
}

- (void)showMessageAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"打声招呼"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        if (messageTextField.text.length > 0) {
            messageStr = messageTextField.text;
        } else {
            messageStr = @"想添加您为好友";
        }
        [self sendFriendApplyAtMessage:messageStr];
    }
}

- (void)sendFriendApplyAtMessage:(NSString *)message
{
    if (![ZQ_CommonTool isEmpty:self.personId]) {
        [self showHudInView:self.view hint:@"发送中..."];
        EMError *error = [[EMClient sharedClient].contactManager addContact:self.personId message:message];
        [self hideHud];
        if (error) {
            [self showHint:@"发送失败,请重新发送"];
        }
        else{
            [self showHint:@"发送成功"];
        }
    }
}

//联系他
- (void)connectClick{
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    if ([userModel.userID integerValue] == [self.personId integerValue]) {
        [ZQ_UIAlertView showMessage:@"不能跟自己聊天" cancelTitle:@"知道了"];
        return;
    }
    
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=user.infoStatus"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = userModel.userID;
    dic[@"uModelid"] = userModel.identity;
    [weakSelf showHudInView:weakSelf.view hint:@"加载中"];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *dic = responseObject[@"rst"];
            if ([dic[@"isperfected"] intValue] == 0) {
                [WCAlertView showAlertWithTitle:@"提示"
                                        message:@"您的信息不完善，完善信息后即可进行聊天"
                             customizationBlock:^(WCAlertView *alertView) {
                                 
                             } completionBlock:
                 ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 0) {
//                         FXPersonInfoController *personVc = [[FXPersonInfoController alloc]init];
                         JXPersonInfoViewController *personVc = [[JXPersonInfoViewController alloc]init];
                         personVc.hidesBottomBarWhenPushed = YES;
                         [self.navigationController pushViewController:personVc animated:YES];
                     }
                 } cancelButtonTitle:@"去完善" otherButtonTitles:nil, nil];
            } else {
                RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:self.personId conversationType:EMConversationTypeChat];
                
//                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.personId conversationType:EMConversationTypeChat];
                chatController.title = _detailModel.nickName;
                chatController.avatarURLPath = _detailModel.personIcon;
                [self.navigationController pushViewController:chatController animated:YES];
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![ZQ_CommonTool isEmptyDictionary:_detailModel.dynamicDic]) {
       return self.titleArray.count + 1;
    }
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 5) {
        return _cell.height;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InformationDetailsCell *cell = [InformationDetailsCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.nameLabel.text = self.titleArray[indexPath.section];
        cell.detailLabel.text = _detailModel.telPhone;
    }else if (indexPath.section == 1) {
        cell.nameLabel.text = self.titleArray[indexPath.section];
        cell.detailLabel.text = _detailModel.address;
    }else if (indexPath.section == 2) {
        cell.nameLabel.text = self.titleArray[indexPath.section];
        cell.detailLabel.text = _detailModel.industryStr;
    }else if (indexPath.section == 3) {
        cell.nameLabel.text = self.titleArray[indexPath.section];
        if ([_detailModel.workYears isEqualToString:@"请选择"]) {
            cell.detailLabel.text = @"";
        }else{
            cell.detailLabel.text = _detailModel.workYears;
        }
//    }else if (indexPath.section == 4) {
//        cell.textLabel.text = self.titleArray[indexPath.section];
//        if ([_detailModel.jobType isEqualToString:@"请选择"]) {
//            cell.detailTextLabel.text = @"";
//        }else{
//            cell.detailTextLabel.text = _detailModel.jobType;
//        }
//    }else if (indexPath.section == 5) {
//        cell.textLabel.text = self.titleArray[indexPath.section];
//        cell.detailTextLabel.text = _detailModel.hobby;
//    }else if (indexPath.section == 6) {
//        if ([_detailModel.height isEqualToString:@"0"]) {
//            cell.detailTextLabel.text = @"";
//        }else{
//            cell.detailTextLabel.text = [_detailModel.height stringByAppendingString:@"cm"];
//        }
    }else if (indexPath.section == 4) {
        cell.nameLabel.text = self.titleArray[indexPath.section];
        cell.detailLabel.text = _detailModel.introduce;
    }else if (indexPath.section == 5) {
        LatestDynamicCell *cell = [LatestDynamicCell cellWithTableView:tableView];
        _cell = cell;
        [cell.dynamicDic removeAllObjects];
        [cell.dynamicDic addEntriesFromDictionary:_detailModel.dynamicDic];
        [cell makeView];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 5) {
        PersonalCircleViewController *vc = [[PersonalCircleViewController alloc] initWithWhere:1];
        vc.buddyListString = self.personId;
        pushToControllerWithAnimated(vc)
    }
}

- (void)getPersonDetail{
    
    __weak FXPersonDetailController *weakSelf = self;
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    params[@"uModelid"] = @"6";
    params[@"uid"] = self.personId;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.basicInfo"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            _detailModel.personIcon = tempDic[@"avatar"];
            _detailModel.nickName = tempDic[@"nickname"];
            _detailModel.sex = tempDic[@"sex"];
            _detailModel.telPhone = tempDic[@"mobile"];
            _detailModel.address = tempDic[@"address"];
            _detailModel.industry = tempDic[@"industry"];
            _detailModel.industryStr = tempDic[@"industry_str"];
            _detailModel.workYears = tempDic[@"workYears_str"];
            _detailModel.jobType = tempDic[@"jobType_str"];
            _detailModel.hobby = tempDic[@"hobbies"];
            _detailModel.height = tempDic[@"height"];
            _detailModel.introduce = tempDic[@"intro"];
            if (![ZQ_CommonTool isEmptyDictionary:tempDic[@"dynamic"]]) {
                _detailModel.dynamicDic = [NSDictionary dictionaryWithDictionary:tempDic[@"dynamic"]];
            }
        }
        [self.view addSubview:self.tableView];
        self.tableView.tableHeaderView = self.headView;
        if ([userModel.identity integerValue] == 5) {
            if (![userModel.isSeeTel isEqualToString:@"1"]) {
                _detailModel.telPhone = @"暂无权限查看";
            }
            if ([self.where isEqualToString:@"搜索加好友"]) {
                [self.view addSubview:self.footView];
            }
        } else {
            [self.view addSubview:self.footView];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        
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
