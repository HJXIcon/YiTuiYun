//
//  CommentsModel.m
//  tongmenyiren
//
//  Created by 张强 on 16/8/26.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "CommentsModel.h"

@implementation CommentsModel

-(void)setCategory1:(NSString *)category1 {
    
    _category1 = category1;

    CGSize detailsSize = [self.evaluationContent sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - 45 - 24, MAXFLOAT)];
    
    CGFloat backHeigh;
    /** 图片的tag值 */
    
    // 这里是所有图片的背景view

    if (![ZQ_CommonTool isEmptyArray:self.evaluationImagesArray]) {
        
        if (self.evaluationImagesArray.count == 1) {
            
            CGSize tempSize = [self onlyOneImageSize];
            @autoreleasepool {
                UIButton* imagebutton = [UIButton buttonWithType:UIButtonTypeCustom];
                imagebutton.frame = CGRectMake(0, 0, tempSize.width, tempSize.height);
                imagebutton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                imagebutton.imageView.clipsToBounds = true;
                imagebutton.tag = 2001;
                [imagebutton sd_setImageWithURL:[NSURL URLWithString:[kHost stringByAppendingString:self.evaluationImagesArray[0]]] forState:UIControlStateNormal placeholderImage:nil options:EMSDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
                    if (cacheType == EMSDImageCacheTypeMemory) {
                        [[EMSDImageCache sharedImageCache] clearMemory];
                    }
                }];
                backHeigh = detailsSize.height + 12 + 45 + 5 + tempSize.height;
            }
        } else {
            NSInteger j = 0.0;
            NSInteger k = 0.0;
            for (int i = 0; i < self.evaluationImagesArray.count; i ++) {
                NSString *string = self.evaluationImagesArray[i];
                UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
                if (89 * j + 84 <= (ZQ_Device_Width - 45 - 24)) {
                    Button.frame = CGRectMake(89 * j, 89 * k, 84, 84);
                    j ++;
                } else {
                    j = 0.0;
                    k ++;
                    Button.frame = CGRectMake(89 * j, 89 * k  , 84, 84);
                    j ++;
                }
                Button.tag = 2001 + i;
                Button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                Button.imageView.clipsToBounds = true;
                [Button sd_setImageWithURL:[NSURL URLWithString:[kHost stringByAppendingString:string]] forState:UIControlStateNormal];
            }
           backHeigh = detailsSize.height + 12 + 45 + 5 + (k + 1) * 89;
        }
    } else {
        backHeigh = detailsSize.height + 12 + 45 + 5;
    }


    self.commentCellH = backHeigh + 10 - 5;

}

- (CGSize)onlyOneImageSize {
    
    CGFloat imageMaxW = ScreenWidth - 75;
    CGFloat imageMaxH = imageMaxW;
    NSArray *array = [self.evaluationImagesArray[0] componentsSeparatedByString:@"_"];//@截取
    if (array.count == 2) {
        NSArray *array2 = [array[1] componentsSeparatedByString:@"."];//.截取
        if (array2.count == 2) {
            NSArray *array3 = [array2[0] componentsSeparatedByString:@"x"];
            if (array3.count == 2) {
                CGFloat imageWith = [array3.firstObject floatValue];
                CGFloat imageHeight = [array3.lastObject floatValue];
                
                if (imageWith > imageMaxW) {
                    if (imageHeight > imageMaxH) {
                        if (imageHeight == imageWith) {
                            return CGSizeMake(imageMaxW, imageMaxH);
                        } else if (imageWith > imageHeight) {
                            return CGSizeMake(imageMaxW, imageHeight / imageWith * imageMaxH);
                        } else {
                            return CGSizeMake(imageWith / imageHeight * imageMaxW, imageMaxH);
                        }
                    } else {
                        return CGSizeMake(imageMaxW, imageMaxW / imageWith * imageHeight);
                    }
                } else {
                    if (imageHeight > imageMaxH) {
                        return CGSizeMake(imageMaxH / imageHeight * imageWith, imageMaxH);
                    } else {
                        return CGSizeMake(imageWith, imageHeight);
                    }
                }
            }
        }
    }
    return CGSizeZero;
}


@end
