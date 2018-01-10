//
//  ImageOrVideoModel.h
//  yituiyun
//
//  Created by 张强 on 2017/2/8.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageOrVideoModel : NSObject
/** 类型 1.图片 2.视频*/
@property (nonatomic, copy) NSString *type;
/** 图片地址  */
@property (nonatomic, copy) NSString *dataUrl;
/** 视频地址  */
@property (nonatomic, copy) NSString *videoUrl;
/** 缩略图  */
@property (nonatomic, strong) UIImage *image;
/** 视频名字  */
@property (nonatomic, strong) UIImage *videoName;
@end
