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

#import "BlackListViewController.h"
#import "BaseTableViewCell.h"

@interface BlackListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataSource;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation BlackListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
        _sectionTitles = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"黑名单";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.sectionIndexColor = kUIColorFromRGB(0x808080);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [_tableView setHeadRefreshWithTarget:self withAction:@selector(loadNewStatus)];
    
    [self reloadDataSource];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
}

- (void)leftBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadNewStatus
{
    [self reloadDataSource];
    [_tableView endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataSource objectAtIndex:section] count];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *userSection = [self.dataSource objectAtIndex:indexPath.section];
    EaseUserModel *model = [userSection objectAtIndex:indexPath.row];
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:model.buddy];
    if (dic) {
        model.nickname = nil ? model.buddy : dic[@"nickname"];
        model.avatarURLPath = dic[@"avatar"];
        model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    }
    cell.avatarView.imageCornerRadius = 15;
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.model = model;
    cell.tableViewTag = 10;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseUserModel *model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [[EMClient sharedClient].contactManager removeUserFromBlackList:model.buddy completion:^(NSString *aUsername, EMError *aError) {
            if (!aError)
            {
                [self reloadDataSource];
                if (_delegate && [_delegate respondsToSelector:@selector(reloadData)]) {
                    [_delegate reloadData];
                }
                [ZQ_CallMethod setupNewMessageBoxCount];

            } else {
                [self showHint:aError.errorDescription];
            }
        }];
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:section]];
    [contentView addSubview:label];
    return contentView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - data

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //按首字母分组
    for (NSString *buddy in dataArray) {
        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
        if (model) {
            NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:buddy];
            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            model.nickname = dic[@"nickname"];
            
            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.nickname];
            NSString *string = [firstLetter substringToIndex:1];
            NSInteger section = [indexCollation sectionForObject:string collationStringSelector:@selector(uppercaseString)];
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:model];
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

- (void)reloadDataSource
{
    [self showHudInView:self.view hint:@"加载中..."];
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *blocked = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
        if (!error) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[weakself sortDataArray:blocked]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                [weakself.tableView reloadData];
            });
        }
    });
}

@end
