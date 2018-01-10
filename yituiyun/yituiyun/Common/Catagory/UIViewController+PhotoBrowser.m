//
//  UIViewController+PhotoBrowser.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/8/31.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "UIViewController+PhotoBrowser.h"
#import <objc/runtime.h>


static const void *PhotoBrowserControllerKey = &PhotoBrowserControllerKey;
//static const void *CurrentPhotoIndexKey = &CurrentPhotoIndexKey;
//static const void *PhotoBrowser = &PhotoBrowser;

@implementation UIViewController (PhotoBrowser)

#pragma mark - getter & setter
- (NSArray<NSURL *> *)photos{
    return  objc_getAssociatedObject(self, PhotoBrowserControllerKey);
}

- (void)setPhotos:(NSArray<NSURL *> *)photos{
    objc_setAssociatedObject(self, PhotoBrowserControllerKey, photos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//- (NSUInteger)currentPhotoIndex{
//    return [objc_getAssociatedObject(self, CurrentPhotoIndexKey) integerValue];
//}
//
//- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex{
//    NSString * s = [NSString stringWithFormat:@"%ld",currentPhotoIndex];
//    
//    objc_setAssociatedObject(self, CurrentPhotoIndexKey, s, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

//- (MWPhotoBrowser *)browser{
//    
//    MWPhotoBrowser *br = objc_getAssociatedObject(self, PhotoBrowser);
//    
//    if (br == nil) {
//        
//        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//        browser.displayActionButton = NO;
//        browser.alwaysShowControls = YES;
//        browser.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"删除" target:self action:@selector(deleteAction)];
//        
//         objc_setAssociatedObject(self, PhotoBrowser, browser, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        
//        br = objc_getAssociatedObject(self, PhotoBrowser);
//    }
//    
//    return br;
//}


- (void)pushPhotoBrowser:(NSArray <NSURL *>*)photos currentPhotoIndex:(NSUInteger)currentPhotoIndex{
    
    self.photos = photos;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.enableGrid = YES;
    browser.alwaysShowControls = YES;
    //设置当前要显示的图片
    [browser setCurrentPhotoIndex:currentPhotoIndex];
    //push到MWPhotoBrowser
    [self.navigationController pushViewController:browser animated:YES];
}



#pragma mark - MWPhotoBrowserDelegate
//返回图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return self.photos.count;
}

//返回图片模型
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    NSURL *photoUrl = self.photos[index];
    
    //创建图片模型
    MWPhoto *photo = [MWPhoto photoWithURL:photoUrl]; return photo;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    NSLog(@"index == %ld",index);
//    self.currentPhotoIndex = index;
}

@end
