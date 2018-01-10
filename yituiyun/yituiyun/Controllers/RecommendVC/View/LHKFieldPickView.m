//
//  LHKFieldPickView.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKFieldPickView.h"
@interface LHKFieldPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

/**临时变量为了存放 pickView滚动了第几行 */
@property(nonatomic,assign)NSInteger index;


@end

@implementation LHKFieldPickView

-(void)awakeFromNib{
    self.index =0;
    self.filedPickView.delegate = self;
    self.filedPickView.dataSource = self;

    
    
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    [self.filedPickView reloadAllComponents];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.dataArray[row][@"name"];

}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.index =row;
   
}
+(instancetype)pickView{
    return ViewFromXib;
}
- (IBAction)fieldSelectBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(fieldPickViewFieldSelect:withFieldView:)]) {
        if (self.index == 0) {
          [self.delegate fieldPickViewFieldSelect:0 withFieldView:self];
        }else{
            [self.delegate fieldPickViewFieldSelect:self.index withFieldView:self];
        }
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"----touch---");
    
    [self fieldSelectBtnClick:nil];
    
}

@end
