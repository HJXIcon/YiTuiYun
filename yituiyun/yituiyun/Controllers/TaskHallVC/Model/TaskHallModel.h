//
//  TaskHallModel.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/31.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskHallModel : NSObject
/*项目名称**/
@property(nonatomic,strong) NSString * projectName;
/*封面图**/
@property(nonatomic,strong) NSString * thumb;
/**任务id */
@property(nonatomic,strong) NSString * demandid;
/**任务状态 */
@property(nonatomic,strong) NSString * demand_status;
/**描叙 */
@property(nonatomic,strong) NSArray * tags;
/**任务周期 */
@property(nonatomic,strong) NSString * timeTypeStr;

/**剩余次数 */
@property(nonatomic,strong) NSString * surplus_single;

/**接单量 */
@property(nonatomic,strong) NSString * count;

/**成单量 */
@property(nonatomic,strong) NSString * complete_count;
/**status */
@property(nonatomic,strong) NSString * status; //1.执行中 2.已停止 3.已取消

@property(nonatomic,strong) NSString * endDate;

@property(nonatomic,strong) NSString * applyStop;
@property(nonatomic,strong) NSString * price;
@property(nonatomic,strong) NSString * surplus_margin;

@end


@interface JiZhiSheHeListModel : NSObject


@property(nonatomic,strong) NSString * sex;
@property(nonatomic,strong) NSString * mobile;
@property(nonatomic,strong) NSString * age;
@property(nonatomic,strong) NSString * apply_status;
@property(nonatomic,strong) NSString * hobbies;
@property(nonatomic,strong) NSString * avatar;
@property(nonatomic,strong) NSString * birthday;
@property(nonatomic,strong) NSString * applyid;
@property(nonatomic,strong) NSString * height;
@property(nonatomic,strong) NSString * education;
@property(nonatomic,strong) NSString * nickname;
@property(nonatomic,strong) NSString * title;
@end
