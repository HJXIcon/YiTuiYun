//
//  CompanyCollectionFootView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyCollectionFootView.h"

@implementation CompanyCollectionFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)btnCLick:(id)sender {
    
    if (self.addBlock) {
        self.addBlock();
    }
}

@end
