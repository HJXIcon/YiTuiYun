//
//  NSString+HFExtension.h
//  ResaleTreasure
//
//  Created by joyman04 on 16/1/29.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HFExtension)

-(BOOL)isChinese;

-(NSDate*)toDate;

+(NSString*)getDateFromTimeStamp:(NSString*)timeStamp;

+(NSString*)stringWithDate:(NSDate*)date;

+(NSString*)stringWithDate:(NSDate*)date withFormat:(NSString*)format;

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

-(NSString*)monthAndDayFromTimeStamp;

-(NSString*)weekStrFromTimeStamp;

@end
