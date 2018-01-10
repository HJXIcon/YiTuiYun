//
//  LHKCustomPickView.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/26.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKCustomPickView.h"

@interface LHKCustomPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property(nonatomic,assign)NSInteger  index;
@end

@implementation LHKCustomPickView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(instancetype)pickView{
    return ViewFromXib;
}
- (IBAction)makesureClick:(id)sender {
    if (self.makesureblock) {

        self.makesureblock(self, self.datas[self.index]);
    }
}

- (IBAction)cancelBtnClick:(id)sender {
    if (self.cancelblock) {
        self.cancelblock(self, self.datas[self.index]);
    }
}




-(void)setDatas:(NSMutableArray *)datas{
    _datas = datas;
    [self.pickView reloadAllComponents];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.datas.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    FXListModel *model = self.datas[row];
    
    return model.title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.index = row;
}
@end
