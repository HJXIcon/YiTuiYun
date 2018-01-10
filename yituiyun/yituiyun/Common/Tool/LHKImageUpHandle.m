//
//  LHKImageUpHandle.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/20.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKImageUpHandle.h"

@implementation LHKImageUpHandle
+(instancetype)shareHandle{
    static LHKImageUpHandle *handel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handel = [[LHKImageUpHandle alloc]init];
    });
    return handel;
}


-(void)uploadimagesFromXiangeCe:(imageBlock)imageblock withPaths:(imagePathBlock)imagePaths with:(UIViewController *)vc{
    
    self.imagesblock = imageblock;
    self.pathsBlock = imagePaths;
    self.vc = vc;

    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:vc.view];
    
    
}


#pragma mark---actionSheet的代理

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {//相机
        
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType =   UIImagePickerControllerSourceTypeCamera;
        ipc.allowsEditing = YES;
        ipc.delegate = self;
        [self.vc presentViewController:ipc animated:YES completion:nil];
        
        
    }else if (buttonIndex == 1){//相册
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        [self.vc.navigationController presentViewController:ipc animated:YES completion:nil];
        
        
        //
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //从系统相册拿到一张图片 用于头像
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *resultImage = nil;
    
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        if(picker.allowsEditing){
            resultImage = info[UIImagePickerControllerEditedImage];
        }else{
            resultImage = info[UIImagePickerControllerOriginalImage];
        }
        //        [self.iconBtn setBackgroundImage:resultImage forState:UIControlStateNormal];
        
        if (self.imagesblock) {
            self.imagesblock(@[resultImage]);
        }
    }
    
    [XKNetworkManager xk_uploadImages:@[resultImage] toURL:FileUpload parameters:nil progress:^(CGFloat progress) {
        

        
    } success:^(id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (self.pathsBlock) {
            self.pathsBlock(@[dict]);
        }
    } failure:^(NSError *error) {
       
        
    }];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}



@end
