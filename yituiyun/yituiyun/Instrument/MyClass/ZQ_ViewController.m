//
//  ZQ_ViewController.m
//  朝阳项目
//
//  Created by NIT on 15/5/4.
//  Copyright (c) 2015年 ZQ. All rights reserved.
//

#import "ZQ_ViewController.h"

@interface ZQ_ViewController ()

@end

@implementation ZQ_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
//    {
//        [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    }
    
//    [self setupContentView];
    
    
  


}

- (void)setupContentView
{
    if (IOS7_OR_LATER && !self.navigationController) {
        self.contentView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    } else {
        self.contentView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    _contentView.backgroundColor = [UIColor clearColor];
    [[self view] addSubview:_contentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"--内存----%@",self);
}

@end
