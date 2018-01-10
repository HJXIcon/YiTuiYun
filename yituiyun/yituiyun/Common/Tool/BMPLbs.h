//
//  BMPLbs.h
//  yituiyun
//
//  Created by yituiyun on 2017/7/24.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LBSBLOCK) (BMKReverseGeoCodeResult * reslut);

@interface BMPLbs : NSObject
+(instancetype)shareManger;

@property(nonatomic,copy) LBSBLOCK lbsblock;
-(void)startLocation:(LBSBLOCK)lbsblock;
@end
