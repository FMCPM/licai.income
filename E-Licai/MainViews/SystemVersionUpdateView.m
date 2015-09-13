//
//  SystemVersionUpdateView.m
//
//
//  Created by on 14-6-18.
//
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import "SystemVersionUpdateView.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>


@interface SystemVersionUpdateView ()

@end

@implementation SystemVersionUpdateView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
	m_isNeedUpdate = NO;
	m_versionData =  [[QDataSetObj alloc]init];
	[self startCheckVersion];

}

-(void)startInitView
{
	int iHight = 0;
	UIView * m_headView = [[UIView alloc]init];
	m_headView.backgroundColor = COLOR_VIEW_BACKGROUND;
	[self.view addSubview:m_headView];
	
	//m_isNeedUpdate =YES;
	if (m_isNeedUpdate ==NO) {
		iHight = 45;
		
		UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 25)];
		infoLabel.font = [UIFont systemFontOfSize:16.0];
		infoLabel.textColor = COLOR_FONT_3;
		infoLabel.text = [NSString stringWithFormat:@"已更新至最新版%@",[UaConfiguration sharedInstance].m_strApplicationVersion];
		[m_headView addSubview:infoLabel];
	}
	else
	{
		iHight = 104;
		
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 17, 65, 65)];
		imageView.image = [UIImage imageNamed:@"Icon@2x.png"];
		[m_headView addSubview:imageView];
		
		UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 29, 50, 24)];
		nameLabel.textColor = COLOR_FONT_3;
		nameLabel.font = [UIFont systemFontOfSize:22];
		nameLabel.text = @"叮叮理财";
		[m_headView addSubview:nameLabel];
		
		
		UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 220, 25)];
        infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.font = [UIFont systemFontOfSize:14.0];
		infoLabel.textColor = COLOR_FONT_2;
		infoLabel.text = [NSString stringWithFormat:@"版本号：%@（当前版本%@）",[m_versionData getFeildValue:0 andColumn:@"version"],[UaConfiguration sharedInstance].m_strApplicationVersion];
		[m_headView addSubview:infoLabel];
		
		UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		updateBtn.frame = CGRectMake(252, 30, 50, 30);
		[updateBtn.layer setCornerRadius:5];
		[updateBtn.layer setMasksToBounds:YES];
		[updateBtn.layer setBorderWidth:2];
		[updateBtn setTitle:@"更新" forState:UIControlStateNormal];
		[updateBtn setTitleColor:COLOR_BUTTON_RECT forState:UIControlStateNormal];
		updateBtn.titleLabel.font  = [UIFont systemFontOfSize:17.0];
		[updateBtn setBorder:COLOR_BUTTON_RECT width:1.0];
		[updateBtn addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
		[m_headView addSubview:updateBtn];
		
		
	}
	
	m_headView.frame =CGRectMake(0, 0, 320, iHight);
	
    //加载更新显示
	NSURL *myUrl = [NSURL URLWithString:m_strUpdateMemoUrl];
	UIWebView *m_webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, iHight, 320, self.view.frame.size.height -iHight)];
	m_webView.delegate= self;
	m_webView.scalesPageToFit = YES;
	[m_webView setUserInteractionEnabled:YES];
	NSURLRequest *request = [NSURLRequest requestWithURL:myUrl];
	[m_webView loadRequest:request];
	[self.view addSubview:m_headView];

}
-(void)startCheckVersion
{

    
	CKHttpHelper *helper = [[CKHttpHelper alloc]initWithOwner:self];
	
	[helper setM_iWebServerType:1];
	[helper setMethodType:CKHttpMethodTypePost_Page];
	[helper setMethodName:@"app.versionUpdate"];
	
	[helper addParam:[NSString stringWithFormat:@"2"] forName:@"appType"];
	[helper addParam:[UaConfiguration sharedInstance].m_strApplicationVersion forName:@"version"];

	[helper  setCompleteBlock:^(id data)
	 {
		 QDataSetObj *setObj = data;
		 
		 if (setObj) {
			 
			 m_versionData =setObj;
			 
			 if (setObj.getOpeResult==false) {
				 [SVProgressHUD showErrorWithStatus:[setObj getErrorText] duration:2.0];
				 return ;
			 }
			 
			 else
			 {
				 NSString *str= [setObj getFeildValue:0 andColumn:@"updateFlag"];
				 if ([str isEqualToString:@"0"]) {
					 m_isNeedUpdate = NO;
				 }
				 else if ([str isEqualToString:@"2"])
				 {

					 m_isNeedUpdate = YES;
				 }
				 
				 else  if ([str isEqualToString:@"1"] ) {
					 
					 m_isNeedUpdate = YES;
				 }
			 }
			 m_strUpdateMemoUrl = [setObj getFeildValue:0 andColumn:@"updateMemo"];
             [self startInitView];
			 
		 }
		 else
		 {
			 [SVProgressHUD showErrorWithStatus:@"网络错误，请重试" duration:2.0];
			 return;
		 }
	 }];
	
	
	[helper start];

}

-(void)getBack
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
	
	
	//NSString *st  = [m_versionData getFeildValue:0 andColumn:@"version"];
	
	self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"版本更新" andFrame:CGRectMake(0, 0, 100, 40)];
	self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(getBack)];
	
		
	
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)updateVersion
{

    //默认为app store更新
    NSURL* nsUrl = [[NSURL alloc]initWithString:@"https://itunes.apple.com/us/app/mo-jie/id620302844?l=zh&ls=1&mt=8"];

    if([UaConfiguration sharedInstance].m_iAppUpdateFromType == 2)
    {

    }
    [[UIApplication sharedApplication]openURL:nsUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
