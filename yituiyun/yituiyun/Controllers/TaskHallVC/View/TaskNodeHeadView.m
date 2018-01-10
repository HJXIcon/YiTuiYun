//
//  TaskNodeHeadView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/2.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "TaskNodeHeadView.h"

@interface TaskNodeHeadView ()
{
    
        dispatch_source_t _timer;
    
}
@end

@implementation TaskNodeHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 status = 4,
	demandid = 229,
	timeout = 1496330208,
	time = 1496407166
 }
*/

+(instancetype)nodeHeadView{
    return ViewFromXib;
    
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    //处理时间
    NSString *currentime = [NSString stringWithFormat:@"%@",dict[@"timeout"]];
    NSString *serverTime = [NSString stringWithFormat:@"%@",dict[@"time"]];
    NSInteger interl = [currentime integerValue] - [serverTime integerValue];
    [self startTime:interl];
}


-(NSString *)getyyyymmdd{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}
-(void)startTime:(NSInteger)interal{
    if (_timer==nil) {
        __block int timeout = interal; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.hourTime.text = @"00";
                        self.miuteTime.text = @"00";
                        self.secondTime.text = @"00";
                        
                        //通知节点已经失效
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNotifceNodeInvalid object:nil];
                        
                        
                        
                    });
                    
                }else{
                   
                    int hours = (int)(timeout/3600);
                    int minute = (int)(timeout-hours*3600)/60;
                    int second = timeout-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        if (hours<10) {
                            self.hourTime.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourTime.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.miuteTime.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.miuteTime.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondTime.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondTime.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }

}

-(void)closeTime{
    if (_timer !=nil) {
        
        dispatch_source_cancel(_timer);
        _timer = nil;
        NSLog(@"----定时器-guanle--");
    }
    NSLog(@"--time_nil--定时器-guanle--");

 
}
@end
