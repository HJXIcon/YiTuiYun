//
//  NodeStatusDetailVC.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/27.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "NodeStatusDetailVC.h"
#import "NodeStatusDetailCell.h"

@interface NodeStatusDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) UIView * headView;
@property(nonatomic,strong) UIView * footView;

@end

@implementation NodeStatusDetailVC

-(UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WRadio(325), 44)];
        UILabel *label = [[UILabel alloc]initWithFrame:_headView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"进度列表";
        [_headView addSubview:label];
    }
    return _headView;
}


-(UIView *)footView{
    if (_footView == nil) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WRadio(325), 44)];
        UIButton *btn = [[UIButton alloc]initWithFrame:_footView.bounds];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backupTo) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WRadio(325), 1)];
        lineView.backgroundColor = UIColorFromRGBString(@"0xe1e1e1");
        [_footView addSubview:lineView];
        [_footView addSubview:btn];
    }
    return _footView;
}

-(void)backupTo{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
             self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, WRadio(325),80*self.datas.count+88) style:UITableViewStylePlain];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
   
    self.tableView.center = CGPointMake(ScreenWidth *0.5, ScreenHeight *0.5);
    self.tableView.layer.cornerRadius = 5;
    self.tableView.clipsToBounds = YES;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NodeStatusDetailCell" bundle:nil] forCellReuseIdentifier:@"NodeStatusDetailCell"];
    
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = self.footView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NodeStatusDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NodeStatusDetailCell"];
    
        SubTaskModel *model = self.datas[indexPath.row];
    
    cell.oneLabel.text = model.title;
    cell.oneLabel.textColor = UIColorFromRGBString(@"0x808181");
    cell.twoLabel.text = [NSString timeHasSecondTimeIntervalString:model.add_time];
    cell.twoLabel.textColor = UIColorFromRGBString(@"0x808181");
    cell.threeLabel.text = model.remark;
    if (indexPath.row == self.datas.count-1) {
        cell.threeLabel.textColor = UIColorFromRGBString(@"0xff9f4a");
        cell.lineView.hidden = YES;
    }else{
      cell.threeLabel.textColor = UIColorFromRGBString(@"0x808181");
        cell.lineView.hidden = NO;
    }
    
    
    return cell;
}



@end
