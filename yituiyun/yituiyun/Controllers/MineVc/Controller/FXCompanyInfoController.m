//
//  FXCompanyInfoController.m
//  yituiyun
//
//  Created by fx on 16/10/24.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXCompanyInfoController.h"
#import "FXInPutViewController.h"
#import "HFPickerView.h"
#import "FXPersonInfoCell.h"
#import "FXWorkPalceMapController.h"
#import "FXChangePhoneController.h"
#import "FXUserInfoModel.h"
#import "FXListModel.h"
#import "ShowImageViewController.h"
@interface FXCompanyInfoController ()<UITableViewDelegate,UITableViewDataSource,FXInPutViewControllerDelegate,HFPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FXWorkPalceMapControllerDelegate,UIAlertViewDelegate,ShowImageViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) FXUserInfoModel *companyModel;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UIImageView *fontImgView;//营业执照
@property (nonatomic, strong) UIImageView *oppositeView;//负责人名片

@property (nonatomic, strong) NSMutableArray *typeArray;//企业选择类型
@property (nonatomic, strong) UILabel *tipLabel;//选择的企业
@property (nonatomic, strong) UIImageView *triangleView;

@property (nonatomic, strong) UITableView *typeTableView;

@property (nonatomic, assign) CGFloat adressH;

@end

@implementation FXCompanyInfoController{
    NSString *_selectRow;//记录选择行
    NSString *_imgSelect;//图片选择
    BOOL _isFold;//下拉选项是否收起
}
- (instancetype)init{
    if (self = [super init]) {
        self.companyModel = [[FXUserInfoModel alloc]init];
        _adressH = 40;
    }
    return self;
}

- (NSMutableArray *)typeArray{
    if (!_typeArray) {
        self.typeArray = [NSMutableArray new];
    }
    return _typeArray;
}
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        self.titleArray = [NSMutableArray arrayWithObjects:@[@""],@[@"名称",@"电话"],@[@"企业名称",@"办公地址",@"负责人姓名",@"负责人电话",@"网址",@"企业类型"],@[@""], nil];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"企业资料";
    [self.view addSubview:self.tableView];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    [self getCompanyInfo];
    [self getIndustryData];//下拉列表
    
}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 10;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 10) {
        return 4; //3
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        if (section == 0) {
            NSMutableArray *subArray = self.titleArray[0];
            return subArray.count;
        }else if(section == 1){
            if ([ZQ_CommonTool isEmptyDictionary:_companyModel.refersDic]) {
                return 0;
            }else{
                NSMutableArray *subArray = self.titleArray[1];
                return subArray.count;
 
            }
            
        }else if (section == 2){
            NSMutableArray *subArray = self.titleArray[2];
            return subArray.count;

        }
        
        else if (section == 3){
            NSMutableArray *subArray = self.titleArray[3];
            return subArray.count;
        }
        return 1;
    }else{
        return self.typeArray.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        if (section == 0) {
            return 10;
        }else{
            if (section == 1) {
                if ([ZQ_CommonTool isEmptyDictionary:_companyModel.refersDic]) {
                    return 0.0001;
                }else{
                    return 50; 
                }

            }
            return 50;
        }
    }else{
        return 0.00001;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 90;
            }
        }else if (indexPath.section == 1){
            
            return 44;
        }
        
        
        else if (indexPath.section == 2){
            if (indexPath.row == 1) {
                if ([_companyModel.address isEqualToString:@""]) {
                    return 40;
                } else {
                    CGSize detailSize = [_companyModel.address sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - 120, MAXFLOAT)];
                    if (detailSize.height <= 40) {
                        return 40;
                    } else {
                        return detailSize.height + 10;
                    }
                }
            }
        } else if (indexPath.section == 3){
            return 140;
        }
        return 40;
    } else {
        return 40;
    }
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        if (section == 0) {
            
        }else if (section == 1){
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            backView.backgroundColor = [UIColor clearColor];
            
            UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
            titleView.backgroundColor = kUIColorFromRGB(0xffffff);
            [backView addSubview:titleView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
           
            
            if ([ZQ_CommonTool isEmptyDictionary:_companyModel.refersDic]) {
                titleLabel.text = @"基本信息";
            }else{
                titleLabel.text = @"推荐人信息";
            }
            titleLabel.textColor = kUIColorFromRGB(0x404040);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:15];
            [titleView addSubview:titleLabel];
            
            return backView;
        }else if (section == 2){
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            backView.backgroundColor = [UIColor clearColor];
            
            UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
            titleView.backgroundColor = kUIColorFromRGB(0xffffff);
            [backView addSubview:titleView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
            titleLabel.text = @"基本信息";
            titleLabel.textColor = kUIColorFromRGB(0x404040);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:15];
            [titleView addSubview:titleLabel];
            
            return backView;
        }else if (section == 3){
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 50)];
            backView.backgroundColor = [UIColor clearColor];
            
            UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
            titleView.backgroundColor = kUIColorFromRGB(0xffffff);
            [backView addSubview:titleView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
            titleLabel.text = @"拍照上传";
            titleLabel.textColor = kUIColorFromRGB(0x404040);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:15];
            [titleView addSubview:titleLabel];
            
            return backView;
            
        }
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    UITableViewCell *cell;
    
    if (tableView.tag == 10) {
        FXPersonInfoCell *cell = [[FXPersonInfoCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
        CGRect rect = cell.detailLabel.frame;
        rect.size.height = 40;
        cell.detailLabel.frame = rect;
        CGRect rect1 = cell.titleLabel.frame;
        rect1.size.height = 40;
        cell.titleLabel.frame = rect1;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = YES;
                cell.changeTelBtn.hidden = YES;
                cell.heightLabel.hidden = YES;
                cell.cmLabel.hidden = YES;
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 100, 20)];
                nameLabel.text = @"企业logo";
                nameLabel.textColor = kUIColorFromRGB(0x666666);
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:nameLabel];
                
                self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 60 - 20, 15, 60, 60)];
                _iconView.layer.cornerRadius = 30;
                _iconView.clipsToBounds = YES;
                _iconView.userInteractionEnabled = YES;
                [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, _companyModel.personIcon]] placeholderImage:[UIImage imageNamed:@"morenIcon.png"]];
                [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewIBAction)]];
                [cell.contentView addSubview:_iconView];
            }
        }
        if (indexPath.section == 1) {
            
            cell.detailLabel.hidden = NO;
            
            cell.telNumLabel.hidden = YES;
            cell.changeTelBtn.hidden = YES;
            cell.heightLabel.hidden = YES;
            cell.cmLabel.hidden = YES;
            
//            cell.detailLabel.text = @"服务器返回的数据为空";
            
            if ([ZQ_CommonTool isEmptyDictionary:_companyModel.refersDic]) {
                
            }else{
                if (indexPath.row == 0) {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@",_companyModel.refersDic[@"nickname"]];
                    
                }else{
                   cell.detailLabel.text = [NSString stringWithFormat:@"%@",_companyModel.refersDic[@"mobile"]];
                }
            }

        
        
        }
        
        
        
        
        
        
        
        
        if (indexPath.section == 2){
            cell.detailLabel.hidden = NO;
            
            cell.telNumLabel.hidden = YES;
            cell.changeTelBtn.hidden = YES;
            cell.heightLabel.hidden = YES;
            cell.cmLabel.hidden = YES;
            if (indexPath.row == 0) {
                if ([_companyModel.nickName isEqualToString:@""]) {
                    cell.detailLabel.text = @"请输入企业名称";
                }else{
                    cell.detailLabel.text = _companyModel.nickName;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            if (indexPath.row == 1) {
                if ([_companyModel.address isEqualToString:@""]) {
                    cell.detailLabel.text = @"请定位办公地址";
                } else {
                    cell.detailLabel.text = _companyModel.address;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                    CGRect rect = cell.detailLabel.frame;
                    CGRect rect1 = cell.titleLabel.frame;
                    CGSize detailSize = [_companyModel.address sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ZQ_Device_Width - 120, MAXFLOAT)];
                    if (detailSize.height <= 40) {
                        rect.size.height = 40;
                        rect1.size.height = 40;
                    } else {
                        rect.size.height = detailSize.height + 10;
                        rect1.size.height = detailSize.height + 10;
                    }
                    cell.detailLabel.frame = rect;
                    cell.titleLabel.frame = rect1;
                }
            }
            if (indexPath.row == 2) {
                if ([_companyModel.realName isEqualToString:@""]) {
                    cell.detailLabel.text = @"请输入负责人姓名";
                }else{
                    cell.detailLabel.text = _companyModel.realName;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            if (indexPath.row == 3) {
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = NO;
                cell.changeTelBtn.hidden = NO;
                cell.heightLabel.hidden = YES;
                cell.cmLabel.hidden = YES;
                
                cell.telNumLabel.text = _companyModel.telPhone;
                [cell.changeTelBtn addTarget:self action:@selector(changeTelClick) forControlEvents:UIControlEventTouchUpInside];
            }
            if (indexPath.row == 4) {
                if ([_companyModel.website isEqualToString:@""]) {
                    cell.detailLabel.text = @"请输入公司官网地址";
                }else{
                    cell.detailLabel.text = _companyModel.website;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
            if (indexPath.row == 5){
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = YES;
                cell.changeTelBtn.hidden = YES;
                cell.heightLabel.hidden = YES;
                cell.cmLabel.hidden = YES;
                
                UIButton *choseButton = [UIButton buttonWithType:UIButtonTypeCustom];
                choseButton.frame = CGRectMake(self.view.frame.size.width - 160, 5, 150, 30);
                
                choseButton.layer.cornerRadius = 5;
                choseButton.layer.borderWidth = 1;
                choseButton.layer.borderColor = kUIColorFromRGB(0xe1e1e1).CGColor;
                choseButton.backgroundColor =[UIColor whiteColor];
//                [choseButton setTitle:@"" forState:UIControlStateNormal];
                [choseButton setTitleColor:MainColor forState:UIControlStateNormal];
                [choseButton addTarget:self action:@selector(choseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:choseButton];
                
                _isFold = YES;
                self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
                if ([_companyModel.industryStr isEqualToString:@"0"] || [ZQ_CommonTool isEmpty:_companyModel.industryStr] ) {
                    _tipLabel.text = @"请选择企业类型";
                    _tipLabel.textColor = kUIColorFromRGB(0x808080);
                }else{
                    _tipLabel.text = _companyModel.industryStr;
                    _tipLabel.textColor = kUIColorFromRGB(0x404040);
                }
                
                _tipLabel.textAlignment = NSTextAlignmentCenter;
                _tipLabel.font = [UIFont systemFontOfSize:14];
                [choseButton addSubview:_tipLabel];
                
                self.triangleView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tipLabel.frame) + 18, 8, 14, 14)];
                _triangleView.image = [UIImage imageNamed:@"triangle.png"];
                [choseButton addSubview:_triangleView];
                
            }
            if (indexPath.row == 6) {
                if ([_companyModel.desired isEqualToString:@""]) {
                    cell.detailLabel.text = @"请输入企业需求";
                }else{
                    cell.detailLabel.text = _companyModel.desired;
                    cell.detailLabel.textColor = kUIColorFromRGB(0x404040);
                }
            }
        }if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = YES;
                cell.changeTelBtn.hidden = YES;
                cell.heightLabel.hidden = YES;
                cell.cmLabel.hidden = YES;
                
                for (UIImageView *imgeView in cell.contentView.subviews) {
                    if (imgeView.tag == 100 || imgeView.tag == 101) {
                        [imgeView removeFromSuperview];
                    }
                }
                
                UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 20)];
                tipLabel.text = @"营业执照";
                tipLabel.textColor = kUIColorFromRGB(0x808080);
                tipLabel.textAlignment = NSTextAlignmentLeft;
                tipLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:tipLabel];
                
                self.fontImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(tipLabel.frame) + 20, 70, 70)];
                self.fontImgView.tag = 100;
                _fontImgView.userInteractionEnabled = YES;
                [_fontImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, _companyModel.certificate]]
                                placeholderImage:[UIImage imageNamed:@"addImage.png"]];
                
                NSLog(@"========%@--",_companyModel.certificate);
                
                [_fontImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyViewClick)]];
                [cell.contentView addSubview:_fontImgView];
                
                
                
                UILabel *tipLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, self.view.frame.size.width - 20, 20)];
                tipLabel1.text = @"负责人名片";
                tipLabel1.textColor = kUIColorFromRGB(0x808080);
                tipLabel1.textAlignment = NSTextAlignmentLeft;
                tipLabel1.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:tipLabel1];
                
                self.oppositeView = [[UIImageView alloc]initWithFrame:CGRectMake(120, CGRectGetMaxY(tipLabel1.frame) + 20, 70, 70)];
                self.oppositeView.tag = 101;
                _oppositeView.userInteractionEnabled = YES;
                [_oppositeView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHost, _companyModel.callingCard]] placeholderImage:[UIImage imageNamed:@"addImage.png"]];
                [_oppositeView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personViewClick)]];
                [cell.contentView addSubview:_oppositeView];
                
                
            }else if (indexPath.row == 1){
                cell.detailLabel.hidden = YES;
                cell.telNumLabel.hidden = YES;
                cell.changeTelBtn.hidden = YES;
                cell.heightLabel.hidden = YES;
                cell.cmLabel.hidden = YES;
                
               
                
            }
        }
        
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"typeCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = kUIColorFromRGB(0x404040);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        FXListModel *model = _typeArray[indexPath.row];
        cell.textLabel.text = model.title;
        cell.backgroundColor = kUIColorFromRGB(0xededed);
        return cell;
    }
    //    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 10) {
        _isFold = YES;
        [self untransform];
        //        _tipLabel.text = _typeArray[indexPath.row];
        [_typeTableView removeFromSuperview];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                NSArray *array = [NSArray arrayWithObject:_companyModel.personIcon];
                ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
                vc.delegate = self;
                [vc showMoreButton];
                pushToControllerWithAnimated(vc)
            }
        }else if (indexPath.section == 1){
            //测试
        }else if (indexPath.section == 2){//
            if (indexPath.row == 0) {//企业名称
                if ([_companyModel.nickName isEqualToString:@""]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"企业名称输入之后不可修改，请慎重" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去填写", nil];
                    alertView.tag = 10;
                    [alertView show];
                }
            }else if (indexPath.row == 1){//选择办公地址
                FXWorkPalceMapController *placeVc = [[FXWorkPalceMapController alloc]init];
                placeVc.delegate = self;
                [self.navigationController pushViewController:placeVc animated:YES];
            }else if (indexPath.row == 2){//负责人姓名
                FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
                inputVc.title = @"负责人姓名";
                inputVc.textStr = _companyModel.realName;
                inputVc.delegate = self;
                _selectRow = @"12";
                [self.navigationController pushViewController:inputVc animated:YES];
            }else if (indexPath.row == 3){//电话
                
            }else if (indexPath.row == 4){//网址
                FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
                inputVc.title = @"公司官网网址";
                inputVc.textStr = _companyModel.website;
                inputVc.delegate = self;
                _selectRow = @"14";
                [self.navigationController pushViewController:inputVc animated:YES];
            }else if (indexPath.row == 5){//年限
                
            }else if (indexPath.row == 6){
                FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
                inputVc.title = @"企业需求";
                inputVc.textStr = _companyModel.desired;
                inputVc.delegate = self;
                _selectRow = @"16";
                [self.navigationController pushViewController:inputVc animated:YES];
            }
        }else if (indexPath.section == 3){//
            
        }
        
    }else{
        _isFold = YES;
        [self untransform];
        FXListModel *model = _typeArray[indexPath.row];
        _tipLabel.text = model.title;
        _companyModel.industryStr = model.title;
        _companyModel.industry = model.linkID;
        [_typeTableView removeFromSuperview];
        [self saveCompanyInfo];
    }
    
}
#pragma mark 名称 执照提示仅可修改一次
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 10) {
            FXInPutViewController *inputVc = [[FXInPutViewController alloc]init];
            inputVc.title = @"企业名称";
            inputVc.delegate = self;
            _selectRow = @"10";
            [self.navigationController pushViewController:inputVc animated:YES];
        }
        if (alertView.tag == 20) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
            actionSheet.tag = 50;
            _imgSelect = @"20";
            [actionSheet showInView:self.view];
        }
    }
}
#pragma mark 办公地址
- (void)setWorkPlaceWith:(NSString *)workplaceStr WithLng:(NSString *)lng WithLat:(NSString *)lat{
    _companyModel.address = workplaceStr;
    _companyModel.lng = lng;
    _companyModel.lat = lat;
    [self.tableView reloadData];
    [self saveCompanyInfo];
}
#pragma mark 更改电话
- (void)changeTelClick{
    FXChangePhoneController *changeVc = [[FXChangePhoneController alloc]init];
    [self.navigationController pushViewController:changeVc animated:YES];
}
#pragma mark 下拉选项
//选择企业类型
- (void)choseButtonClick:(UIButton *)button{
    if (_isFold) {
        _isFold = NO;
        [self transform];
        CGRect rect = [button.superview convertRect:CGRectMake(button.x, button.y, button.width, button.height) toView:_tableView];
        
        self.typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x + 5, rect.origin.y + 30, rect.size.width - 10, rect.size.height * 6) style:UITableViewStyleGrouped];
        [_typeTableView setDelegate:(id<UITableViewDelegate>) self];
        [_typeTableView setDataSource:(id<UITableViewDataSource>) self];
        [_typeTableView setShowsVerticalScrollIndicator:NO];
        _typeTableView.tag = 20;
        _typeTableView.backgroundColor = kUIColorFromRGB(0xededed);
        
        [self.tableView addSubview:_typeTableView];
        
    }else{
        _isFold = YES;
        [self untransform];
        [_typeTableView removeFromSuperview];
    }
}
//三角号的旋转
- (void)transform{
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation( 180 / 180.0 * M_PI);
        [self.triangleView setTransform:transform];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)untransform{
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation( 0 / 180.0 * M_PI);
        [self.triangleView setTransform:transform];
    }completion:^(BOOL finished) {
        
    }];
}

//企业logo
- (void)iconViewIBAction{
    _imgSelect = @"10";
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
//    actionSheet.tag = 10;
//    [actionSheet showInView:self.view];
    NSArray *array = [NSArray arrayWithObject:_companyModel.personIcon];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
    vc.delegate = self;
    [vc showMoreButton];
    pushToControllerWithAnimated(vc)
}
//企业执照
- (void)companyViewClick{
    if ([_companyModel.certificate isEqualToString:@""] ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"营业执照上传之后不可修改，请慎重" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去上传", nil];
        alertView.tag = 20;
        [alertView show];
    } else {
        NSArray *array = [NSArray arrayWithObject:_companyModel.certificate];
        ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
        pushToControllerWithAnimated(vc)
    }
}

//负责人名片
- (void)personViewClick{
    _imgSelect = @"30";
    NSArray *array = [NSArray arrayWithObject:_companyModel.callingCard];
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:array];
    vc.delegate = self;
    [vc showMoreButton];
    pushToControllerWithAnimated(vc)
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
//    actionSheet.tag = 60;
//    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self cameraClick];
    }else if (buttonIndex == 1){
        [self albumClick];
    }
}
- (void)albumClick{//选择相册
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
- (void)cameraClick{//打开相机
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self.navigationController presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //从系统相册拿到一张图片
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *resultImage = nil;
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        if(picker.allowsEditing){
            resultImage = info[UIImagePickerControllerEditedImage];
        }else{
            resultImage = info[UIImagePickerControllerOriginalImage];
        }
        if ([_imgSelect isEqualToString:@"10"]) {
            self.iconView.image = resultImage;
        }else if ([_imgSelect isEqualToString:@"20"]){
            self.fontImgView.image = resultImage;
        }else if ([_imgSelect isEqualToString:@"30"]){
            self.oppositeView.image = resultImage;
        }
        
    }
    [self upLoadIcon:resultImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 头像上传
- (void)upLoadIcon:(UIImage *)image{
    [SVProgressHUD showWithStatus:@"上传中..."];
    [HFRequest uploadFileWithImage:image success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"errno"] integerValue] == 0) {
            if ([_imgSelect isEqualToString:@"10"]) {
                _companyModel.personIcon = responseObject[@"url"];
            }else if ([_imgSelect isEqualToString:@"20"]){
                _companyModel.certificate = responseObject[@"url"];
               
            }else if ([_imgSelect isEqualToString:@"30"]){
                _companyModel.callingCard = responseObject[@"url"];
            }
        }
        [self.tableView reloadData];
        [self saveCompanyInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        [self showHint:@"请检查您的网络,重新选择"];
    }];
}

- (void)refreshImageUrl:(NSString *)imageUrl
{
    if ([_imgSelect isEqualToString:@"10"]) {
        _companyModel.personIcon = imageUrl;
    }   else if ([_imgSelect isEqualToString:@"30"]){
        _companyModel.callingCard = imageUrl;
    }
    [self.tableView reloadData];
    [self saveCompanyInfo];
}

#pragma mark 生日时间选择后对时间格式处理
-(void)finishSelectWithPickerView:(HFPickerView*)pickerView withDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    //    self.dataArray[1][2] = confromTimespStr;
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *confromTimespStr = [formatter stringFromDate:date];
    //    self.dataArray[0][3] = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    //    [self.tableView reloadData];
    //    [self saveCompanyInfo];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self getCompanyInfo];

    
}
#pragma mark 每行选择填写
- (void)saveTextWith:(NSString *)text{
    if ([_selectRow isEqualToString:@"10"]) {
        _companyModel.nickName = text;
    }else if ([_selectRow isEqualToString:@"12"]){
        _companyModel.realName = text;
    }else if ([_selectRow isEqualToString:@"14"]){
        _companyModel.website = text;
    }else if ([_selectRow isEqualToString:@"16"]){
        _companyModel.desired = text;
    }
    [self.tableView reloadData];
    [self saveCompanyInfo];
}
//资料修改保存
- (void)saveCompanyInfo{
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.saveInfo"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSDictionary *dic = @{@"uid":userModel.userID,
                          @"uModelid":userModel.identity,
                          @"nickname":_companyModel.nickName,
                          @"address":_companyModel.address,
                          @"realName":_companyModel.realName,
                          @"mobile":_companyModel.telPhone,
                          @"industry":_companyModel.industry,
                          @"website":_companyModel.website,
                          @"callingCard":_companyModel.callingCard,
                          @"certificate":_companyModel.certificate,
                          @"avatar":_companyModel.personIcon,
                          @"desired":_companyModel.desired,
                          @"lng":_companyModel.lng,
                          @"lat":_companyModel.lat
                          };

    
   
    
    [SVProgressHUD showWithStatus:@"保存中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            [self showHint:@"保存成功"];
            UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
            userModel.avatar = _companyModel.personIcon;
            userModel.nickname = _companyModel.nickName;
            [ZQ_AppCache save:userModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FXReloadCompanyInfo" object:nil];
            [_tableView reloadData];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
    
}

//获取企业资料
- (void)getCompanyInfo{
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.basicInfo"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSDictionary *dic = @{@"uid":userModel.userID,
                          @"uModelid":userModel.identity,
                          };
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
                
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            NSDictionary *tempDic = responseObject[@"rst"];
            _companyModel.address = tempDic[@"address"];
            _companyModel.personIcon = tempDic[@"avatar"];
            _companyModel.callingCard = tempDic[@"callingCard"];
            _companyModel.certificate = tempDic[@"certificate"];
            _companyModel.desired = tempDic[@"desired"];
            _companyModel.industry = tempDic[@"industry"];
            _companyModel.industryStr = tempDic[@"industry_str"];
            _companyModel.telPhone = tempDic[@"mobile"];
            _companyModel.nickName = tempDic[@"nickname"];
            _companyModel.realName = tempDic[@"realName"];
            _companyModel.website = tempDic[@"website"];
            _companyModel.lng = tempDic[@"lng"];
            _companyModel.lat = tempDic[@"lat"];
            
            NSDictionary  *referees = tempDic[@"referees"];
            
            if ([ZQ_CommonTool isEmptyDictionary:referees]) {
            }else{
                _companyModel.refersDic = referees;

                
            }
            
            
            [_tableView reloadData];
            
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
    
}
//下拉列表
- (void)getIndustryData{
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=linkage.get"];
    NSDictionary *dic = @{@"keyid":@"3360",
                          @"parentid":@"0"
                          };
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject) {
            FXListModel *model = [[FXListModel alloc]init];
            model.linkID = dic[@"linkageid"];
            model.title = dic[@"name"];
            [self.typeArray addObject:model];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
