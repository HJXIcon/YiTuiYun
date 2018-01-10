//
//  PdfTableCell.h
//  yituiyun
//
//  Created by yituiyun on 2017/7/25.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ShareBlock)();
typedef void(^ReadBlock)();

@interface PdfTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pdfNameLabel;
@property(nonatomic,copy)ShareBlock  shareblock;
@property(nonatomic,copy)ReadBlock   readblock;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@end
