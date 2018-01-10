//
//  CompanyPublishTwofortw0Cell.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyPublishTwofortw0Cell.h"

@interface CompanyPublishTwofortw0Cell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleLableN;

@property (weak, nonatomic) IBOutlet UITextView *textViewN;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;

@end

@implementation CompanyPublishTwofortw0Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numberLabel.layer.cornerRadius = 7.5;
    self.numberLabel.clipsToBounds = YES;
//    self.textViewN.layer.borderColor = UIColorFromRGBString(@"0xecefef").CGColor;
//    self.textViewN.layer.borderWidth = 1;
    
    
    self.textViewN.delegate = self;
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length>500) {
        self.textViewN.text = [textView.text substringToIndex:490];
        
        return ;
    }

    
    _model.taskField = textView.text;
    
    if (textView.text.length>0) {
        self.placLabel.hidden = YES;
    }else{
        self.placLabel.hidden = NO;
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placLabel.hidden = YES;
}

- (void)addImageBtnClick:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(addImageButtonClickWithIndexPath:)]) {
        [self.delegate addImageButtonClickWithIndexPath:self.indexPath];
    }

}
- (IBAction)deleCell:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

//设置模型数据
-(void)setModel:(UploadImageModel *)model{
    _model = model;
    
    if (self.isDetail) {
        self.deleBtn.hidden = YES;
        self.textViewN.editable = NO;
        
        if (_model.taskField.length == 0) {
            self.placLabel.hidden = NO;
            self.textViewN.text = @"";
            self.textNHeightConstant.constant = 65;
        }else{
            
            CGFloat heighttextN = [self jisuanTitle:_model.taskField]+12;
            
            
            if (heighttextN<65) {
                self.textNHeightConstant.constant = 65;
            }else{
                 self.textNHeightConstant.constant = heighttextN;
            }
            self.placLabel.hidden = YES;
            self.textViewN.text = _model.taskField;
            
        }
        
        for (UIView  *btn in self.panView.subviews) {
            if([btn isKindOfClass:[UIButton class]] ){
                [btn removeFromSuperview];
                
            }
        }
        
        if (model.imageArray.count == 0) {
            
            self.cellHeight.constant = 1;
            
            
            [self addbtnToPanView:0 andY:0];
        }else{
            
            [self makeView];
            
        }
        

    }else{
        self.deleBtn.hidden = NO;
        
        
        if (_model.taskField.length == 0) {
            self.placLabel.hidden = NO;
            self.textViewN.text = @"";
        }else{
            self.placLabel.hidden = YES;
            self.textViewN.text = _model.taskField;
            
        }
        
        for (UIView  *btn in self.panView.subviews) {
            if([btn isKindOfClass:[UIButton class]] ){
                [btn removeFromSuperview];
                
            }
        }
        
        if (model.imageArray.count == 0) {
            
            self.cellHeight.constant = HRadio(90);
            
            
            [self addbtnToPanView:0 andY:0];
        }else{
            
            [self makeView];
            
        }
        

    }


    

}


-(void)addbtnToPanView:(CGFloat )x andY:(CGFloat)y{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, WRadio(90), WRadio(90))];
    [btn setBackgroundImage:[UIImage imageNamed:@"compay_xiangji"] forState:UIControlStateNormal];
    [btn addTarget:self  action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isDetail) {
        
    }else{
        
        [self.panView addSubview:btn];
 
    }

}


- (void)makeView{
    

    //      总列数
    int totalColumns = 3;
    
    //       每一格的尺寸
    CGFloat cellW = WRadio(90);
    CGFloat cellH = WRadio(90);
    
    //    间隙
    CGFloat margin =5;
    
    //    根据格子个数创建对应的框框
    for(int index = 0; index< self.model.imageArray.count; index++) {
      
        UIButton *imageView = [[UIButton alloc]init];
        NSString *imagepath = [NSString imagePathAddPrefix:_model.imageArray[index]];
        NSURL *url = [NSURL URLWithString:imagepath];
        [imageView sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        imageView.tag = 10000+index;
        [imageView addTarget:self action:@selector(showImageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        // 计算行号  和   列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat cellX = margin + col * (cellW + margin);
        CGFloat cellY = row * (cellH + margin);
        imageView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        
        // 添加到view 中  
        [self.panView addSubview:imageView];
        if (self.model.imageArray.count<9) {
            //
            
            int row = self.model.imageArray.count / totalColumns;
            int col = self.model.imageArray.count % totalColumns;
            //根据行号和列号来确定 子控件的坐标
            CGFloat cellX = margin + col * (cellW + margin);
            CGFloat cellY = row * (cellH + margin);

            [self addbtnToPanView:cellX andY:cellY];
        }
        
        if (self.model.imageArray.count<=3 && self.isDetail) {
            self.cellHeight.constant = HRadio(90);
        }else if (self.model.imageArray.count<3) {
            self.cellHeight.constant = HRadio(90);
        }else if(self.model.imageArray.count<6){
            self.cellHeight.constant = HRadio(190);
           
        }else{
            
            self.cellHeight.constant = HRadio(290);
            
        }
    }
}
- (void)showImageButtonClick:(UIButton *)button
{
    if ( [self.delegate respondsToSelector:@selector(picturesButtonClickTag:WithIndexPath:)]) {
        [self.delegate picturesButtonClickTag:button.tag - 10000 WithIndexPath:self.indexPath];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}


-(CGFloat)jisuanTitle:(NSString *)str{
    
    CGSize size = CGSizeMake(ScreenWidth-100, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
   CGSize resultSize =  [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:dic context:nil].size;
    
    return resultSize.height;
    
    
}
@end
