//
//  UserInfoEditViewController.m
//  YTSearch
//
//  Created by jiangjunchen on 12-12-2.
//
//

#import "UserInfoEditViewController.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "CKHttpHelper.h"
#import "UIColor+Hex.h"
#import "UINavigationController+CKKit.h"

@interface UserInfoEditViewController ()

@end

@implementation UserInfoEditViewController
@synthesize m_uiEditTable = _uiEditTable;
@synthesize m_setUserInfo = _setUserInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
 //   [WebServiceHelper removeAllServicesFromController:self];
}

- (void)viewDidLoad
{
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];   
    [super viewDidLoad];
    self.title = @"编辑信息";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionTextFieldEditingDidEnd:(id)sender
{
	//NSLog(@"1");
    [sender resignFirstResponder];
}

-(IBAction)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableViewCell*)getUserEditCellFrom:(UITableView*)table indexPath:(NSIndexPath*)path
{
    static NSString *userEditInfoCellId = @"userEditInfoCellId";
    UITableViewCell *cell = (UITableViewCell*)[table dequeueReusableCellWithIdentifier:userEditInfoCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:userEditInfoCellId];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 55, 20)];
        l.font = [UIFont systemFontOfSize:15.0];
        l.textColor = [UIColor darkTextColor];
        l.backgroundColor = [UIColor clearColor];
        l.tag = 1001;
        [cell.contentView addSubview:l];
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(65, 13, cell.frame.size.width-75, 20)];
        field.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        field.tag = 1002;
		//field.delegate =self;
        field.font = [UIFont systemFontOfSize:14.0];
        field.borderStyle = UITextBorderStyleNone;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.returnKeyType = UIReturnKeyDone;
        [field addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:field];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (path.row == 0) {
        UILabel *name = (UILabel*)[cell.contentView viewWithTag:1001];
        name.text = @"姓    名:";
        UITextField *field = (UITextField*)[cell.contentView viewWithTag:1002];
        field.secureTextEntry = NO;
        field.placeholder = @"真实姓名:";
        field.clearsOnBeginEditing = NO;
        field.text = [_setUserInfo getFeildValue:0 andColumn:@"relName"];
        _fieldUserName = field;
    }
    else if (path.row == 1) {
        UILabel *pwd = (UILabel*)[cell.contentView viewWithTag:1001];
        pwd.text = @"电    话:";
        UITextField *field = (UITextField*)[cell.contentView viewWithTag:1002];
        field.placeholder = @"联系电话:";
        field.text = [_setUserInfo getFeildValue:0 andColumn:@"linkPhone"];
        _fieldLinkNumber = field;
    }
    else if (path.row == 2) {
        UILabel *pwd = (UILabel*)[cell.contentView viewWithTag:1001];
        pwd.text = @"邮    箱:";
        UITextField *field = (UITextField*)[cell.contentView viewWithTag:1002];
        field.placeholder = @"电子邮箱:";
        field.text = [_setUserInfo getFeildValue:0 andColumn:@"linkEmail"];
        _fieldEmail = field;
    }
    return cell;
    
}

-(UITableViewCell*)getUserEditOkBtnCellFrom:(UITableView*)table indexPath:(NSIndexPath*)path
{
    static NSString *userEditOkBtnCellId = @"userEditOkBtnCellId";
    UITableViewCell *cell = (UITableViewCell*)[table dequeueReusableCellWithIdentifier:userEditOkBtnCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:userEditOkBtnCellId];
        UILabel *login = [[UILabel alloc]initWithFrame:cell.contentView.bounds];
        login.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        login.font = [UIFont boldSystemFontOfSize:15.0];
        login.textColor = [UIColor whiteColor];
        login.textAlignment = UITextAlignmentCenter;
        login.backgroundColor = [UIColor clearColor];
        login.tag = 1003;
        cell.contentView.clipsToBounds = YES;
        [cell.contentView addSubview:login];/*
        cell.gradientStartColor = start_color;
        cell.gradientEndColor =  end_color;
        cell.selectionGradientStartColor = selection_start_color;
        cell.selectionGradientEndColor = selection_end_color;*/
    }
    UILabel *login = (UILabel*)[cell.contentView viewWithTag:1003];
    login.text = @"确定";
    return cell;
}


#pragma mark -about UITableView datasource and delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1 && indexPath.row==0) {
        [self startWebService];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44+[PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrettyTableViewCell *cell ;
    /*
    if (indexPath.section == 0) {
        cell = [self getUserEditCellFrom:tableView indexPath:indexPath];
        
    }
    else if (indexPath.section == 1)
    {
        cell = [self getUserEditOkBtnCellFrom:tableView indexPath:indexPath];
    }
    [cell prepareForTableView:tableView indexPath:indexPath];
     */
    return cell;
}

#pragma mark -about WebserviceHelper
-(void)startWebService
{

    
    _strUserName        = _fieldUserName.text;
    _strLinkNumber      = _fieldLinkNumber.text;
    _strEmail           = _fieldEmail.text;
    
    if(_strEmail.length != 0)
    {
        NSRange range = [_strEmail rangeOfString:@"@"];
        if (range.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"邮箱地址格式不正确" duration:1.5];
            return;
        }
    }
    NSString *strLoginName = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
  	CKHttpHelper* httpHelper = [[CKHttpHelper alloc]initWithOwner:self];
    //	httpHelper.m_iWebServerType= 1;
	
	[httpHelper setMethodName:@"modMemberInfo_ios"];
	
	[httpHelper addParam:strLoginName forName:@"username"];
	[httpHelper addParam:@"1" forName:@"memberType"];
	[httpHelper addParam:_strUserName forName:@"relName"];
	[httpHelper addParam:_strEmail forName:@"email"];
	[httpHelper addParam:_strLinkNumber forName:@"linkPhone"];
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setCityData.m_strProvinceID forName:@"provinceID"];
    
	[httpHelper setStartBlock:^{[SVProgressHUD showWithStatus:@"正在修改信息..."];}];
	[httpHelper setCompleteBlock:^(id data)
	 {
		 _uiEditTable.allowsSelection = YES;
         BOOL isChangeInfoOk = NO;
		 if(data)
		 {
			 
		     QDataSetObj *dataSet =data;
			 NSString *strResult = [dataSet getFeildValue:0 andColumn:@"boolResult"];
			 NSLog(@"%@",strResult);
			 if([strResult isEqualToString:@"True"])
			 {
				 isChangeInfoOk = YES;
				 //[UaConfiguration sharedInstance].m_setLoginState.m_isNeedReflashUserInfo = YES;
				 [SVProgressHUD showSuccessWithStatus:@"修改成功"];
				 [self.navigationController popViewControllerAnimated:YES];
			 }
		 }
		 if(!isChangeInfoOk)
         {
             [SVProgressHUD showErrorWithStatus:@"修改失败" duration:1.5];
         }
	 }
	 
	 ];
	
	[httpHelper start];
}



@end
