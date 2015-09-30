//
//  WebViewController.m
//
//  叮叮理财 - 通用的WebView
//
//  Created by lzq on 2014-11-20.
//
//  Copyright (c) 2014年 All rights reserved.
//

#import "WebViewController.h"
#import "GlobalDefine.h"
#import "CustomViews.h"
#import "UIOwnSkin.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize m_strViewTitle = _strViewTitle;
@synthesize m_strWebUrl = _strWebUrl;
@synthesize m_uiWebView = _uiWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
/*
	NSURL *myUrl = [NSURL URLWithString:_MainUrlStr];
	UIWebView *myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
	myWebView.delegate =self;
	myWebView.scalesPageToFit =YES;
	[myWebView setUserInteractionEnabled:YES];
	NSURLRequest  *request = [NSURLRequest requestWithURL:myUrl];
	[myWebView loadRequest:request];
	[self.view addSubview:myWebView];
	
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.frame = CGRectMake(260, 30, 50, 30);
	[backBtn setTitle:@"关闭" forState:UIControlStateNormal];
    backBtn.alpha = 0.6;
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[backBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
	[backBtn setBackgroundColor:[UIColor blackColor]];
	[backBtn setShowsTouchWhenHighlighted:NO];
    backBtn.layer.borderColor  = [UIColor blackColor].CGColor;
	[backBtn.layer setCornerRadius:5.0];
	[backBtn.layer setMasksToBounds:YES];
	[backBtn addTarget:self action:@selector(getBackView:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:backBtn];
*/
     self.navigationItem.titleView = [UIOwnSkin navibarTitleView:_strViewTitle andFrame:CGRectMake(0, 0, 100, 40)];
    
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(actionNavBackClicked:)];

    _uiWebView = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden =YES;
    
    if(_strWebUrl.length < 1 && self.m_strWebString.length < 1)
        return;
    if(_uiWebView != nil)
        return;
    if(_strWebUrl.length > 1) {
        NSURL *nsRequestUrl = [NSURL URLWithString:_strWebUrl];
        UIWebView *myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        myWebView.delegate =self;
        myWebView.scalesPageToFit =YES;
        [myWebView setUserInteractionEnabled:YES];
        NSURLRequest  *request = [NSURLRequest requestWithURL:nsRequestUrl];
        [myWebView loadRequest:request];
        [self.view addSubview:myWebView];
    } else if(self.m_strWebString.length > 1) {
        UIWebView *myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        myWebView.delegate =self;
        myWebView.scalesPageToFit =YES;
        [myWebView setUserInteractionEnabled:YES];
        [myWebView loadHTMLString:self.m_strWebString baseURL:nil];
        [self.view addSubview:myWebView];

    }

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = request.URL.relativeString;
    if([url isEqualToString:@"xrjr://success"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    
    return YES;
}


-(void)actionNavBackClicked:(id)sener
{

   
	//[SVProgressHUD dismiss];
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [SVProgressHUD dismiss];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
	[SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING ];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
	[SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
