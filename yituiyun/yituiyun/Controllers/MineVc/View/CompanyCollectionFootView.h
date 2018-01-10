//
//  CompanyCollectionFootView.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddBlock) ();

@interface CompanyCollectionFootView : UICollectionReusableView

@property(nonatomic,copy) AddBlock addBlock;
@end
