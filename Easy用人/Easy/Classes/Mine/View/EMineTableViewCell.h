//
//  EMineTableViewCell.h
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"

typedef NS_ENUM(NSInteger,hintPositionStyle) {
    hintPositionNone = 1,
    hintPositionLeft,
    hintPositionRight
};

@interface EMineCellModel : NSObject

@property (nonatomic, strong) NSString *leftString;
@property (nonatomic, strong) NSString *hintString;
@property (nonatomic, assign) hintPositionStyle style;

@end


@interface EMineTableViewCell : EBaseTableViewCell
@property (nonatomic, strong) EMineCellModel *model;
@end


