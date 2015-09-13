//
//  ScanResultsView.m

//
//  Created by  on 14-3-16.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import "ScanResultsView.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalDefine.h"
#import "WebViewController.h"
#import "UIOwnSkin.h"


@interface ScanResultsView ()

@end

@implementation ScanResultsView
@synthesize ScanResultsStr;
@synthesize scanView;

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
	[self initZBR];
}


-(void)viewDidAppear:(BOOL)animated
{
	[self getBack];
}

-(void)initZBR
{
	
	ZBarReaderViewController *reader = [ZBarReaderViewController new];
	reader.readerDelegate =self;
	
	reader.wantsFullScreenLayout = NO;
	reader.showsZBarControls =NO;
	
	[self setOverLayPickerView:reader];
	
	
	reader.supportedOrientationsMask   = ZBarOrientationMaskAll;
	ZBarImageScanner *scanner = reader.scanner;
	
	[scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
	
	[self presentModalViewController:reader animated:YES];
}

-(void)onTimer
{
	[timer invalidate];
	[UIView animateWithDuration:1.5	animations:^{viewLine.center = CGPointMake(160, 360);} completion:^(BOOL finished){[UIView animateWithDuration:1.5 animations:^{viewLine.center = CGPointMake(160, 120);}];}];
	NSTimeInterval  detctTime = 0.2;

	timer = [NSTimer scheduledTimerWithTimeInterval:detctTime target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
}

-(void)setOverLayPickerView:(ZBarReaderViewController *)reader
{
	
	//清除原有控件
	
    for (UIView *temp in [reader.view subviews]) {
		
        for (UIButton *button in [temp subviews]) {
			
            if ([button isKindOfClass:[UIButton class]]) {
				
                [button removeFromSuperview];
				
            }
			
        }
		
        for (UIToolbar *toolbar in [temp subviews]) {
			
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
				
                [toolbar setHidden:YES];
				
                [toolbar removeFromSuperview];
				
            }
			
        }
		
    }
	
    //画中间的基准线
	
	viewLine  = [[UIView alloc] initWithFrame:CGRectMake(60, 120, 200, 1)];
	
	
    viewLine.backgroundColor = [UIColor whiteColor];
	[timer invalidate];
    
	[reader.view addSubview:viewLine];
	
	//[timer fire];
	NSTimeInterval MaxTime =0.2;
	timer =  [NSTimer scheduledTimerWithTimeInterval:MaxTime target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
	
	
	
	//	[line release];
	
	
	//最上部view
	
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
	
    upView.alpha = 1;
	
    upView.backgroundColor = [UIColor whiteColor];
	
    [reader.view addSubview:upView];
	
    //用于说明的label
	
    UILabel * labIntroudction= [[UILabel alloc] init];
	
    labIntroudction.backgroundColor = [UIColor clearColor];
	
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
	
    labIntroudction.numberOfLines=2;
	
    labIntroudction.textColor=[UIColor blackColor];
	
    labIntroudction.text=@"请在扫描框内扫一扫商品二维码";
	labIntroudction.textAlignment = NSTextAlignmentCenter;
	
    [upView addSubview:labIntroudction];
	
	UIView *midView =  [[UIView alloc]initWithFrame:CGRectMake(40, 80, 240, 40)];
	midView.alpha = 0.3;
	midView.backgroundColor = [UIColor blackColor];
	[reader.view addSubview:midView];
	
	//左侧的view
	
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 80,40, 280)];
	
    leftView.alpha = 0.3;
	
    leftView.backgroundColor = [UIColor blackColor];
	
    [reader.view addSubview:leftView];
	
 	
	//右侧的view
	
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(280, 80, 40, 280)];
	
    rightView.alpha = 0.3;
	
    rightView.backgroundColor = [UIColor blackColor];
	
    [reader.view addSubview:rightView];
	
	
    //底部view
	
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 208)];
	
    downView.alpha = 0.3;
	
    downView.backgroundColor = [UIColor blackColor];
	
    [reader.view addSubview:downView];
	
	
    //用于取消操作的button
	
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
    cancelButton.alpha = 0.4;
	
    [cancelButton setFrame:CGRectMake(60, 390, 200, 40)];
	
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
	
    [reader.view addSubview:cancelButton];
	
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
	ZBarSymbol *symbol = nil;
	for (symbol in results)
		break;
	
	NSString *dataStr = symbol.data;
	ScanResultsStr = dataStr;
	
	
	
	
	NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
	
	
	if ([predicate evaluateWithObject:ScanResultsStr]) {
		
		NSString *storeNum;
		NSString *goodSNum;
		
		NSString *sjqStr = @"";
		NSRange rangeS = [ScanResultsStr rangeOfString:sjqStr];
		
		NSString *strScan = [ScanResultsStr substringFromIndex:rangeS.length];
		
		if (rangeS.length>1) {
			
			NSString *storeStr = @"store";
			NSRange range = [strScan rangeOfString:storeStr];
			//	int loc = range.location;
			if (range.length>1) {
				
				range = [strScan rangeOfString:@"-"];
				NSString *numStr = [strScan substringFromIndex:range.location+1];
				NSRange rangeD = [numStr rangeOfString:@"."];
				if (rangeD.length<1) {
					storeNum = numStr;
				}
				else
				{
					storeNum = [numStr substringToIndex:rangeD.location];
					
				}/*
				SjqShopGoodsListPageView *shopView = [[SjqShopGoodsListPageView alloc]init];
				shopView.hidesBottomBarWhenPushed = YES;
				shopView.m_strStoreId = storeNum;
				[self.navigationController pushViewController:shopView animated:YES];
					[picker dismissModalViewControllerAnimated:YES];*/
				return;
			}
			
			else
			{
				NSString *str = @"goods";
				NSRange rangeG = [strScan rangeOfString:str];
				if (rangeG.length>1) {
					
					rangeG = [strScan rangeOfString:@"-"];
					NSString *numStr = [strScan substringFromIndex:rangeG.location+1];
					NSRange rangeD = [numStr rangeOfString:@"."];
					if (rangeD.length<1) {
						goodSNum = numStr;
					}
					else
					{
						goodSNum = [numStr substringToIndex:rangeD.location];
						
					}
                    /*
					GoodDetailInfoPageView *goodView = [[GoodDetailInfoPageView alloc]init];
					goodView.m_strGoodID = goodSNum;
                    goodView.m_iUserFlag = 0;
					goodView.hidesBottomBarWhenPushed = YES;
					[self.navigationController pushViewController:goodView animated:YES];
					[picker dismissModalViewControllerAnimated:YES];
                     */
					return;
				}
			}
		}
		else
	{

	}
	}

}

-(void)getBack
{

	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dismissOverlayView:(id)sender{
	
	[self dismissModalViewControllerAnimated: YES];
}


- (void)viewDidLoad
{
	
	
	self.navigationItem.titleView  = [UIOwnSkin navibarTitleView:@"二维码" andFrame:CGRectMake(0, 0, 100, 40)];
	self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(getBack)];
	
	
	
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
