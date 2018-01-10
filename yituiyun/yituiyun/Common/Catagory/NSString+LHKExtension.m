//
//  NSString+LHKExtension.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "NSString+LHKExtension.h"

@implementation NSString (LHKExtension)
//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mobile.length>4) {
        NSString *str = [mobile substringToIndex:3];
        if ([str isEqualToString:@"666"]) {
            return YES ;
        }
    }

    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[0-9])|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
+(NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString integerValue]];
    
    
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    
    
    return confromTimespStr;}


+(NSString *)imagePathAddPrefix:(NSString *)str{
    if ([str hasPrefix:@"http://"]) {
        return str;
    }else{
        
        if (str.length>0) {
            str = [str substringFromIndex:1];
            str =[NSString stringWithFormat:@"%@%@",kHost,str];

            
        }else{
            str  = @"";
        }
        return str;
        
    }
    
}

+(NSString *)returnFiledString:(NSInteger)index{
    
    switch (index) {
        case 3361:
        {
            return @"金融类";
        }
            break;
        case 3362:
        {
            return @"社交类";
        }
            break;
        case 3363:
        {
            return @"教育类";
        }
            break;
        case 3364:
        {
           return @"旅游类";
        }
            break;
        case 3365:
        {
            return @"电商类";
        }
            break;
        case 3366:
        {
            return @"影视类";
        }
            break;
        case 3380:
        {
            return @"餐饮类";
        }
            break;
        case 3381:
        {
            return @"医疗类";
        }
            break;
        case 3394:
        {
            return @"地推服务类";
        }
            break;
        case 3395:
        {
            return @"线下活动营销类";
        }
            break;
        case 3400:
        {
            return @"汽车保险、汽车后市场";
        }
            break;
            
        default:
        {
            return @"暂无";
        }
            break;
    }
}

-(NSString *)stringIsNull{
    
    if ([self isEqualToString:@""] || self == nil || [self isEqualToString:@"<null>"]) {
        return @"暂无";
    }
    return self;
}


+(NSString*)returnTaskType:(NSInteger)type{
    switch (type) {
        case 1:
            return @"任务执行中";
            break;
        case 2:
            return @"任务已停止";
            break;
        case 3:
            return @"任务已取消";
            break;
        case 6:
            return @"需求进行中";
            break;
        case 7:
            return @"需求已停止";
            break;
        case 8:
            return @"需求已完成";
            break;
            
        default:
             return @"任务错误";
            break;
    }
   
}

+(NSString *)moneyType:(NSInteger)type{
    switch (type) {
        case 1:
          return @"充值";
            break;
        case 2:
            return @"退款";

            break;

        case 3:
            return @"工资";

            break;

        case 4:
            return @"提现";

            break;

        case 5:
            return @"支付需求";

            break;

        case 6:
            return @"佣金";

            break;
        case 7:
            return @"劳务税";
            
            break;

            
        default:
            break;
    }
    return @"错误";
}

+ (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}


+(NSString *)getStringWithCompanyType:(NSInteger)type{
    switch (type) {
        case 1:
            
            return @"平台审核中";
            break;
        case 2:
            return @"待审核";
            break;

        case 3:
            return @"审核通过";
            break;

        case 4:
            return @"平台审核未通过";
            break;

        case 5:
            return @"企业审核未通过";
            break;

            
        default:
            break;
    }
    return @"错误";
}





+(NSString *)timeHasSecondTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString integerValue]];
    
    
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    
    
    return confromTimespStr;


}

/**
 时间戳 -->> YYYY-MM-dd hh:mm

 @param timeString 时间戳
 */
+(NSString *)timeHasMinuteTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString integerValue]];
    
    
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    
    
    return confromTimespStr;
    
    
}


/**
 1、提现  2、公用 3、需求 4、需求 5、凭证 6、易推云logo 7、公用  8、公用 9、实名认证  默认logo
 **/

+(NSString*)noticeNameWithType:(NSInteger)type{
    
    switch (type) {
        case 1:
            return @"noti_tixian";
  
            break;
        case 2:
            return @"noti_default";
 
            break;

        case 3:
            return @"noti_xuqiu";

            break;

        case 4:
            return @"noti_xuqiu";

            break;

        case 5:
            return @"notic_pingzheng";

            break;

        case 6:
            return @"logo";

            break;

        case 7:
            return @"noti_default";

            break;

        case 8:
            return @"noti_default";

            break;
        case 9:
            return @"noti_shiming";

            break;


            
        default:
            
            return @"noti_default";

            break;
    }
    return @"noti_default";
}


+ (BOOL)isNeedToUpdateServerVersion:(NSString *)serverVersion andappVersion: (NSString *)appVersion
{
    NSArray *versions1 = [serverVersion componentsSeparatedByString:@"."];
    NSArray *versions2 = [appVersion componentsSeparatedByString:@"."];
    NSMutableArray *ver1Array = [NSMutableArray arrayWithArray:versions1];
    NSMutableArray *ver2Array = [NSMutableArray arrayWithArray:versions2];
    // 确定最大数组
    NSInteger a = (ver1Array.count> ver2Array.count)?ver1Array.count : ver2Array.count;
    // 补成相同位数数组
    if (ver1Array.count < a) {
        for(NSInteger j = ver1Array.count; j < a; j++)
        {
            [ver1Array addObject:@"0"];
        }
    }
    else
    {
        for(NSInteger j = ver2Array.count; j < a; j++)
        {
            [ver2Array addObject:@"0"];
        }
    }
    // 比较版本号
    int result = [self compareArray1:ver1Array andArray2:ver2Array];
    if(result == 1)
    {
        return YES;
    }
    else if (result == -1)
    {
        return NO;
    }
    else if (result ==0 )
    {
        return NO;
        
    }
    return NO;
}
// 比较版本号
+ (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2
{
    for (int i = 0; i< array2.count; i++) {
        NSInteger a = [[array1 objectAtIndex:i] integerValue];
        NSInteger b = [[array2 objectAtIndex:i] integerValue];
        if (a > b) {
            return 1;
        }
        else if (a < b)
        {
            return -1;
        }
    }
    return 0;
}



+(NSString *)realNameStaus:(NSInteger)index{
    switch (index) {
        case 0:
            return @"未认证";
            break;
        case 1:
            return @"审核中";
            break;
        case 2:
            return @"已认证";
            break;
        case 3:
            return @"认证失败";
            break;
            
        default:
            break;
    }
    return @"error";
}


+(NSString*)JianZhiStatusWithType:(NSInteger)type{
    switch (type) {
        case 0:
            return @"待审核";
            break;
        case 1:
            return @"审核未通过";
            break;
        case 2:
            return @"审核通过";
            break;
        case 3:
            return @"待支付";
            break;
        case 6:
            return @"招聘开始";
            break;
        case 7:
            return @"招聘停止";
            break;
        case 8:
            return @"招聘完成";
            break;
       
     
            
        default:
            return @"错误";
            break;
    }
    
}

+(NSString *)unitJianZhiWithType:(NSInteger)type{
    switch (type) {
        case 1:
            return @"天";
            break;
        case 2:
            return @"小时";
            break;
        case 3:
            return @"周";
            break;
        case 4:
            return @"月";
            break;
            
        default:
            return @"error";
            break;
    }
}

+(NSString *)settmenJianZhiWithType:(NSInteger)type{
    switch (type) {
        case 1:
           return @"日结";
           break;
        case 2:
            return @"次日结";
            break;
        case 3:
            return @"周结";
            break;
        case 4:
            return @"月结";
            break;
        case 5:
            return @"完工结";
            break;
      
            
        default:
            break;
    }
    return @"er";
}

+(NSString *)statusWithShenHe:(NSInteger)type{
    switch (type) {
        case 1:
            return @"已报名";
            break;
        case 2:
            return @"已拒绝";
            break;
        case 3:
            return @"已录取";
            break;
        case 4:
            return @"取消报名";
            break;
            
        default:
            break;
    }
    return @"";
}

+(NSString *)sexWithSheHe:(NSInteger)type{
    switch (type) {
        case 0:
            return @"男女不限";
            break;
        case 1:
            return @"男";
            break;
        case 2:
            return @"女";
            break;
            
        default:
            break;
    }
    return @"";
}


+(NSString *)educationWithSheHe:(NSInteger)type{
    switch (type) {
        case 0:
            return @"未知";
            break;
        case 1:
            return @"博士";
            break;
        case 2:
            return @"研究生";
            break;
        case 3:
            return @"本科";
            break;
        case 4:
            return @"专科";
            break;
        case 5:
            return @"高中";
            break;

        case 6:
            return @"中专";
            break;
        case 7:
            return @"初中";
            break;
        case 8:
            return @"小学";
            break;

            
        default:
            break;
    }
    return @"";
}


+(NSString *)baomingStausWith:(NSInteger)type{
    switch (type) {
        case 0:
            return @"未报名";
        case 1:
            return @"已报名";
        case 2:
            return @"被拒绝";
        case 3:
            return @"被录取";
        case 4:
            return @"取消报名";
            break;
            
        default:
            break;
    }
    return @"";
}

+(NSString *)jobTypeWithType:(NSInteger)type{
    switch (type) {
        case 0:
            return @"身份不限";
        case 1:
            return @"全职";
        case 2:
            return @"兼职";
        case 3:
            return @"校园兼职";
        
            break;
            
        default:
            break;
    }
    return @"";
}



+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


+(BOOL)isSuccesspriceNumber:(NSString *)string{
    
    
  
    
    if( ![self isPureInt:string] && ![self isPureFloat:string])
    {
                
        
        return NO;
    }else{
        
        if ([string floatValue] == 0) {
            return NO;
            
           
        }
        return YES;
    }
    
}

+(long long)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    
    if ([ZQ_CommonTool isEmpty:format]) {
        format = @"YYYY-MM-dd";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    
    
//    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    
    
    
    return timeSp;
    
}
@end
