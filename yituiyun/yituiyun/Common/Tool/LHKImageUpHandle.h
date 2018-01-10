//
//  LHKImageUpHandle.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/20.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^imageBlock)(NSArray *images);
typedef void(^imagePathBlock)(NSArray *imagePaths);
@interface LHKImageUpHandle : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,copy)imageBlock imagesblock;
@property(nonatomic,copy)imagePathBlock pathsBlock;
@property(nonatomic,strong) UIViewController * vc;

+(instancetype)shareHandle;


-(void)uploadimagesFromXiangeCe:(imageBlock)imageblock withPaths:(imagePathBlock)imagePaths with:(UIViewController *)vc;
@end
