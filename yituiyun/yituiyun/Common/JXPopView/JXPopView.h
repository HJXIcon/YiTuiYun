//
//  JXPopView.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/10/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXPopViewSelectBlock)(NSMutableIndexSet *);

@interface JXPopView : UIView

+ (instancetype)popView;

- (void)showToView:(UIView *)pointView
        withTitles:(NSArray <NSString *>*)titles
    selectIndexSet:(NSMutableIndexSet *)selectIndexSet completion:(JXPopViewSelectBlock)completion;

- (void)showToPoint:(CGPoint)toPoint
         withTitles:(NSArray <NSString *>*)titles
     selectIndexSet:(NSMutableIndexSet *)selectIndexSet completion:(JXPopViewSelectBlock)completion;

@end
