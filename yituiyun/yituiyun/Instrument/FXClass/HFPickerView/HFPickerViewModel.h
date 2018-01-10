//
//  HFPickerViewModel.h
//  EasyRepair
//
//  Created by joyman04 on 16/1/6.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFPickerViewModel : NSObject
/** 上传的数据源 */
@property (nonatomic,copy) NSString* upData;
/** 上传的参数名 */
@property (nonatomic,copy) NSString* parameter;
/** 显示的title */
@property (nonatomic,copy) NSString* title;
/** 子模型数组 */
@property (nonatomic,strong) NSMutableArray* subModelArr;

@end
