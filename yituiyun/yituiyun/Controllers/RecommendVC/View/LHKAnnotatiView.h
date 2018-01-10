//
//  LHKAnnotatiView.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LHKMapAnnotation.h"
#import "LHKMapPopView.h"

@interface LHKAnnotatiView : BMKAnnotationView
/**代理 */
@property(nonatomic,assign)id<LHKMapPopViewDelegate>  delegate;
+(instancetype)annotationViewMapView:(MKMapView *)mapView withAnnotation:(LHKMapAnnotation *) annotation;
@end
