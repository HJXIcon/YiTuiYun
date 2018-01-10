/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import "UIImageView+HeadImage.h"

@implementation UIImageView (HeadImage)

- (void)imageWithUsername:(NSString *)username placeholderImage:(UIImage*)placeholderImage
{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed:@"chatListCellHead"];
    }
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:username];
    if (dic) {
        [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, dic[@"avatar"]]] placeholderImage:placeholderImage];
    }else {
        [self sd_setImageWithURL:nil placeholderImage:placeholderImage];
    }

}

@end

@implementation UILabel (Prase)

- (void)setTextWithUsername:(NSString *)username
{
    NSDictionary *dic = [ZQ_AppCache takeOutFriendInfo:username];
    if (dic) {
        NSString *string = dic[@"nickname"];
        if (![ZQ_CommonTool isEmpty:string]) {
            [self setText:dic[@"nickname"]];
            [self setNeedsLayout];
        } else {
            [self setText:username];
        }
    } else {
        [self setText:username];
    }
    
}

@end
