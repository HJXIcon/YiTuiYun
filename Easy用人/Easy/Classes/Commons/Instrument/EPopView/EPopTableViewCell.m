//
//  EPopTableViewCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/22.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPopTableViewCell.h"
#import "EPopAction.h"

@interface EPopTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation EPopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = self.backgroundColor;
    
    // initialize
    [self initialize];
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = EHighlightedColor;
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundColor = [UIColor clearColor];
        }];
    }
}


// 初始化
- (void)initialize {

    self.titleLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHexString:@"#3c3c3c"] text:@"" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
    }];
    
}

- (void)setAction:(EPopAction *)action{
    _action = action;
    self.titleLabel.text = action.title;
}
@end
