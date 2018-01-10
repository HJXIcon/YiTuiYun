//
//  LHKMapAnnotation.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHKMapAnoModel.h"
@interface LHKMapAnnotation : NSObject<BMKAnnotation>


@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property(nonatomic,strong) NSString *imagePath;

@property (nonatomic, strong) NSString  *title;

@property (nonatomic, strong) NSString  *tel;

@property(nonatomic,strong)NSString *address;

/**model */
@property(nonatomic,strong) LHKMapAnoModel * dataModel;



@end
