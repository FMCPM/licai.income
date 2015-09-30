//
//  moviePlayer.m
//  moviePlayer
//
//  Created by Jia Cheng on 12-1-4.
//  Copyright 2012年 SUREKAM. All rights reserved.
//

#import "MoviePlayerView.h"
#import "SVProgressHUD.h"

@implementation MoviePlayerView

@synthesize m_moviePlayerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_strMovieUrl = NULL;
        m_uiBackForwardBtn = NULL;
    }
    return self;
}

//窗口显示的时候，隐藏默认的导航条
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidLoad
{
    [moviePlayerController play];
}
//页面加载时的相关处理
- (void)loadView 
{
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    [super loadView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    m_uiBackForwardBtn  = NULL;
   // NSURL* nsVedioUrl = [NSURL URLWithString:@"http://www.ahyp114.com/    video/484569/haobai.mp4"];
    NSURL* nsVedioUrl = [NSURL URLWithString:m_strMovieUrl];
    //创建播放器实例
    moviePlayerController = nil;
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:nsVedioUrl];
    
    //最好匹配屏幕大小(全屏)
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    //frame.origin.y = -20;
    frame.origin.y = 0;
    moviePlayerController.view.frame = frame;
    //手动指定源类型有助于减少播放延迟时间
    moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
    moviePlayerController.fullscreen = YES;
    moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
    moviePlayerController.controlStyle = MPMovieControlStyleFullscreen;
    //_moviePlayerController.backgroundView.backgroundColor = [UIColor whiteColor];
    //默认为-1即正常开始，否则从指定时间开始播放？
    moviePlayerController.initialPlaybackTime = -1;
    //add
    [self.view addSubview:moviePlayerController.view];
    //开始播放
    
   // [moviePlayerController setFullscreen:YES];
   // [moviePlayerController prepareToPlay];
    //注册事件


}


//设置企业视频的URL地址
-(void)setCorpMoveUrl:(NSString*)strMovieUrl
{
    m_strMovieUrl = [[NSString alloc] initWithFormat:@"%@",strMovieUrl];
}

//支持旋转
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        
        CGRect frame = CGRectMake(0, 0, 480, 320);
        [moviePlayerController.view  setFrame: frame];
                
    }
    if (toInterfaceOrientation == UIDeviceOrientationPortrait || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown )
    {

        CGRect frame = CGRectMake(0, 0, 320, 480);
        [moviePlayerController.view setFrame: frame];
    
    }
    
    [moviePlayerController setFullscreen:YES];
    
    
    NSLog(@"%d", moviePlayerController.fullscreen); 
    
}
//视频播放完成后事件(done按钮)(若未自定义此方法则默认为暂停而非终止)
- (void) playbackDidFinish
{
    if (!moviePlayerController.isPreparedToPlay) {
        [SVProgressHUD showErrorWithStatus:@"不能播放的视频格式！" duration:1.8];
    }
   // [[self navigationController] popViewControllerAnimated:YES];
    
    if (moviePlayerController) 
    {
        //手动stop之
        [moviePlayerController stop];
        /*
        NSLog(@"end of playback");
        UIButton *rePlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        rePlay.frame = CGRectMake(100, 200, 60, 20);
        [rePlay setTitle:@"重放" forState:UIControlStateNormal];
        rePlay.titleLabel.backgroundColor = [UIColor viewFlipsideBackgroundColor];
        [rePlay  addTarget:self
                    action:@selector(rePlay:) 
          forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rePlay];
      
        if(m_uiBackForwardBtn == NULL)
        {
            m_uiBackForwardBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        }
        
        m_uiBackForwardBtn.frame = CGRectMake(180, 200, 60, 20);
        [m_uiBackForwardBtn setTitle:@"返回" forState:UIControlStateNormal];
        m_uiBackForwardBtn.titleLabel.backgroundColor = [UIColor viewFlipsideBackgroundColor];
        [m_uiBackForwardBtn  addTarget:self
                    action:@selector(onBackForward:) 
          forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:m_uiBackForwardBtn];
         */
    }
    [self onBackForward:self];
}

//视频重放
- (void)rePlay:(id)sender
{
    //注册事件
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

    [moviePlayerController play];
    [sender removeFromSuperview];
    if(m_uiBackForwardBtn != NULL)
    {
        [m_uiBackForwardBtn removeFromSuperview];
       // [m_uiBackForwardBtn release];
        m_uiBackForwardBtn = NULL;
    }
    
}

//返回上一级页面
-(void)onBackForward:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];  
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


@end
