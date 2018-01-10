//
//  PlayVideoViewController.m
//  yituiyun
//
//  Created by 张强 on 2017/2/8.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "PlayVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PlayVideoViewController ()
@property (nonatomic, copy) NSString *videoUrl;

@end

@implementation PlayVideoViewController
- (instancetype)initWithVideo:(NSString *)videoUrl
{
    self = [super init];
    if (self) {
        self.videoUrl = videoUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频播放";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    imageView.image = [UIImage imageNamed:@"icon"];
    [self.view addSubview:imageView];
    
    // 播放视频按钮
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    playButton.frame = CGRectMake(200, 30, 100, 30);
    [playButton addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setTitle:@"播放视频" forState:UIControlStateNormal];
    
    playButton.backgroundColor = [UIColor greenColor];
    playButton.layer.cornerRadius = 5;
    playButton.layer.masksToBounds = YES;
    [self.view addSubview:playButton];
    
    
}

- (void)playClick:(UIButton *)btn
{
//    //视频URL
//    NSString *urlStr = [_videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    NSURL *url = [NSURL URLWithString:_videoUrl];
//    //视频播放对象
//    MPMoviePlayerController *movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
////    movie.controlStyle = MPMovieControlStyleFullscreen;
//    [movie.view setFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 300)];
////    movie.initialPlaybackTime = -1;
//    movie.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:movie.view];
//    //注册一个播放结束的通知, 当播放结束时, 监听到并且做一些处理
//    //播放器自带有播放通知的功能, 在此仅仅只需要注册观察者监听通知的即可
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:movie];
//    [movie play];
    
//    NSString *urlStr = [_videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//    [moviePlayerController.moviePlayer prepareToPlay];
//    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//    [self.view addSubview:moviePlayerController.view];
//    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

- (void)myMovieFinishedCallback:(NSNotification *)notify
{
    //视频播放对象
    MPMoviePlayerController *theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:(theMovie)];
}

////方法二:
//- (void)viewDidLoad
//{
//    self.title = @"视频播放";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
//    //首先要在 项目中导入MediaPlayer.Framework框架包.
//    //在试图控制器中导入#import <MediaPlayer/MediaPlayer.h>
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    //视频URL
//    NSURL *url;
//    if ([_videoUrl hasPrefix:@"file:"]) {
//        url = [NSURL URLWithString:_videoUrl];
//    } else {
//        url = [NSURL fileURLWithPath:_videoUrl];
//    }
//    MPMoviePlayerViewController *_moviePlayerController= [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//    [_moviePlayerController.view setFrame:CGRectMake(0,100,320,200)];
//    _moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
//    [_moviePlayerController.moviePlayer setScalingMode:MPMovieScalingModeNone];
//    [_moviePlayerController.moviePlayer setRepeatMode:MPMovieRepeatModeNone];
//    [_moviePlayerController.moviePlayer setControlStyle:MPMovieControlStyleNone];
//    [_moviePlayerController.moviePlayer setFullscreen:NO animated:YES];
//    [_moviePlayerController.moviePlayer play];
//    //视频播放组件的容器,加这个容器是为了兼容iOS6,如果不加容器在iOS7下面没有任何问题,如果在iOS6下面视频的播放画面会自动铺满self.view;
//    UIView *moviePlayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
//    [self.view addSubview:moviePlayView];
//    [moviePlayView addSubview:[_moviePlayerController.moviePlayer view]];
//}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showDeleteButton
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"delete_icon" selectedImage:@"delete_icon" target:self action:@selector(rightBarButtonDidClick)];
}

- (void)rightBarButtonDidClick
{
    if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(deleteVideoWithIndexPath:)])
    {
        [_delegate deleteVideoWithIndexPath:_indexPath];
        [self leftBarButtonItem];
    }
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
