//
//  HFNeighboursTitleModel.h
//  CommunityBBS
//
//  Created by joyman04 on 16/3/7.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFNeighboursTitleModel : NSObject

/** 栏目id */
@property (nonatomic,copy) NSString* channelId;
/** 简称 */
@property (nonatomic,copy) NSString* name;
/** 父类id */
@property (nonatomic,copy) NSString* parentid;
/** 图片 */
@property (nonatomic,copy) NSString* img;
/** 页数 */
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableArray* subModels;

@end
