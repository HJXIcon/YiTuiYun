//
//  EDocumentCenterTextCell.h
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"

/**
 文字cell
 */
@interface EDocumentCenterTextCell : EBaseTableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UITextField *rightTextF;
@property (nonatomic, copy) void(^rightTextDidChangeBlock)(NSString *text);
/// 限制字数
@property (nonatomic, assign) NSInteger maxLength;
@end
