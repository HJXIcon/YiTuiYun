//
//  ZHPersonShowTableViewCell.m
//  tongmenyiren
//
//  Created by LUKHA_Lu on 16/8/31.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "ZHPersonShowTableViewCell.h"
#import "CommentsModel.h"
#import "ReplyModel.h"
#import "ZQImageAndLabelButton.h"
#import "CollectModel.h"

@interface ZHPersonShowTableViewCell ()
/** 头像 */
@property(nonatomic,strong)UIButton *headBtn;
/** 姓名 */
@property(nonatomic,strong)UILabel *nameLabel;
/** 日期 */
@property(nonatomic,strong)UILabel *timeLabel;
/** 详情描述 */
@property(nonatomic,strong)UILabel *detailsLabel;
/** 9张图片的背景View */
@property (nonatomic, strong) UIView *imageBackgroundView;
/** 底部的线 */
@property(nonatomic,strong)UIView *footLine;

@end


@implementation ZHPersonShowTableViewCell

+(ZHPersonShowTableViewCell * )cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ZQTopicCommentsCell";
    ZHPersonShowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZHPersonShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 头像
        self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn addTarget:self action:@selector(gotoPersonHome:) forControlEvents:UIControlEventTouchUpInside];
        _headBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _headBtn.clipsToBounds = true;
        _headBtn.tag = 50;
        [_headBtn.layer setMasksToBounds:YES];
        [self.contentView addSubview:_headBtn];
        // 名字
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kUIColorFromRGB(0x000000);
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        // 时间
        self.timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = kUIColorFromRGB(0x888888);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        
        // 内容
        self.detailsLabel = [[UILabel alloc]init];
        _detailsLabel.font = [UIFont systemFontOfSize:14];
        _detailsLabel.numberOfLines = 0;
        [self.contentView addSubview:_detailsLabel];
        
        // 九张图片的背景View
        self.imageBackgroundView = [[UIView alloc] init];
        [self.contentView addSubview:_imageBackgroundView];
        
        self.footLine = [[UIView alloc]init];
        _footLine.backgroundColor = kUIColorFromRGB(0xe1e1e1);
        [self.contentView addSubview:_footLine];
    }
    return self;
}

-(void)setCommentsModel:(CommentsModel *)commentsModel{
    
    _commentsModel = commentsModel;
    //头像
    [_headBtn sd_setImageWithURL:[NSURL URLWithString:[kHost stringByAppendingString:commentsModel.evaluationHeadPortrait]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user"]];
    _headBtn.frame = CGRectMake(12, 12, 27, 27);
    [_headBtn.layer setCornerRadius:_headBtn.width/2];
    //姓名
    _nameLabel.text = commentsModel.evaluationName;
    CGSize nameSize = [_nameLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - CGRectGetMaxX(_headBtn.frame) - 24, MAXFLOAT)];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headBtn.frame) + 12, CGRectGetMinY(_headBtn.frame) + 2, ZQ_Device_Width - CGRectGetMaxX(_headBtn.frame) - 24, nameSize.height);
    // 内容
    if (![ZQ_CommonTool isEmpty:commentsModel.evaluationContent]) {
        _detailsLabel.text = commentsModel.evaluationContent;
        CGSize detailsSize = [_detailsLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - CGRectGetMaxX(_headBtn.frame) - 24, MAXFLOAT)];
        _detailsLabel.frame = CGRectMake(CGRectGetMaxX(_headBtn.frame) + 12, CGRectGetMaxY(_headBtn.frame), ZQ_Device_Width - CGRectGetMaxX(_headBtn.frame) - 24, detailsSize.height);
    } else {
        _detailsLabel.text = @"";
        _detailsLabel.frame = CGRectMake(CGRectGetMaxX(_headBtn.frame) + 12, CGRectGetMaxY(_headBtn.frame), ZQ_Device_Width - CGRectGetMaxX(_headBtn.frame) - 24, 0.00001);
    }
    // 这里是所有图片的背景view
    
    CGFloat allBtnWigwh = ZQ_Device_Width - CGRectGetMinX(_nameLabel.frame)*2;
    
    CGFloat btnWight = (ZQ_Device_Width - CGRectGetMinX(_nameLabel.frame)*2 - 10)/3;
    
    for (UIView *view in _imageBackgroundView.subviews) {
        [view removeFromSuperview];
    }
    if ([ZQ_CommonTool isEmpty:commentsModel.video]) {
        if (![ZQ_CommonTool isEmptyArray:commentsModel.evaluationImagesArray]) {
            if (commentsModel.evaluationImagesArray.count == 1) {
                CGSize tempSize = [self onlyOneImageSize];
                @autoreleasepool {
                    UIButton* imagebutton = [UIButton buttonWithType:UIButtonTypeCustom];
                    imagebutton.frame = CGRectMake(0, 0, tempSize.width, tempSize.height);
                    imagebutton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imagebutton.imageView.clipsToBounds = true;
                    [imagebutton addTarget:self action:@selector(reviewImagesAction:) forControlEvents:UIControlEventTouchUpInside];
                    imagebutton.tag = 2000;
                    NSDictionary *dic = _commentsModel.evaluationImagesArray.firstObject;
                    NSString *string = dic[@"url"];
                    [imagebutton sd_setImageWithURL:[NSURL URLWithString:[kHost stringByAppendingString:string]] forState:UIControlStateNormal placeholderImage:nil options:EMSDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
                        if (cacheType == EMSDImageCacheTypeMemory) {
                            [[EMSDImageCache sharedImageCache] clearMemory];
                        }
                    }];
                    [_imageBackgroundView addSubview:imagebutton];
                    _imageBackgroundView.frame = ZQ_RECT_CREATE(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_detailsLabel.frame) + 5, tempSize.width, tempSize.height);
                }
            } else {
                CGFloat W;
                if (commentsModel.evaluationImagesArray.count == 4) {
                    W = allBtnWigwh - btnWight;
                } else {
                    W = allBtnWigwh;
                }
                NSInteger j = 0.0;
                NSInteger k = 0.0;
                for (int i = 0; i < commentsModel.evaluationImagesArray.count; i ++) {
                    
                    @autoreleasepool {
                        NSDictionary *dic = commentsModel.evaluationImagesArray[i];
                        NSString *string = dic[@"url"];
                        UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
                        if ((btnWight + 5) * j + btnWight <= W) {
                            Button.frame = CGRectMake((btnWight + 5) * j, (btnWight + 5) * k, btnWight, btnWight);
                            j ++;
                        } else {
                            j = 0.0;
                            k ++;
                            Button.frame = CGRectMake((btnWight + 5) * j, (btnWight + 5) * k  , btnWight, btnWight);
                            j ++;
                        }
                        Button.tag = 2000 + i;
                        Button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                        Button.imageView.clipsToBounds = true;
                        [Button addTarget:self action:@selector(reviewImagesAction:) forControlEvents:(UIControlEventTouchUpInside)];
                        [Button sd_setImageWithURL:[NSURL URLWithString:[kHost stringByAppendingString:string]] forState:UIControlStateNormal placeholderImage:nil options:EMSDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
                            if (cacheType == EMSDImageCacheTypeMemory) {
                                [[EMSDImageCache sharedImageCache] clearMemory];
                            }
                        }];
                        [_imageBackgroundView addSubview:Button];
                    }
                }
                _imageBackgroundView.frame = ZQ_RECT_CREATE(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_detailsLabel.frame) + 5, allBtnWigwh, (k + 1) * (btnWight + 5));
            }
        } else {
            _imageBackgroundView.frame = ZQ_RECT_CREATE(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_detailsLabel.frame), allBtnWigwh, 0.01);
        }
    } else {
        CGSize tempSize = [self videoThumbSize];
        @autoreleasepool {
            UIButton* imagebutton = [UIButton buttonWithType:UIButtonTypeCustom];
            imagebutton.frame = CGRectMake(0, 0, tempSize.width, tempSize.height);
            imagebutton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            imagebutton.imageView.clipsToBounds = true;
            [imagebutton addTarget:self action:@selector(reviewImagesAction:) forControlEvents:UIControlEventTouchUpInside];
            imagebutton.tag = 2000;
            NSString *string = _commentsModel.videoThumb;
            [imagebutton sd_setImageWithURL:[NSURL URLWithString:[kHost stringByAppendingString:string]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"translucent"] options:EMSDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
                if (cacheType == EMSDImageCacheTypeMemory) {
                    [[EMSDImageCache sharedImageCache] clearMemory];
                }
            }];
            
            UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
            imageV.frame = ZQ_RECT_CREATE(CGRectGetWidth(imagebutton.frame)/2 - 30, CGRectGetHeight(imagebutton.frame)/2 - 30, 60, 60);
            [imagebutton addSubview:imageV];
            
            [_imageBackgroundView addSubview:imagebutton];
            _imageBackgroundView.frame = ZQ_RECT_CREATE(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_detailsLabel.frame) + 5, tempSize.width, tempSize.height);
        }
    }
    commentsModel.commentCellH = CGRectGetMaxY(_imageBackgroundView.frame) + 5;
}

- (void)reviewImagesAction:(UIButton *)button{
    if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(reviewImagesButtonClickWithIndex:WithImageTag:)]) {
        [_delegate reviewImagesButtonClickWithIndex:self.indexPath WithImageTag:button.tag - 2000];
    }
}
- (void)gotoPersonHome:(UIButton*)button{
    if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(gotoPersonAction:WithBtnTag:)]) {
        [_delegate gotoPersonAction:self.indexPath WithBtnTag:button.tag - 50];
    }
}
- (CGSize)onlyOneImageSize {
    
    CGFloat imageMaxW = ScreenWidth - 75;
    CGFloat imageMaxH = imageMaxW;
    NSDictionary *dic = _commentsModel.evaluationImagesArray.firstObject;
    NSString *string = dic[@"url"];
    NSArray *array = [string componentsSeparatedByString:@"_"];//@截取
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

- (CGSize)videoThumbSize{
    CGFloat imageMaxW = ScreenWidth - 75;
    CGFloat imageMaxH = imageMaxW;
    NSString *string = _commentsModel.videoThumb;
    if ([ZQ_CommonTool isEmpty:string]) {
        return CGSizeMake(200, 200);
    }
    NSArray *array = [string componentsSeparatedByString:@"_"];//@截取
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
