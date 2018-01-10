//
//  NSString+HFExtension.m
//  ResaleTreasure
//
//  Created by joyman04 on 16/1/29.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "NSString+HFExtension.h"

@implementation NSString (HFExtension)

-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(NSDate*)toDate{
    return [NSDate dateWithTimeIntervalSince1970:[self floatValue]];
}

+(NSString*)getDateFromTimeStamp:(NSString*)timeStamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp floatValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString*)stringWithDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    return confromTimespStr;
}

+(NSString*)stringWithDate:(NSDate*)date withFormat:(NSString*)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    return confromTimespStr;
}

-(NSString*)weekStrFromTimeStamp{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now = [NSDate dateWithTimeIntervalSince1970:[self floatValue]];;
    comps = [calendar components:unitFlags fromDate:now];
    
    //    NSLog(@"-----------weekday is %d",[comps weekday]);
    NSString* weekStr;
    switch ([comps weekday]) {
        case 1:weekStr = @"日"; break;
        case 2:weekStr = @"一"; break;
        case 3:weekStr = @"二"; break;
        case 4:weekStr = @"三"; break;
        case 5:weekStr = @"四"; break;
        case 6:weekStr = @"五"; break;
        case 7:weekStr = @"六"; break;
        default:weekStr = @"";  break;
    }
    return [NSString stringWithFormat:@"星期%@",weekStr];
}

-(NSString*)monthAndDayFromTimeStamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM/dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self floatValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
/**
 72  *  计算文本的宽高
 73  *
 74  *  @param str     需要计算的文本
 75  *  @param font    文本显示的字体
 76  *  @param maxSize 文本显示的范围
 77  *
 78  *  @return 文本占用的真实宽高
 79  */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    //    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_0)
    if (self) {
        CGSize size =  [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        if (size.width == 0 && size.height == 0) {
            return maxSize;
        }
        return size;
    }else{
        return CGSizeZero;
    }
}

@end
