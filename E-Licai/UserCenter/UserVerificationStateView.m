//
//  UserVerificationStateView.m

//
//  Created by  on 14-3-21.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import "UserVerificationStateView.h"
#import "UIOwnSkin.h"
#import "QDataSetObj.h"
#import "CustomViews.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalDefine.h"
#import "UaConfiguration.h"


@interface UserVerificationStateView ()

@end

@implementation UserVerificationStateView
@synthesize m_uiPhoneNumText	= _uiPhoneNumText;
@synthesize m_uiUserNameLabel = _uiUserNameLabel;
@synthesize userPhoneNum;
@synthesize userName;
@synthesize m_uiMainTable = _uiMainTable;
@synthesize m_loginData =_loginData;
@synthesize passWord;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getBack
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
	self.navigationController.navigationBar.translucent = NO;
	[[UIApplication sharedApplication] setStatusBarHidden:NO ];

	self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"验证手机号码" andFrame:CGRectMake(0, 0, 100, 40)];
	
//	UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	[rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
//	rightBtn.frame = CGRectMake(0, 0, 60, 35);
//	[rightBtn addTarget:self action:@selector(NextVerificationPhoneNum) forControlEvents:UIControlEventTouchUpInside];
//	UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//	self.navigationItem.rightBarButtonItem = rightBarBtn;
//	
	
	self.navigationItem.rightBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(NextVerificationPhoneNum) text:@"下一步" andWidth:40];
	self.navigationItem.leftBarButtonItem	= [UIOwnSkin backItemTarget:self action:@selector(getBack)];
	self.view.backgroundColor = COLOR_VIEW_BACKGROUND;
	/*_uiPhoneNumText.delegate =self;
	_uiPhoneNumText.returnKeyType = UIReturnKeyDone;
	
	_uiPhoneNumText.layer.cornerRadius = 10;
	_uiPhoneNumText.layer.masksToBounds = YES;
	_uiPhoneNumText.layer.borderWidth =1;
	_uiPhoneNumText.borderStyle = UITextBorderStyleRoundedRect;
	_uiPhoneNumText.layer.borderColor = (__bridge CGColorRef)([UIColor lightGrayColor]);
	*/
	
	//_uiUserNameLabel.textColor =  [UIColor colorWithRed:52 green:138 blue:83 alpha:1];
	//_uiUserNameLabel.text = userName;
	
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{    

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[_uiPhoneNumText resignFirstResponder];
	return YES;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *tableCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
	tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
	backView.backgroundColor = [UIColor whiteColor];
	[tableCell addSubview:backView];
	
	
	
	
	if (indexPath.row ==0) {
		UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 320, 45)];
		titleLabel.font = [UIFont systemFontOfSize:14.0];
		titleLabel.text =  [NSString stringWithFormat:@"你的账号%@未验证手机号码",userName];
		[backView addSubview:titleLabel];
	
		UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 1)];
		lineView.backgroundColor = COLOR_VIEW_BACKGROUND;
		[backView addSubview:lineView];
	}
	
	if (indexPath.row ==1) {
		_uiPhoneNumText = [[UITextField alloc]init];
		_uiPhoneNumText.font = [UIFont systemFontOfSize:14.0];
		_uiPhoneNumText.frame =CGRectMake(20, 1, 280, 43);
		_uiPhoneNumText.borderStyle = UITextBorderStyleNone;
		_uiPhoneNumText.placeholder = @"请输入您的手机号";
		_uiPhoneNumText.delegate =self;
		_uiPhoneNumText .contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		_uiPhoneNumText .contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_uiPhoneNumText.returnKeyType = UIReturnKeyDone;
		//	_uiPhoneText.borderStyle  = UITextBorderStyleRoundedRect;
		
		
		UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 1)];
		lineView.backgroundColor = COLOR_VIEW_BACKGROUND;
		[backView addSubview:lineView];
		
		[backView addSubview:_uiPhoneNumText];
	}
	
	return tableCell;
}


-(void)NextVerificationPhoneNum
{

//	CaptchaConfirmView *capView = [[CaptchaConfirmView alloc]init];
//	capView.hidesBottomBarWhenPushed = YES;
//	capView.UserName = userName;
//	capView.PhoneNum  = _uiPhoneNumText.text;
//	[self.navigationController pushViewController:capView animated:YES];

	userPhoneNum = _uiPhoneNumText.text;
	
	CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
	httpHelper.m_iWebServerType =1 ;
	httpHelper.methodType = CKHttpMethodTypePost_Page;
	
	[httpHelper setMethodName:@"user.sendVerifycode"];
	
	[httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
	[httpHelper addParam:userPhoneNum forName:@"mobile"];
	[httpHelper addParam:userName forName:@"username"];
    [httpHelper addParam:@"2" forName:@"verifyType"];
	
	[httpHelper setCompleteBlock:^(id data)
	 {
		 QDataSetObj *dataSet = data;
		 if (dataSet) {
			 
		// NSString *status = [dataSet getFeildValue:0 andColumn:@"status"];
		 if ([dataSet getOpeResult] ==true) {
			 /*
			 CaptchaConfirmView *capView = [[CaptchaConfirmView alloc]init];
			 capView.hidesBottomBarWhenPushed = YES;
			 capView.m_loginData =_loginData;
			 capView.UserName = userName;
			 capView.passWord = passWord;
			 capView.PhoneNum  = _uiPhoneNumText.text;
			 [self.navigationController pushViewController:capView animated:YES];
			 */
		 }
		 else
		 {
			 NSString *str = [dataSet getErrorText];
			 [SVProgressHUD showErrorWithStatus:str duration:2.0];
		
		 }
	}
		 else
		 {
			 [SVProgressHUD showErrorWithStatus:@"发送失败" duration:2.0];
		 }
	 }];
				
	[httpHelper start];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
