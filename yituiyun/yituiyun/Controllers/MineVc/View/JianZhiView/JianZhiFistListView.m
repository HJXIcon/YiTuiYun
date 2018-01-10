//
//  JianZhiFistListView.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/1.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JianZhiFistListView.h"

@interface JianZhiFistListView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSArray * datas;
@end

@implementation JianZhiFistListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithRect:(CGRect)rect andDatas:(NSArray *)array{
    if (self = [super init]) {
        
            self.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.2];
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.datas = array;
        
        CGFloat x =rect.origin.x ;
        CGFloat y = CGRectGetMaxY(rect);
        CGFloat w = rect.size.width;
        CGFloat h = HRadio(30)*array.count;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
    
        self.tableView.tableFooterView= [UIView new];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
    }
    return self;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HRadio(30);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.datas[indexPath.row];
    
    if (ScreenWidth<375) {
        cell.textLabel.font = [UIFont systemFontOfSize:10];
    }else{
         cell.textLabel.font = [UIFont systemFontOfSize:11];
    }
   
    return cell;
}
+(instancetype)listView{
    return ViewFromXib;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    [self removeFromSuperview];
    if (self.listreturnblock) {
        self.listreturnblock(self.datas[indexPath.row],indexPath.row);
    }
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self removeFromSuperview];
//}

@end
