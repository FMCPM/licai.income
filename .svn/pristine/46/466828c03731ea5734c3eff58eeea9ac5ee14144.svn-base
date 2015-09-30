//
//  AhWebView.m
//  Ahdx-E-YellowPage
//
//  Created by on 13-8-28.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "AhWebView.h"
#import "UIOwnSkin.h"
@interface AhWebView ()

@end


@implementation AhWebView

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

    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	UIWebView *myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	myWebView.backgroundColor =[UIColor clearColor];
	myWebView.delegate =self;
	NSString *urlStr = [NSString stringWithFormat:@"http://ah.189.cn"];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSURLRequest *request =[NSURLRequest requestWithURL:url];
	[myWebView loadRequest:request];
	[myWebView setUserInteractionEnabled:YES];
	[self.view addSubview:myWebView];
	
	UIButton *returnBackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [returnBackButton setBackgroundImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
	returnBackButton.frame =CGRectMake(0, 0, 25	, 25);
	[returnBackButton addTarget:self action:@selector(backNavButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[myWebView addSubview:returnBackButton];
	
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSigleTap:)];
//	[self.view addGestureRecognizer:singleTap];
//	singleTap.delegate =self;
//	singleTap.cancelsTouchesInView = NO;
//	
	
	
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
   // self.navigationController.navigationBarHidden = NO;

}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"start");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//	[UIView animateWithDuration:0.8 animations:^{[self.navigationController setNavigationBarHidden:YES];}];
	NSLog(@"finish");
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"error");
}
- (void)backNavButtonAction:(UIButton *)sender
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
