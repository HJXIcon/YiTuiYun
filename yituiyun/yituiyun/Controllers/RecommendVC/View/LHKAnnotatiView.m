//
//  LHKAnnotatiView.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "LHKAnnotatiView.h"
#import "LHKMapPopView.h"

@interface  LHKAnnotatiView()<LHKMapPopViewDelegate>

@property(nonatomic,strong) LHKMapPopView * lhkpopView;


@end


@implementation LHKAnnotatiView


+(instancetype)annotationViewMapView:(MKMapView *)mapView withAnnotation:(LHKMapAnnotation *) annotation{
    
    static NSString *ID = @"annotionView";
    
    LHKMapPopView *popView = [LHKMapPopView popView];
    LHKAnnotatiView *annotionView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    annotionView.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    popView.annotation = annotation;
    
    popView.delegate = annotionView;
    
    if (annotionView == nil) {
        annotionView = [[LHKAnnotatiView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        annotionView.image =[UIImage imageNamed:@"2"];

    }
    return annotionView;
}

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        self.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:self.lhkpopView];
        self.lhkpopView.annotation = annotation;
        self.calloutOffset = CGPointMake(125, 1);
        
    }
    return self;
}
-(LHKMapPopView *)lhkpopView{
    if (_lhkpopView == nil) {
        _lhkpopView = [LHKMapPopView popView];
        _lhkpopView.delegate = self;
    }
    return _lhkpopView;
}

-(void)mapPopViewBtnClick:(LHKMapAnnotation *)model{
    if ([self.delegate respondsToSelector:@selector(mapPopViewBtnClick:)]) {
        [self.delegate mapPopViewBtnClick:model];
    }
    
}

@end
