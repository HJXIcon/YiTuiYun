//
//  homeTableModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/6/6.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeTableModel : NSObject


/**项目名称 */
@property(nonatomic,strong) NSString * projectName;
/**项目图片 */
@property(nonatomic,strong) NSString *thumb ;
/**项目id */
@property(nonatomic,strong) NSString * demandid;
/**接单量 */
@property(nonatomic,strong) NSString * count;
/**成单量 */
@property(nonatomic,strong) NSString * complete_count;
/**剩余单量 */
@property(nonatomic,strong) NSString * surplus_single;
/**每单的价格 */
@property(nonatomic,strong) NSString * wn;
/**有效时间 */
@property(nonatomic,strong) NSString * timeTypeStr;
/**tags标签 */
@property(nonatomic,strong) NSArray * tags;

/**服务器的时间戳 */
@property(nonatomic,strong)  NSString * inputtime;
@property(nonatomic,strong) NSString * endDate;

@end
