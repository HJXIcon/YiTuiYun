//
//  UITableView+placeholder.m
//  BeautifulAgent
//
//  Created by 吴灶洲 on 2017/7/20.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import "UITableView+NoData.h"
#import <objc/runtime.h>


@implementation NSObject (swizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSel
           WithSwizzledSelector:(SEL)swizzledSel {
    
    Method originMethod = class_getInstanceMethod(self, originalSel);
    Method swizzedMehtod = class_getInstanceMethod(self, swizzledSel);
    BOOL methodAdded = class_addMethod(self, originalSel, method_getImplementation(swizzedMehtod), method_getTypeEncoding(swizzedMehtod));
    
    if (methodAdded) {
        class_replaceMethod(self, swizzledSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else{
        method_exchangeImplementations(originMethod, swizzedMehtod);
    }
}

@end



@implementation UITableView (placeholder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(reloadData) WithSwizzledSelector:@selector(jx_reloadData)];
    });
}


- (void)setNoDataView:(UIView *)noDataView{
    objc_setAssociatedObject(self, @selector(noDataView), noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)noDataView {
    return objc_getAssociatedObject(self, @selector(noDataView));
}



- (void)jx_reloadData {
    [self jx_checkEmpty];
    [self jx_reloadData];
}


- (void)jx_checkEmpty {
    BOOL isEmpty = YES;
    id<UITableViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [src numberOfSectionsInTableView:self];
    }
    for (int i = 0; i < sections; i++) {
        NSInteger rows = [src tableView:self numberOfRowsInSection:i];
        if (rows) {
            isEmpty = NO;
        }
    }
    if (isEmpty) {
        [self.noDataView removeFromSuperview];
        [self addSubview:self.noDataView];
        
        
    }else{
        [self.noDataView removeFromSuperview];
    }
    
}








@end
