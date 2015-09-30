//
//  MoreFeedbackInfoPageView.m
//  更多 - 意见反馈
//
//  Created by lzq on 2014-11-26.

//

#import "MoreFeedbackInfoPageView.h"
#import <QuartzCore/QuartzCore.h>
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"

@interface MoreFeedbackInfoPageView ()

@end

@implementation MoreFeedbackInfoPageView

@synthesize m_uiMainTableView = _uiMainTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       // m_iCurPageID = 0;
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
}

//
- (void)viewDidLoad
{

    //标题
    self.navigationItem.titleView  = [UIOwnSkin navibarTitleView:@"用户反馈" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //导航返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    //
    _uiMainTableView = nil;
    m_callWebView = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.

}

-(void)viewWillAppear:(BOOL)animated
{
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"请先登录！" duration:1.8];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //注册键盘事件
    [self registerForKeyboardNotifications];
    if(_uiMainTableView != nil)
        return;
    
    CGRect rcTable = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
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
    [self.view addSubview:_uiMainTableView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    //注销键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    m_isRegKeyboardEvent = NO;
    
}


- (void)backNavButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];    
}

//注册键盘事件
- (void)registerForKeyboardNotifications
{
    
    if(m_isRegKeyboardEvent == YES)
        return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

//键盘弹出时的相关处理
- (void)keyboardWillShow:(NSNotification*)aNotification
{

    if(m_pTapGesture == nil)
    {
        m_pTapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [self.view addGestureRecognizer:m_pTapGesture];
    }
    
    
}
-(void)hiddenKeyBoard
{
    if(m_uiDespTextView)
    {
        [m_uiDespTextView resignFirstResponder];
    }
    
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    if(m_uiDespTextView)
    {
        [m_uiDespTextView resignFirstResponder];
        m_uiDespTextView = nil;
    }
    if(m_pTapGesture != nil)
    {
        [self.view removeGestureRecognizer:m_pTapGesture];
        m_pTapGesture  = nil;
    }
    
}



//多行文本框编辑事件
-(void)onTextViewEndChanged:(id)sender
{
    if(m_uiDespTextView == nil)
        return;
    [m_uiDespTextView resignFirstResponder];
    NSString* strText = m_uiDespTextView.text;
    m_strInputMemoInfo = strText;
    
    if(strText.length == 0)
    {
        m_uiDespTextView.textColor = [UIColor lightGrayColor];
        m_uiDespTextView.text = FEEDBACK_MEMO_DEFAULT;
        m_strInputMemoInfo = @"";
    }
    m_uiDespTextView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
}

//商品描述信息输入时的字符检测
-(void)onTextViewBeginChanged:(id)sender
{
    if(m_uiDespTextView == nil)
        return;
    m_uiDespTextView.layer.borderColor = COLOR_BTN_BORDER_2.CGColor;
    NSString* strText = m_uiDespTextView.text;
    if([strText isEqualToString:FEEDBACK_MEMO_DEFAULT])
    {
        m_uiDespTextView.textColor = COLOR_FONT_2;
        m_uiDespTextView.text = @"";
    }
    
}

-(void)onTextViewEditingChanged:(id)sender
{
    if(m_uiDespTextView == nil)
        return;
    bool blSend = NO;
    m_strInputMemoInfo = m_uiDespTextView.text;
    if(m_strInputMemoInfo.length > 0)
    {
        if([m_strInputMemoInfo isEqualToString:FEEDBACK_MEMO_DEFAULT] == NO)
            blSend = YES;
    }
    if(blSend == YES)
    {
        [UIOwnSkin setButtonBackground:m_uiSendMsgButton andColor:COLOR_BTN_BORDER_2];
        m_uiSendMsgButton.enabled = YES;
    }
    else
    {
        [UIOwnSkin setButtonBackground:m_uiSendMsgButton andColor:COLOR_BTN_BORDER_1];
        m_uiSendMsgButton.enabled = NO;
    }
}


-(void)onSendFeedbackMsgClicked:(id)sender
{
    [self hiddenKeyBoard];
    if(m_strInputMemoInfo.length < 1)
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入您的宝贵意见！" duration:1.8];
        return;
    }
    
    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    

    [pHttpHelper setMethodName:[NSString stringWithFormat:@"memberInfo/saveSuggestion"]];
    [pHttpHelper addParam:m_strInputMemoInfo forName:@"tsuggestion.content"];
    
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];

         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
         if(pDataSet)
         {
            if([pDataSet getOpeResult] == NO)
            {
                NSString* strMessage = [pDataSet getFeildValue:0 andColumn:@"message"];
                [SVProgressHUD showErrorWithStatus:strMessage duration:1.8];
                return;
            }
         }
         
         [SVProgressHUD showSuccessWithStatus:@"发送成功！" duration:1.8];
         
         [self performSelector:@selector(sysBackToParentView) withObject:self afterDelay:1.5];
         
     }];
    
    //开始时执行的block
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];

    [pHttpHelper start];

}

-(void)sysBackToParentView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionCallOutClicked:(id)sender
{
    NSString* strLinkTel= @"tel:4008705800";
    
    if (!m_callWebView)
    {
        m_callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        m_callWebView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        [self.view addSubview:m_callWebView];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strLinkTel]];
    [m_callWebView loadRequest:request];
}

#pragma UITableViewDataSource,UITableViewDelegate

//点击促销记录的相关处理（暂时不需要处理）
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{


}


//每个section为200高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 160;
}

//返回section的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

//每个section为1行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return  1;
 
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
    static NSString *strFeedbackTextViewCellId = @"FeedbackTextViewCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strFeedbackTextViewCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strFeedbackTextViewCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        m_uiDespTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, 70)];
        m_uiDespTextView.tag = 1001;
        m_uiDespTextView.font = [UIFont systemFontOfSize:12.0];
        m_uiDespTextView.backgroundColor = [UIColor clearColor];
        m_uiDespTextView.textAlignment  = UITextAlignmentLeft;
        m_uiDespTextView.textColor = COLOR_FONT_2;
        m_uiDespTextView.keyboardType  =UIKeyboardTypeDefault;
        m_uiDespTextView.returnKeyType = UIReturnKeyDone;
        m_uiDespTextView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        m_uiDespTextView.layer.cornerRadius = 5.0f;
        m_uiDespTextView.layer.borderWidth = 1.0f;
        m_uiDespTextView.text = FEEDBACK_MEMO_DEFAULT;
        [pCellObj.contentView addSubview:m_uiDespTextView];
        
        //输入完成事件
      //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewEndChanged:) name: UITextViewTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewEndChanged:) name: UITextViewTextDidEndEditingNotification object:nil];
        //输入开始事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewBeginChanged:) name: UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewEditingChanged:) name: UITextViewTextDidChangeNotification object:nil];
        //
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(15, 90, self.view.frame.size.width-30, 30);
        pButton.tag = 3001;
        [pButton addTarget:self action:@selector(actionCallOutClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width-30, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        //pLable.textColor = COLOR_FONT_2;
        pLable.tag = 1001;
        pLable.attributedText = [AppInitDataMethod getLabelAttributedString:@"如有疑问，可直接拨打客服热线 400-870-5800" andLight:@"400-870-5800" andColor:COLOR_FONT_6];
        [pButton addSubview:pLable];
        
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 21, 80, 1)];
        pLineView.backgroundColor = COLOR_FONT_6;
        [pButton addSubview:pLineView];
        
        //确认投标的按钮
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(15, 120, self.view.frame.size.width-30, 35);
        pButton.tag = 3002;
        
        [pButton addTarget:self action:@selector(onSendFeedbackMsgClicked:) forControlEvents:UIControlEventTouchUpInside];
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_1];
        [pButton setTitle:@"发送" forState:UIControlStateNormal];
        m_uiSendMsgButton = pButton;
        pButton.enabled = NO;
        [pCellObj.contentView addSubview:pButton];
        
        
    }
    
    return pCellObj;
	
}
@end
