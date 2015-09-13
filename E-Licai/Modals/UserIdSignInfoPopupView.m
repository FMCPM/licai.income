//
//  UserIdSignInfoPopupView.m

//  我的叮叮 - 支付身份信息确认
//
//  Created on 2014-11-20.
//

#import "UserIdSignInfoPopupView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"


@interface UserIdSignInfoPopupView ()

@end

@implementation UserIdSignInfoPopupView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_pSignInfoDelegate = _pSignInfoDelegate;

-(id)initWithFrame:(CGRect)rTable andName:(NSString*)strName andId:(NSString*)strCardId
{
    CGRect  frame = [[UIScreen mainScreen] bounds];

    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView* pBkView = [[UIImageView alloc] initWithFrame:frame];
        pBkView.backgroundColor = [UIColor darkGrayColor];
        pBkView.alpha = 0.4;
        [self addSubview:pBkView];
        
        m_strUserCardId = strCardId;
        m_strUserReallyName = strName;
        
        int iTopY = (frame.size.height - rTable.size.height) / 2 - 40;
        int iLeftX = (frame.size.width - rTable.size.width)/2;
        CGRect rcTable = CGRectMake(iLeftX, iTopY, rTable.size.width, rTable.size.height);
        _uiMainTableView = [[UITableView alloc]initWithFrame:rcTable style:UITableViewStylePlain];
        _uiMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _uiMainTableView.separatorColor = [UIColor clearColor];
        _uiMainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _uiMainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _uiMainTableView.showsHorizontalScrollIndicator = NO;
        _uiMainTableView.showsVerticalScrollIndicator = NO;
        _uiMainTableView.backgroundColor = [UIColor whiteColor];
        _uiMainTableView.dataSource = self;
        _uiMainTableView.delegate = self;
        _uiMainTableView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        _uiMainTableView.layer.borderWidth = 1.0f;
        _uiMainTableView.layer.cornerRadius = 5.0f;
        
        [self addSubview:_uiMainTableView];
        
        [self registerForKeyboardNotifications];
    }
    return self;
    

}

//注册键盘事件
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)removeKeyboardNotifications
{
    //注销键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


//键盘弹出时的相关处理
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    
    if(m_pTapGesture == nil)
    {
        m_pTapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [self addGestureRecognizer:m_pTapGesture];
    }
    //不需要控制视图被键盘遮住的处理
     NSDictionary* info = [aNotification userInfo];
     CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
     CGFloat activeOffset = _uiMainTableView.frame.origin.y + _uiMainTableView.frame.size.height;
     CGFloat kbOffset = self.frame.size.height - kbSize.height;
     
     m_offsetToMove = 0;
     if (activeOffset > kbOffset)
     {
         m_offsetToMove = activeOffset - kbOffset + 10;
         //[_uiMainTableView setContentOffset:CGPointMake(0, _uiMainTableView.contentOffset.y + m_offsetToMove) animated:YES];
         
         CGRect rcTable = _uiMainTableView.frame;
         rcTable.origin.y = rcTable.origin.y - m_offsetToMove;
         _uiMainTableView.frame = rcTable;
     
     }
   
    
}
-(void)hiddenKeyBoard
{
    if(m_uiCurEditingField)
    {
        [m_uiCurEditingField resignFirstResponder];
    }
    
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    [self hiddenKeyBoard];
    if(m_pTapGesture != nil)
    {
        [self removeGestureRecognizer:m_pTapGesture];
        m_pTapGesture  = nil;
    }
    CGRect rcTable = _uiMainTableView.frame;
    rcTable.origin.y = rcTable.origin.y + m_offsetToMove;
    _uiMainTableView.frame = rcTable;
    m_offsetToMove = 0;
}



//点击完成等结束编辑
-(void)actionTextFieldEditingDidEndExit:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    [pTextField resignFirstResponder];

}

//开始编辑
-(void)actionTextFieldEditingDidBegin:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    m_uiCurEditingField = pTextField;
}

//完成编辑
-(void)actionTextFieldEditingDidEnd:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    [pTextField resignFirstResponder];
    
    if(pTextField.tag == 1001)
    {
        m_strUserReallyName = pTextField.text;
    }
    else
    {
        m_strUserCardId = pTextField.text;
    }
}



//保存身份证信息
-(void)actionInfoSignNextClicked:(id)sender
{
    [self hiddenKeyBoard];
    
    if(m_strUserReallyName.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的真实姓名！" duration:1.8];
        return;
    }
    

    if(m_strUserCardId.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的18位身份证号码！" duration:1.8];
        return;
    }
    
    if(m_strUserCardId.length != 18)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的身份证号码位数有误！" duration:1.8];
        return;
    }
    
    if(_pSignInfoDelegate == nil)
        return;
    if([_pSignInfoDelegate respondsToSelector:@selector(onUserIdSignInfoClicked:andName:)])
    {
        [_pSignInfoDelegate onUserIdSignInfoClicked:m_strUserCardId andName:m_strUserReallyName];
    }
    
}

#pragma UITableViewDataSource,UITableViewDelegate

//didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}


//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        return 100;
    }
    return 45;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


//具体选择银行，以及输入银行信息的Cell
-(UITableViewCell *)getUserSignInfoInputCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strUserSignInfoInputCellId = @"UserSignInfoInputCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strUserSignInfoInputCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strUserSignInfoInputCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int iCellWidth = _uiMainTableView.frame.size.width;
        
        UIView* pBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, iCellWidth-20, 80)];
        pBackView.backgroundColor = COLOR_VIEW_BK_05;
        pBackView.layer.borderWidth = 1.0f;
        pBackView.layer.cornerRadius = 5.0f;
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        
        [pCellObj.contentView addSubview:pBackView];
        
        //中间线
        UIImageView*pLineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, iCellWidth-20, 1)];
        pLineView.backgroundColor = COLOR_BTN_BORDER_1;
        [pBackView addSubview:pLineView];
        
        
        //用户的真实姓名
        UIImageView* pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 16, 16)];
        pLogoImgView.image = [UIImage imageNamed:@"icon_form_user.png"];
        [pBackView addSubview:pLogoImgView];
   
        UITextField*pTextField = [[UITextField alloc] initWithFrame:CGRectMake(36, 5, iCellWidth-20-45, 30)];
        pTextField.font  = [UIFont systemFontOfSize:14];
        pTextField.textColor = COLOR_FONT_1;
        pTextField.textAlignment  = UITextAlignmentLeft;
        pTextField.tag  = 1001;
        pTextField.placeholder = @"请填写您的真实姓名";
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
        
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
       // [pTextField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [pBackView addSubview:pTextField];
        
        

        //身份证
        pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 52, 16, 16)];
        pLogoImgView.image = [UIImage imageNamed:@"icon_select_bank.png"];
        [pBackView addSubview:pLogoImgView];
        
        //输入
        pTextField = [[UITextField alloc] initWithFrame:CGRectMake(36, 45, iCellWidth-20-45, 30)];
        pTextField.font  = [UIFont systemFontOfSize:14];
        pTextField.textColor = COLOR_FONT_1;
        pTextField.textAlignment  = UITextAlignmentLeft;
        pTextField.tag  = 1002;
        pTextField.placeholder = @"请填写18位身份证号码";
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
        pTextField.keyboardType = UIKeyboardTypeDefault;
        pTextField.returnKeyType = UIReturnKeyDone;
        
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
      //   [pTextField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
        [pBackView addSubview:pTextField];
        
    }

    UITextField* pTextField1 = (UITextField*)[pCellObj.contentView viewWithTag:1001];
    UITextField* pTextField2 = (UITextField*)[pCellObj.contentView viewWithTag:1002];
    if(pTextField1 != nil)
        pTextField1.text = m_strUserReallyName;
    if(pTextField2 != nil)
        pTextField2.text = m_strUserCardId;
    return pCellObj;
}


//添加银行卡确认的button的Cell
-(UITableViewCell *)getSignNextButtonCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strSignNextButtonCellId = @"SignNextButtonCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strSignNextButtonCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strSignNextButtonCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.backgroundColor = [UIColor whiteColor];
        
        //
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 10, _uiMainTableView.frame.size.width-20, 35);
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pButton setTitle:@"确认支付" forState:UIControlStateNormal];
       // pButton.enabled = NO;
        pButton.tag = 3001;
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_2];
        [pButton addTarget:self action:@selector(actionInfoSignNextClicked:) forControlEvents:UIControlEventTouchUpInside];
        //m_uiNextSubmitButton = pButton;
        [pCellObj.contentView addSubview:pButton];
        
    }
    //信息设置
    
    return pCellObj;
}

//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *pCellObj = nil;

    if(indexPath.row == 0)
    {
        pCellObj = [self getUserSignInfoInputCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 1 )
    {
        pCellObj = [self getSignNextButtonCell:tableView cellForRowAtIndexPath:indexPath];
    }
    return pCellObj;
}


@end
