//
//  PdfShowVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/7/25.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "PdfShowVc.h"
#import <WebKit/WebKit.h>

@interface PdfShowVc ()
@property(nonatomic,strong) WKWebView *webView;
@end

@implementation PdfShowVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = self.pdfname;
    
    
    [self downLoadFile];
    
    NSLog(@"-ceshide--%@",self.pdfstr);
//    UIWebView *web = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pdfstr]]];
//    
//
    [self.view addSubview:self.webView];
//
//    self.webView = web;
}

-(WKWebView *)webView{
    if (_webView == nil) {
        _webView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _webView;
}

-(void)downLoadFile{
    
    //构造资源链接
    NSString *urlString = self.pdfstr;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //创建AFN的manager对象
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    //构造URL对象
    NSURL *url = [NSURL URLWithString:urlString];
    //构造request对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //使用系统类创建downLoad Task对象
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);//下载进度
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //返回下载到哪里(返回值是一个路径)
        //拼接存放路径
        NSURL *pathURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        return [pathURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成走这个block
        if (!error)
        {
            //如果请求没有错误(请求成功), 则打印地址
            NSLog(@"====jieguo%@", filePath);
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
            [self.webView loadRequest:request];
        }
    }];
    //开始请求
    [task resume];
    
  
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
