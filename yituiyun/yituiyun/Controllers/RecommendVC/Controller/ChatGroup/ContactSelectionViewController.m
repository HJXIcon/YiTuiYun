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

#import "ContactSelectionViewController.h"

#import "EMRemarkImageView.h"
#import "BaseTableViewCell.h"
#import "RealtimeSearchUtil.h"

@interface ContactSelectionViewController ()

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *selectedContacts;
@property (strong, nonatomic) NSMutableArray *blockSelectedUsernames;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIScrollView *footerScrollView;
@property (strong, nonatomic) UIButton *doneButton;

@property (nonatomic) BOOL presetDataSource;

@end

@implementation ContactSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _contactsSource = [NSMutableArray array];
        _selectedContacts = [NSMutableArray array];
        
        [self setObjectComparisonStringBlock:^NSString *(NSString *object) {
            NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:object];
            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:dic[@"nickname"]];
            NSString *string = [firstLetter substringToIndex:1];
            return string;
        }];
        
        [self setComparisonObjectSelector:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSDictionary *dic1 = [ZQ_AppCache takeOutFriendInfo:obj1];
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:dic1[@"nickname"]];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSDictionary *dic2 = [ZQ_AppCache takeOutFriendInfo:obj2];
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:dic2[@"nickname"]];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
    }
    return self;
}

- (instancetype)initWithBlockSelectedUsernames:(NSArray *)blockUsernames
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _blockSelectedUsernames = [NSMutableArray array];
        [_blockSelectedUsernames addObjectsFromArray:blockUsernames];
    }
    
    return self;
}

- (instancetype)initWithContacts:(NSArray *)contacts
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _presetDataSource = YES;
        [_contactsSource addObjectsFromArray:contacts];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择联系人";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.view addSubview:self.footerView];
    
    self.tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    self.tableView.sectionIndexColor = kUIColorFromRGB(0x808080);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.footerView.frame.size.height)];
    self.tableView.editing = YES;
    
    if ([_blockSelectedUsernames count] > 0) {
        for (NSString *username in _blockSelectedUsernames) {
            NSInteger section = [self sectionForString:username];
            NSMutableArray *tmpArray = [_dataSource objectAtIndex:section];
            if (tmpArray && [tmpArray count] > 0) {
                for (int i = 0; i < [tmpArray count]; i++) {
                    NSString *buddy = [tmpArray objectAtIndex:i];
                    if ([buddy isEqualToString:username]) {
                        [self.selectedContacts addObject:buddy];
                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        
                        break;
                    }
                }
            }
        }
        
        if ([_selectedContacts count] > 0) {
            [self reloadFooterView];
        }
    }
}

- (void)leftBarButtonItem
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewControllerDidSelectBack:)]) {
        [_delegate viewControllerDidSelectBack:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - getter

- (UIView *)footerView
{
    if (self.mulChoice && _footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _footerView.backgroundColor = [UIColor whiteColor];
        
//        _footerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 30 - 70, _footerView.frame.size.height - 5)];
//        _footerScrollView.backgroundColor = [UIColor clearColor];
//        [_footerView addSubview:_footerScrollView];
        
        _doneButton =  [UIButton buttonWithType:UIButtonTypeSystem];
        _doneButton.frame = ZQ_RECT_CREATE(12, 8, ZQ_Device_Width - 24, 34);
        _doneButton.accessibilityIdentifier = @"done_button";
        [_doneButton setBackgroundColor:MainColor];
        _doneButton.layer.cornerRadius = 4;
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_doneButton];
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactListCell";
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *username = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:username];
    EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:username];
    if (dic && model) {
        model.nickname = nil ? model.buddy : dic[@"nickname"];
        model.avatarURLPath = dic[@"avatar"];
        model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    }
    cell.avatarView.imageCornerRadius = 15;
    cell.model = model;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_blockSelectedUsernames count] > 0) {
        NSString *username = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return ![self isBlockUsername:username];
    }
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.mulChoice) {
        if (![self.selectedContacts containsObject:object])
        {
            [self.selectedContacts addObject:object];
            [self reloadFooterView];
        }
    } else {
        [self.selectedContacts addObject:object];
        [self doneAction:nil];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *username = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([self.selectedContacts containsObject:username]) {
        [self.selectedContacts removeObject:username];
        
        [self reloadFooterView];
    }
}

#pragma mark - private

- (BOOL)isBlockUsername:(NSString *)username
{
    if (username && [username length] > 0) {
        if ([_blockSelectedUsernames count] > 0) {
            for (NSString *tmpName in _blockSelectedUsernames) {
                if ([username isEqualToString:tmpName]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (void)reloadFooterView
{
    if (self.mulChoice) {
//        [self.footerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        
//        CGFloat imageSize = self.footerScrollView.frame.size.height;
//        NSInteger count = [self.selectedContacts count];
//        self.footerScrollView.contentSize = CGSizeMake(imageSize * count, imageSize);
//        for (int i = 0; i < count; i++) {
//            NSString *username = [self.selectedContacts objectAtIndex:i];
//            EMRemarkImageView *remarkView = [[EMRemarkImageView alloc] initWithFrame:CGRectMake(i * imageSize, 0, imageSize, imageSize)];
//            remarkView.image = [UIImage imageNamed:@"chatListCellHead.png"];
//            remarkView.remark = username;
//            [self.footerScrollView addSubview:remarkView];
//        }
        
        if ([self.selectedContacts count] == 0) {
            [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
        }
        else{
            [_doneButton setTitle:[NSString stringWithFormat:@"确定(%i)人", [self.selectedContacts count]] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - public

- (void)loadDataSource
{
    if (!_presetDataSource) {
        [self showHudInView:self.view hint:@"加载中..."];
        [_dataSource removeAllObjects];
        [_contactsSource removeAllObjects];
        
        NSArray *buddyList = [[EMClient sharedClient].contactManager getContacts];
        for (NSString *username in buddyList) {
            [self.contactsSource addObject:username];
        }
        
        [_dataSource addObjectsFromArray:[self sortRecords:self.contactsSource]];
        
        [self hideHud];
    } else {
        _dataSource = [[self sortRecords:self.contactsSource] mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)doneAction:(id)sender
{
    BOOL isPop = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didFinishSelectedSources:)]) {
        if ([_blockSelectedUsernames count] == 0) {
            isPop = [_delegate viewController:self didFinishSelectedSources:self.selectedContacts];
        }
        else{
            NSMutableArray *resultArray = [NSMutableArray array];
            for (NSString *username in self.selectedContacts) {
                if(![self isBlockUsername:username])
                {
                    [resultArray addObject:username];
                }
            }
            isPop = [_delegate viewController:self didFinishSelectedSources:resultArray];
        }
    }
    
    if (isPop) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}


@end
