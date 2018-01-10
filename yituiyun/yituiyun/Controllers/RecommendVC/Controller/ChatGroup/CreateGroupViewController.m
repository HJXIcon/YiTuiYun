/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "CreateGroupViewController.h"

#import "ContactSelectionViewController.h"
#import "EMTextView.h"

@interface CreateGroupViewController ()<UITextFieldDelegate, UITextViewDelegate, EMChooseViewDelegate>

@property (strong, nonatomic) UIView *switchView;
@property (strong, nonatomic) UIBarButtonItem *rightItem;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) EMTextView *textView;

@property (nonatomic) BOOL isPublic;
@property (strong, nonatomic) UILabel *groupTypeLabel;//群组类型

@property (nonatomic) BOOL isMemberOn;
@property (strong, nonatomic) UILabel *groupMemberTitleLabel;
@property (strong, nonatomic) UISwitch *groupMemberSwitch;
@property (strong, nonatomic) UILabel *groupMemberLabel;

@end

@implementation CreateGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isPublic = NO;
        _isMemberOn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.view.backgroundColor = kUIColorFromRGB(0xf1f1f1);

    self.title = @"创建群聊";
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(addContacts:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    [self setUpView];
}

- (void)leftBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - getter
- (void)setUpView
{
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    CGSize titleSize = [@"群组名称" sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(ZQ_Device_Width - 24, MAXFLOAT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, ZQ_Device_Width - 24, titleSize.height + 10)];
    label.text = @"群组名称";
    label.textColor = kUIColorFromRGB(0x808080);
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(label.frame), ZQ_Device_Width, 70)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.textField = [[UITextField alloc] initWithFrame:ZQ_RECT_CREATE(12, 0, ZQ_Device_Width - 24, 70)];
//    [_textField becomeFirstResponder];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.delegate = self;
    _textField.textColor = kUIColorFromRGB(0x404040);
    [view addSubview:_textField];
}

//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    [_textField resignFirstResponder];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    NSInteger maxUsersCount = 2000;
    if ([selectedSources count] > (maxUsersCount - 1)) {
        [ZQ_UIAlertView showMessage:@"超过群组人数上限" cancelTitle:@"确定"];
        return NO;
    }
    
    [self showHudInView:self.view hint:@"创建中..."];
    
    NSMutableArray *source = [NSMutableArray array];
    for (NSString *username in selectedSources) {
        [source addObject:username];
    }
    
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = maxUsersCount;
    setting.style = EMGroupStylePublicJoinNeedApproval;
    
    __weak CreateGroupViewController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSString *messageStr = [NSString stringWithFormat:@"%@ 邀请你加入群聊", model.nickname];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:self.textField.text description:self.textView.text invitees:source message:messageStr setting:setting error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (group && !error) {
                [weakSelf showHint:@"创建成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else{
                [weakSelf showHint:@"创建失败"];
            }
        });
    });
    return YES;
}


- (void)addContacts:(id)sender
{
    if (self.textField.text.length == 0) {
        [ZQ_UIAlertView showMessage:@"请输入群组名" cancelTitle:@"确定"];
        return;
    }
    
    [self.view endEditing:YES];
    
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

@end
