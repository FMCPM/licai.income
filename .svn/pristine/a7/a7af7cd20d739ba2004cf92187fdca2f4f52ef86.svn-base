//
//  BuyGoodsFlowPopView.m

//
//  Created by lzq on 2014-03-04.
//

#import "UserAddrInfoEditPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "CKHttpHelper.h"
#import "UIColor+Hex.h"
#import "BillDataSet.h"
//#import "ProvinceListViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "SVProgressHUD.h"
//#import "UserRecAddressPageView.h"

@interface UserAddrInfoEditPageView ()

@end

@implementation UserAddrInfoEditPageView

@synthesize iEditType = m_iEditType;
@synthesize m_blEditing = _blEditing;
@synthesize pAddrDetail = m_pAddrDetail;
@synthesize m_strCountryId = _strCountryId;
@synthesize m_strDistrictFullName = _strDistrictFullName;


@synthesize m_pCellDelegate = _pCellDelegate;
@synthesize m_uiAddrTableView = _uiAddrTableView;
@synthesize m_iViewShowType = _iViewShowType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        m_isDefault = 0;
        m_iEditType = 1;
        _strCountryId = @"";
        _strDistrictFullName = @"";
        m_strContact = @"";
        m_strAddress = @"";
        m_strMobile = @"";
        m_strPhone = @"";
        m_strZipCode = @"";
        m_addressId = @"";
        m_offsetToMove = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_bShowKeyboard = false;
    m_pTapGesture = nil;
    //加载数据
    m_originalAddrDetail  = nil;
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setEditAddr];
    [self initUI];

    m_iTableHeight = _uiAddrTableView.frame.size.height;
    _uiAddrTableView.backgroundColor = COLOR_VIEW_BACKGROUND;
    [_uiAddrTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSString* strTitle = @"";
    if (m_iEditType == 1)//新增
    {
        strTitle = @"新增收货地址";

    }
    else
    {
        strTitle = @"地址详情";

    }
    
   
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{

    if (m_bShowKeyboard == false)
    {
        m_bShowKeyboard = true;
        
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];

        
        int iMoveHeight = m_iTableHeight - keyboardRect.size.height ;
        _uiAddrTableView.frame = CGRectMake(0, 0, _uiAddrTableView.frame.size.width, iMoveHeight);
    }

    
    if(m_pCurEditingField == nil && m_pCurTextViewField == nil)
        return;
    
    UIView *pText = nil;
    if (m_pCurEditingField != nil)
    {
        pText = (UIView *) m_pCurEditingField;
    }
    
    if (m_pCurTextViewField != nil)
    {
        pText = (UIView *) m_pCurTextViewField;
    }
    
    
    UITableViewCell* pCellObj = [UIOwnSkin getSuperTableViewCell:pText];
    if(pCellObj == nil)
        return;

    if(m_pTapGesture == nil)
    {
        m_pTapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [self.view addGestureRecognizer:m_pTapGesture];
    }

    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint point = [pCellObj convertPoint:CGPointMake(0, pText.frame.size.height + pText.frame.origin.y) toView:_uiAddrTableView];
    
    
    CGFloat activeOffset = point.y - _uiAddrTableView.contentOffset.y;
    CGFloat kbOffset = self.view.frame.size.height -kbSize.height;
    
    m_offsetToMove = 0;
    if (activeOffset > kbOffset)
    {
        m_offsetToMove = activeOffset - kbOffset + 10;
        [_uiAddrTableView setContentOffset:CGPointMake(0, _uiAddrTableView.contentOffset.y + m_offsetToMove) animated:YES];
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    m_bShowKeyboard = false;
    
    if(m_pTapGesture != nil)
    {
        [self.view removeGestureRecognizer:m_pTapGesture];
        m_pTapGesture  = nil;
    }
    if(m_pCurEditingField)
    {
        [m_pCurEditingField resignFirstResponder];
    }
    
    if(m_pCurTextViewField)
    {
        [m_pCurTextViewField resignFirstResponder];
    }
    
    _uiAddrTableView.frame = CGRectMake(_uiAddrTableView.frame.origin.x, _uiAddrTableView.frame.origin.y, _uiAddrTableView.frame.size.width, m_iTableHeight);
    
    [_uiAddrTableView setContentOffset:CGPointMake(0, 0) animated:YES];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void) actionEditStoreInfo:(id) sender
{
    _blEditing = true;
    self.navigationItem.rightBarButtonItem.enabled = false;
    [self initRightBarButttonItem];
    [_uiAddrTableView reloadData];
}

-(void) actionDetailStoreInfo:(id) sender
{
    _blEditing = false;
    self.navigationItem.rightBarButtonItem.enabled = false;
    [self initRightBarButttonItem];
    [_uiAddrTableView reloadData];
}

-(void) initRightBarButttonItem
{
    if (_blEditing == false)
    {
        self.navigationItem.rightBarButtonItem  = [UIOwnSkin navTextItemTarget:self action:@selector(actionEditStoreInfo:) text:@"编辑" andWidth:40];
    }
    else
    {
        if (m_iEditType == 1)
        {
            self.navigationItem.rightBarButtonItem  = [UIOwnSkin navTextItemTarget:self action:@selector(actionInfoSaveButton:) text:@"保存" andWidth:40];
        }
        else
        {
            self.navigationItem.rightBarButtonItem  = [UIOwnSkin navTextItemTarget:self action:@selector(actionInfoSaveButton:) text:@"修改" andWidth:40];
        }
    }
    self.navigationItem.rightBarButtonItem.enabled = true;
}

-(void)backNavButtonAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)actionTextFieldEditingDidEnd:(id)sender
{
    [sender resignFirstResponder];
}

- (void)initUI
{
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    [self initRightBarButttonItem];
//    self.navigationItem.rightBarButtonItem  = [UIOwnSkin navTextItemTarget:self action:@selector(actionInfoSaveButton:) text:@"保存" andWidth:40];
    
    if (m_iEditType == 1)//新增
    {
        self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"新增收货地址" andFrame:CGRectMake(0, 0 , 100, 40)];
    }
    else
    {
        self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"地址详情" andFrame:CGRectMake(0, 0 , 100, 40)];
    }

   // _uiScrView.contentSize = CGSizeMake(320, _uiSelectedBkButton.frame.origin.y + _uiSelectedBkButton.frame.size.height + 20);
    //_uiName.delegate = self;
    //_uiMobile.delegate = self;
    //_uiAdress.delegate = self;
    //_uiTel.delegate = self;
   // _uiZip.delegate = self;
    
  /*
    [_uiCheckButton setBackgroundImage:[UIImage imageNamed:@"checkbox_nil"] forState:UIControlStateNormal];
    [_uiCheckButton setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
   */
}

- (void)setEditAddr
{
    if (m_iEditType == 1) //新增
    {
        m_pAddrDetail = [[SetRowObj alloc] init];
    }
    else
    {
        if(m_originalAddrDetail != nil)
            return;
        [self initEditInfo];
         m_originalAddrDetail = [[SetRowObj alloc] init];
        [m_originalAddrDetail addFieldObj:@"id" andValue:m_addressId];
        [m_originalAddrDetail addFieldObj:@"contact" andValue:m_strContact];
        [m_originalAddrDetail addFieldObj:@"address" andValue:m_strAddress];
        [m_originalAddrDetail addFieldObj:@"mobile" andValue:m_strMobile];
        [m_originalAddrDetail addFieldObj:@"phone" andValue:m_strPhone];
        [m_originalAddrDetail addFieldObj:@"zipCode" andValue:m_strZipCode];
        [m_originalAddrDetail addFieldObj:@"isDefault" andValue:[m_pAddrDetail getFieldValue:@"isDefault"]];
        [m_originalAddrDetail addFieldObj:@"provinceName" andValue:[m_pAddrDetail getFieldValue:@"provinceName"]];
        [m_originalAddrDetail addFieldObj:@"cityName" andValue:[m_pAddrDetail getFieldValue:@"cityName"]];
        [m_originalAddrDetail addFieldObj:@"countyName" andValue:[m_pAddrDetail getFieldValue:@"countyName"]];
        [m_originalAddrDetail addFieldObj:@"countyId" andValue:[m_pAddrDetail getFieldValue:@"countyId"]];
        [m_originalAddrDetail addFieldObj:@"cityId" andValue:[m_pAddrDetail getFieldValue:@"cityId"]];
    }
}

-(void) initEditInfo
{
    m_addressId = [m_pAddrDetail getFieldValue:@"id"];
    m_strContact = [m_pAddrDetail getFieldValue:@"contact"];
    m_strAddress = [m_pAddrDetail getFieldValue:@"address"];
    m_strMobile = [m_pAddrDetail getFieldValue:@"mobile"];
    m_strPhone = [m_pAddrDetail getFieldValue:@"phone"];
    m_strZipCode = [m_pAddrDetail getFieldValue:@"zipCode"];
    
    NSString *strDistrict = @"";
    if ([m_pAddrDetail getFieldValue:@"provinceName"]) {
        strDistrict = [strDistrict stringByAppendingString:[m_pAddrDetail getFieldValue:@"provinceName"]];
        strDistrict = [strDistrict stringByAppendingString:@" "];
    }
    if ([m_pAddrDetail getFieldValue:@"cityName"]) {
        strDistrict = [strDistrict stringByAppendingString:[m_pAddrDetail getFieldValue:@"cityName"]];
        strDistrict = [strDistrict stringByAppendingString:@" "];
    }
    if ([m_pAddrDetail getFieldValue:@"countyName"]) {
        strDistrict = [strDistrict stringByAppendingString:[m_pAddrDetail getFieldValue:@"countyName"]];
    }
    
    UILabel *lblDistrict = (UILabel *)[self.view viewWithTag:1007];
    lblDistrict.text = strDistrict;
    
    _strDistrictFullName = strDistrict;
    m_isDefault = [[m_pAddrDetail getFieldValue:@"isDefault"] intValue];
    _strCountryId = [m_pAddrDetail getFieldValue:@"countyId"];
}

#pragma mark - 选择省市区按钮
- (void)onSelectDistrictButtonClick:(id)sender
{
    /*
    ProvinceListViewController *provinceListView = [[ProvinceListViewController alloc] init];
    [self.navigationController pushViewController:provinceListView animated:YES];*/
}


#pragma mark - 保存
-(void)actionInfoSaveButton:(id)sender
{
    if(m_pCurEditingField)
    {
        [m_pCurEditingField resignFirstResponder];
    }
    
    if(m_pCurTextViewField)
    {
        [m_pCurTextViewField resignFirstResponder];
    }
    
    
    _strDistrictFullName = [_strDistrictFullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (m_strContact.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人姓名！" duration:1.0];
        return;
    }
    
    NSPredicate *phoneTest;
    NSString *phoneRegex;
    if(m_strMobile.length > 0)
    {
        //手机号以1开头，11位的手机号码
        phoneRegex = @"^1\\d{10}$";
        phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        if([phoneTest evaluateWithObject:m_strMobile] == FALSE)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
            return ;
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码!" duration:1.8];
        return;
    }
    
    
    if (m_strContact.length > 40)
    {
        [SVProgressHUD showErrorWithStatus:@"您输入的联系人资料文字内容过长，请检查后重新输入!" duration:2.0];
        return;
    }
    
    if (_strDistrictFullName.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在地区!" duration:1.0];
        return;
    }
    
    if (m_strAddress.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址!" duration:1.0];
        return;
    }
    
    if(m_strAddress.length > 100)
    {
        [SVProgressHUD showErrorWithStatus:@"您输入的地址资料文字内容过长，请检查后重新输入!" duration:1.0];
        return;
    }
    

    /*
    if(m_strPhone.length > 0)
    {
        bool isPhoneState = false;
        
        if([m_strPhone hasPrefix:@"4"] == YES || [m_strPhone hasPrefix:@"8"] == YES) ////400或者800电话，长度都为10位
        {
            phoneRegex = @"^\\d{10}$";
            phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
            if([phoneTest evaluateWithObject:m_strPhone] == YES)
            {
                isPhoneState = true;
            }
        }
        else if ([m_strPhone hasPrefix:@"1"]) ////判断为手机号码，长度为11位即可
        {
            phoneRegex = @"^1\\d{10}$";
            phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
            if([phoneTest evaluateWithObject:m_strPhone] == YES)
            {
                isPhoneState = true;
            }
        }
        else if ([strPhone hasPrefix:@"0"] == YES) ////带区号的电话号码
        {
            phoneRegex = @"^\\d+$";
            phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
            if([phoneTest evaluateWithObject:m_strPhone] == YES)
            {
                if((m_strPhone.length < 11) || (m_strPhone.length > 18))
                {
                    isPhoneState = false;
                }
                else
                {
                    isPhoneState = true;
                }
            }
        }
        else
        {
            
        }
        
        if (isPhoneState == false)
        {
            [SVProgressHUD showErrorWithStatus:@"固定电话的格式不正确！" duration:1.0];
            return;
        }
    }
    */
    NSString *zipRegex = @"^\\d{6}$";
    NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zipRegex];
    if ([m_strZipCode length] > 0)
    {
        if([zipTest evaluateWithObject:m_strZipCode] == FALSE)
        {
            [SVProgressHUD showErrorWithStatus:@"请填写正确的邮政编码！"];
            return ;
        }
    }

    
    if (m_iEditType == 1) {
        [self requestAddAddressInfo_Web];
    }
    else if (m_iEditType == 2) {
        [self requestEditAddressInfo_Web];
    }
}

#pragma mark - 服务器接口
- (void)requestAddAddressInfo_Web
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType = 1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    
    [httpHelper setMethodName:@"order.addShippingAddr"];
    
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    
    [httpHelper addParam:m_strContact forName:@"contact"];
    [httpHelper addParam:m_strAddress forName:@"address"];
    [httpHelper addParam:m_strPhone forName:@"phone"];
    [httpHelper addParam:m_strMobile forName:@"mobile"];
    [httpHelper addParam:m_strZipCode forName:@"zipCode"];
    
    [httpHelper addParam:[NSString stringWithFormat:@"%d", m_isDefault] forName:@"isDefault"];
    
    [httpHelper addParam:_strCountryId forName:@"countyId"];
    
    [httpHelper setCompleteBlock:^(id dataSet){
        if (dataSet) {
            if ([dataSet getOpeResult]) {
                [SVProgressHUD showSuccessWithStatus:@"地址添加成功" duration:1.8];
                [self actionEndUserAddrInfoEditPageView];
                //返回
                [self performSelector:@selector(backNavButtonAction:) withObject:self afterDelay:1.8];
                
            }
            else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"地址添加失败:%@",[dataSet getErrorText]] duration:1.0];
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.0];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
    
    [httpHelper start];
}

//修改地址
- (void)requestEditAddressInfo_Web
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType = 1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    [self initCountyId];
    [httpHelper setMethodName:@"order.modShippingAddr"];
    //设置参数，顺序可以随意
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    [httpHelper addParam:m_addressId forName:@"addressId"];
    
    [httpHelper addParam:m_strContact forName:@"contact"];
    [httpHelper addParam:m_strAddress forName:@"address"];
    [httpHelper addParam:m_strPhone forName:@"phone"];
    [httpHelper addParam:m_strMobile forName:@"mobile"];
    [httpHelper addParam:m_strZipCode forName:@"zipCode"];
    [httpHelper addParam:[NSString stringWithFormat:@"%d", m_isDefault] forName:@"isDefault"];
    [httpHelper addParam:_strCountryId forName:@"countyId"];
    
    [httpHelper setCompleteBlock:^(id dataSet){
        if (dataSet) {
            if ([dataSet getOpeResult]) {
                [SVProgressHUD showSuccessWithStatus:@"地址修改成功" duration:1.8];
                [self actionEndUserAddrInfoEditPageView];
                //返回
                [self performSelector:@selector(backNavButtonAction:) withObject:self afterDelay:1.8];
                //[self backNavButtonAction:nil];
                /*
                if(_iViewShowType == 2)
                {
                    [self backNavButtonAction:nil];
                }
                else
                {
                    [self actionDetailStoreInfo:nil];
                }*/
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"地址修改失败" duration:1.0];
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.0];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
    
    [httpHelper start];
}

-(void) initCountyId
{
    if (_strDistrictFullName.length != 0 && _strCountryId.length ==0)
    {
       NSString* countyId = [m_pAddrDetail getFieldValue:@"countyId"];
       if (countyId.length ==0)
       {
            NSString* cityId = [m_pAddrDetail getFieldValue:@"cityId"];
            _strCountryId = cityId;
       }
    }
}

-(void) setEnable:(UIControl*) clickView
{
    if (_blEditing == false)
    {
        clickView.enabled = false;
    }
    else
    {
        clickView.enabled = true;
    }
}



#pragma UITableViewDelegate

//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        return 64;
    }
    
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}



//收货地址空白项的TableViewCell
-(UITableViewCell*)getAddrNoContentTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strAddrNoContentCellID = @"AddrNoContentCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strAddrNoContentCellID];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strAddrNoContentCellID];
        
        pCellObj.contentView.backgroundColor = COLOR_VIEW_BACKGROUND;

        UIImageView *pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 19, 320, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
        pCellObj.selectionStyle = UITableViewCellAccessoryNone;
        
    }
    
    
    return pCellObj;
}

//收货地址包含textfield的TableViewCell
-(UITableViewCell*)getAddrTextFieldTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strAddrTextFieldCellID = @"AddrTextFieldCellId";
    int iRow = indexPath.row ;
    NSInteger tag = 0;
    switch (iRow)
    {
        case 0:
            tag = 1000;
            break;
        case 1:
            tag = 1001;
            break;
        case 2:
            tag = 1002;
            break;
        case 3:
            tag = 1003;
            break;
        case 4:
            tag = 1004;
            break;
        default:
            break;
    }
    
    UITableViewCell *pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strAddrTextFieldCellID];
    
    pCellObj.contentView.backgroundColor = [UIColor whiteColor];
    pCellObj.selectionStyle = UITableViewCellAccessoryNone;
    
    //title
    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    pLabel.textColor = [UIColor blackColor];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.font =[UIFont systemFontOfSize:14];
    pLabel.textAlignment = UITextAlignmentLeft;
    [pCellObj.contentView addSubview:pLabel];
    

    
    //线条
    UIImageView *pLineView = pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [pCellObj.contentView addSubview:pLineView];
    
    //具体消息的内容
    UITextField *pTextField = nil;
    UITextView *pTextView = nil;
    if (iRow != 3)
    {
        pTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, 220, 20)];
        pTextField.textColor = COLOR_FONT_1;//[UIColor lightGrayColor];
        pTextField.backgroundColor = [UIColor clearColor];
        pTextField.font =[UIFont systemFontOfSize:14];
        pTextField.textAlignment = UITextAlignmentLeft;
        pTextField .returnKeyType = UIReturnKeyDone;
        pTextField.tag = tag;
        [pCellObj.contentView addSubview:pTextField];
        pTextField.delegate = self;
        [pTextField addTarget:self action:@selector(hiddenKeyBoard) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self setEnable:pTextField];
        
        pLineView.frame = CGRectMake(0, 39, 320, 1);
    }
    else
    {
        pTextView = [[UITextView alloc] initWithFrame:CGRectMake(90, 0, 220, 58)];
        pTextView.textColor = [UIColor lightGrayColor];
        pTextView.backgroundColor = [UIColor clearColor];
        pTextView.font =[UIFont systemFontOfSize:14];
        pTextView.textAlignment = UITextAlignmentLeft ;
        pTextView .returnKeyType = UIReturnKeyDone;
        pTextView.tag = tag;
        [pCellObj.contentView addSubview:pTextView];
        pTextView.delegate = self;
        if(m_strAddress.length < 1)
        {
            pTextView.text = @"详细地址（必填）";
            pTextView.textColor = COLOR_FONT_2;
        }
        else
        {
            pTextView.text = m_strAddress;
            pTextView.textColor = COLOR_FONT_1;
        }
        
        if (_blEditing == false)
        {
            pTextView.editable = false;
        }
        else
        {
            pTextView.editable = true;
        }
       // [self setEnable:pTextView];
        
        pLineView.frame = CGRectMake(0, 63, 320, 1);
    }
    
    [pTextField setValue:COLOR_FONT_2 forKeyPath:@"_placeholderLabel.textColor"];
    switch (iRow)
    {
        case 0:
            pLabel.text = @"收货人";
            pTextField.text = m_strContact;
            pTextField.placeholder = @"姓名（必填）";
            break;
        case 1:
            pLabel.text = @"手机号";
            pTextField.text = m_strMobile;
            pTextField.placeholder = @"手机号（必填）";
            pTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            /*
        case 3:
            pLabel.text = @"固定电话";
            pTextField.text = strPhone;
            pTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;*/
        case 3:
            pLabel.text = @"详细地址";
//            pTextField.text = strAddress;
            break;
            
        case 4:
            pLabel.text = @"邮政编码";
            pTextField.text = m_strZipCode;
            pTextField.placeholder = @"邮编（不是必填项）";
            pTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }
    
    return pCellObj;
    
}

-(void) hiddenKeyBoard
{
    UITextField *inputField = (UITextField *)[self.view viewWithTag:1000];
    if (inputField.isFirstResponder) {
        [inputField resignFirstResponder];
    }
    inputField = (UITextField *)[self.view viewWithTag:1001];
    if (inputField.isFirstResponder) {
        [inputField resignFirstResponder];
    }
    inputField = (UITextField *)[self.view viewWithTag:1002];
    if (inputField.isFirstResponder) {
        [inputField resignFirstResponder];
    }
    UITextView *pUiTextView = (UITextView *)[self.view viewWithTag:1003];
    if (pUiTextView.isFirstResponder) {
       [pUiTextView resignFirstResponder];
    }
    inputField = (UITextField *)[self.view viewWithTag:1004];
    if (inputField.isFirstResponder) {
       [inputField resignFirstResponder];
    }

}

-(UITableViewCell*)getAddrAreaTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strAddrAreaCellID = @"AddrAreaCellId";
    UITableViewCell *pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strAddrAreaCellID];
    
    //pCellObj.
    
    pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
    pCellObj.selectionStyle = UITableViewCellAccessoryNone;
    
    //title
    UILabel* pLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    pLabel1.textColor = [UIColor blackColor];
    pLabel1.backgroundColor = [UIColor clearColor];
    pLabel1.font =[UIFont systemFontOfSize:14];
    pLabel1.textAlignment = UITextAlignmentLeft;
    [pCellObj.contentView addSubview:pLabel1];
    
    CGSize labelSize = {0, 0};
    
    labelSize = [_strDistrictFullName sizeWithFont:[UIFont systemFontOfSize:14]
                                       constrainedToSize:CGSizeMake(220, 5000)
                                       lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *pLabel2 = nil;
    if (labelSize.height > 20)
    {
        //所在地区的内容
        pLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 195, 40)];
    }
    else
    {
        pLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 195, 20)];
    }
    
 
    pLabel2.textColor = [UIColor lightGrayColor];
    pLabel2.backgroundColor = [UIColor clearColor];
    pLabel2.font =[UIFont systemFontOfSize:14];
    pLabel2.numberOfLines = 0;
    pLabel2.textAlignment = UITextAlignmentLeft;
    pLabel2.tag = 1007;
    [pCellObj.contentView addSubview:pLabel2];
    
    //线条
    UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [pCellObj.contentView addSubview:pLineView];
    
    
    //右边箭头
    UIImageView* pArrowView =[[UIImageView alloc] initWithFrame:CGRectMake(300, 14, 12, 12)];
    pArrowView.image = [UIImage imageNamed:@"cell_arrow.png"];
    [pCellObj.contentView addSubview:pArrowView];
    

    
    NSString* strTitle = @"";
    int iRow = indexPath.row ;
    if(iRow == 2)
    {
        strTitle = @"所在地区";
        pLabel1.text = strTitle;
        if(_strDistrictFullName.length < 1)
        {
            pLabel2.text = @"点击选择所在地区";
            pLabel2.textColor = COLOR_FONT_2;
        }else
        {
            pLabel2.text = _strDistrictFullName;
            pLabel2.textColor = COLOR_FONT_1;
        }
        
    }

    return pCellObj;
    
}

//收货地址的默认收货地址的tablecell
-(UITableViewCell*)getAddrSetDefaultTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strAddrSetDefaultCellID = @"AddrSetDefaultCellId";
    UITableViewCell *pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strAddrSetDefaultCellID];
    
    pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
    pCellObj.selectionStyle = UITableViewCellAccessoryNone;
    
    //title
    UIButton *pButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    
    pButton.contentHorizontalAlignment = TRUE;
    pButton.contentVerticalAlignment = TRUE;
    pButton.tag = 1011;
    [pButton setBackgroundImage:[UIImage imageNamed:@"checkbox_nil"] forState:UIControlStateNormal];
    [pButton setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
    [pButton addTarget:self action:@selector(onCheckedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [pCellObj.contentView addSubview:pButton];
    
    //设置为收货地址的内容
    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 10, 150, 20)];
    pLabel.textColor = [UIColor lightGrayColor];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.font =[UIFont systemFontOfSize:14];
    pLabel.numberOfLines = 0;
    pLabel.textAlignment = UITextAlignmentLeft;
    [pCellObj.contentView addSubview:pLabel];
    
    NSString* strTitle = @"";
    if(indexPath.row == 5)
    {
        strTitle = @"设置为默认收货地址";
        pLabel.text = strTitle;

        if (m_isDefault == 1)
        {
            pButton.selected = TRUE;
            m_isDefault = 1;
        }
        else
        {
            pButton.selected = FALSE;
        }
    }
    return pCellObj;
}

-(void)onCheckedButtonClicked:(id)sender
{
    if (_blEditing == false)
    {
        return;
    }
    
    UITableViewCell *pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    if(pCellObj == nil)
        return;
    
    
    NSIndexPath *indexPath = [_uiAddrTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    
    UIButton *pButton = (UIButton *)[pCellObj.contentView viewWithTag:1011];
    if (pButton) {
        pButton.selected = !pButton.selected;
    }
    
    if(m_isDefault == 0)
    {
        m_isDefault = 1;
    }
    else
    {
         m_isDefault = 0;
    }
    [self hiddenKeyBoard];
}

//加载cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *pCellObj = nil;
    if (indexPath.row == 2)
        pCellObj = [self getAddrAreaTableCell:tableView indexPath:indexPath];
    else if (indexPath.row == 5)
        pCellObj = [self getAddrSetDefaultTableCell:tableView indexPath:indexPath];
    else
        pCellObj = [self getAddrTextFieldTableCell:tableView indexPath:indexPath];
    
    return pCellObj;
	}


//didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int iRow = indexPath.row;
    if (_blEditing == false)
    {
        return;
    }
    
    if (iRow == 2)//地区
    {
        [self onSelectDistrictButtonClick:nil];
    }
    else if (iRow == 5)//设置默认收货地址
    {
        UITableViewCell* pCellObj = [tableView cellForRowAtIndexPath:indexPath];
        
        UIButton *pButton = (UIButton *)[pCellObj.contentView viewWithTag:1011];
        [self onCheckedButtonClicked:pButton];
    }
    else
    {
        [self hiddenKeyBoard];
    }
}

#pragma mark UITextFieldDelegate
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int tag = textField.tag;
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (tag)
    {
        case 1000: //收货人姓名
            if (temp.length > 40)
                return  NO;
            break;
        case 1001://手机号码
            if (temp.length > 11)
            {
                return NO;
            }
            break;
        case 1002://固定电话
            if (temp.length > 16)
            {
                return NO;
            }
            break;
        case 1003://街道地址
            if (temp.length > 100)
            {
                return NO;
            }
            break;
        case 1004://邮政编码
            if (temp.length > 6)
            {
                return NO;
            }
            break;
        default:
            break;
    }
    return YES;
}
*/
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if (_blEditing == false)
        return ;
    
    int tag = textField.tag;
    NSString *temp = textField.text;
    switch (tag)
    {
        case 1000: //收货人姓名
            m_strContact = temp;
            break;
        case 1001://手机号码
            m_strMobile = temp;
            break;
        case 1002://固定电话
            m_strPhone = temp;
            break;
        case 1003://街道地址
            m_strAddress = temp;
            break;
        case 1004://邮政编码
            m_strZipCode = temp;
            break;
        default:
            break;
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_pCurEditingField = textField;
    m_pCurTextViewField = nil;
    /*
    int tag = textField.tag;
    CGPoint curPoint = CGPointMake(0.0, 0);
    switch (tag)
    {
        case 1000: //收货人姓名
            curPoint = CGPointMake(0.0, 30.0);
            break;
        case 1001://手机号码
            curPoint = CGPointMake(0.0, 30.0 + 40);
            break;
        case 1002://固定电话
            curPoint = CGPointMake(0.0, 30.0 + 40 * 2);
            break;
        case 1003://街道地址
            curPoint = CGPointMake(0.0, 30.0 * 2 + 40 * 4);
            break;
        case 1004://邮政编码
            curPoint = CGPointMake(0.0, 30.0 * 2 + 40 * 5);
            break;
        default:
            break;
    }
    
    if (curPoint.y != 0)
        [_uiAddrTableView setContentOffset:curPoint animated:YES];
     */
    

    
    
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    m_pCurEditingField = nil;
    m_pCurTextViewField = textView;

    if([textView.text isEqualToString:@"详细地址（必填）"] == true)
    {
        textView.text = @"";
        textView.textColor = COLOR_FONT_1;
    }

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    m_pCurEditingField = nil;
    m_pCurTextViewField = textView;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    if(textView.text.length > 0)
    {
        m_strAddress = textView.text;
    }
    else
    {
        textView.text = @"详细地址（必填）";
        textView.textColor = COLOR_FONT_2;
        m_strAddress = @"";
    }
    
    if([textView.text isEqualToString:@""])
    {
        textView.text = @"详细地址（必填）";
    }
    [self hiddenKeyBoard];
}

-(void)actionEndUserAddrInfoEditPageView
{
    if(_pCellDelegate == nil)
    {
        return;
    }
    if([_pCellDelegate respondsToSelector:@selector(actionEndUserAddrInfoEditPageView)])
    {
        [_pCellDelegate actionEndUserAddrInfoEditPageView];
    }
}


@end
