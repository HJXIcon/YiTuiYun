//
//  EBaseTableViewCell.m
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"

@implementation EBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
    
}

- (void)setup{
    
    if ([self respondsToSelector:@selector(separatorInset)]) {
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        
        self.layoutMargins = UIEdgeInsetsZero;
    }
    
}


+ (instancetype)cellForTableView:(UITableView *)tableView{
    Class cellClass = NSClassFromString(NSStringFromClass(self));
    id cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(self)];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
