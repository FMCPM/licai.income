//
//  UserSendMessagePageView.m

//
//  Created by lzq on 2014-03-10.
//

#import "UserSendMessagePageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "CKHttpHelper.h"
#import "UIColor+Hex.h"
#import "UILabel+CKKit.h"
#import "CSjqMessageObj.h"

@interface UserSendMessagePageView ()

@end

@implementation UserSendMessagePageView

@synthesize m_uiMessageTable = _uiMessageTable;
@synthesize m_strFriendId = _strFriendId;
@synthesize m_uiSendView = _uiSendView;
@synthesize m_uiSendTextView = _uiSendTextView;
@synthesize m_pFriendHeadImage = _pFriendHeadImage;
@synthesize m_uiSendTextButton = _uiSendTextButton;
@synthesize m_strSessionId = _strSessionId;
@synthesize m_pOneMessageRowSet = _pOneMessageRowSet;
@synthesize m_iMessageType = _iMessageType;
@synthesize m_strFriendHeadImgUrl = _strFriendHeadImgUrl;

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
    self.navigationController.navigationBar.translucent = NO;

    NSString* strFriendDisName= _strFriendId;
    
    if(_iMessageType == 2)
        strFriendDisName  = @"系统消息";
    else if(_iMessageType == 3)
        strFriendDisName = @"公共消息";
    
    //标题为好友的账号
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:strFriendDisName andFrame:CGRectMake(0, 0, 100, 40)];
    
    //默认情况下，输入的信息为1行
    m_iTextLineCount = 1;
    //左边返回导航按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    if(_iMessageType == 1)
    {
      self.navigationItem.rightBarButtonItem  =[UIOwnSkin imageBtnTarget:@"navbar_delete.png" andTarget:self action:@selector(onDeleteAllMessages:) andWidth:19 andHeight:22];
    }

    //
    CGRect rcViewFrame = self.view.frame;
    if(IS_IPHONE_5)
    {
        rcViewFrame.size.height = 548 - 44;
    }
    else
    {
        rcViewFrame.size.height = 460 - 44;
    }
    
    self.view.frame = rcViewFrame;
    CGRect rcTableFrame = _uiMessageTable.frame;
    rcTableFrame.size.height = rcViewFrame.size.height - 40;
    rcTableFrame.origin.y = 0;
    _uiMessageTable.frame = rcTableFrame;
    
    CGRect rcSendFrame = _uiSendView.frame;
    rcSendFrame.origin.y = rcViewFrame.size.height-40;
    _uiSendView.frame = rcSendFrame;
    
    UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    pLineView.backgroundColor  =[UIColor lightGrayColor];
    [_uiSendView addSubview:pLineView];
    
    //发送按钮的样式设置
    [_uiSendTextButton setTitleColor:RGBCOLOR(221, 114, 76) forState:UIControlStateNormal];
    [_uiSendTextButton setTitleColor:RGBCOLOR(221, 114, 76) forState:UIControlStateHighlighted];
    _uiSendTextButton.layer.borderWidth = 1.0f;
    _uiSendTextButton.layer.borderColor = RGBCOLOR(221, 114, 76).CGColor;
    [_uiSendTextButton.layer setMasksToBounds:YES];
    _uiSendTextButton.layer.cornerRadius = 5.0f;
    

    //添加键盘隐藏和显示的观察，主要是避免挡住文字输入区域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [super viewDidLoad];
    
    _uiSendTextView.layer.borderWidth = 1.0f;
    _uiSendTextView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
    [_uiSendTextView.layer setMasksToBounds:YES];
    _uiSendTextView.layer.cornerRadius = 5.0f;
    _uiSendTextView.returnKeyType = UIReturnKeyDone;

    /*
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [_uiSendView addGestureRecognizer:singleFingerTap];*/
    
   // _uiSendTextView.scrollEnabled = NO;
    //当字体改变的时候，改变控件的高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageTextChanged:) name: UITextViewTextDidChangeNotification object:nil];
    //设置用户自己的头像图片
    m_pUserHeadImage = [UaConfiguration sharedInstance].m_pUserHeadImage;
    if(m_pUserHeadImage == nil)
    {
        m_pUserHeadImage = [UIImage imageNamed:@"unknowUserHead.png"];
    }
    m_iCurPageID = 0;
    m_isCanLoadMore = NO;
 
    //如果好友头像没有下载，则需要在后续下载头像图片
    if(_pFriendHeadImage == nil)
    {
        _pFriendHeadImage = [UIImage imageNamed:@"unknowUserHead.png"];        
    }
    else
    {
        _strFriendHeadImgUrl = @"";
    }
    //下载用户的信息
    [self getFriendSessionMsgList_Web];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//删除消息
-(void)onDeleteAllMessages:(id)sender
{

    if(m_pMsgDataSet == nil)
        return;
    if([m_pMsgDataSet getRowCount] < 1)
        return;
    
    UIAlertView* pAlterView = [[UIAlertView alloc] initWithTitle:@"删除确认" message:@"您确定要删除当前的消息记录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [pAlterView show];
}

-(void)viewWillAppear:(BOOL)animated
{
    int iCanSend = 1;
    if([_strFriendId isEqualToString:FROM_ID_SYSTEM] == true || [_strFriendId isEqualToString:FROM_ID_PUBLIC] == true)
        iCanSend  = 0;
    if(iCanSend == 1)
        return;
    
    CGRect rcTable = _uiMessageTable.frame;
    rcTable.size.height = self.view.frame.size.height;
    _uiMessageTable.frame = rcTable;
    [_uiSendView setHidden:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{

 }


-(IBAction)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
//
-(void)handleSingleTap:(id)sender
{
    
   [_uiSendTextView resignFirstResponder];
}

//输入消息后，自动调节相关的显示区域
-(void)onMessageTextChanged:(id)sender
{
    
    //计算字体的高度
    CGSize newSize = [[_uiSendTextView text] sizeWithFont:[_uiSendTextView font]];
    
    // 2. 取出文字的高度
    int iHeightPerLine = newSize.height;
    if(iHeightPerLine < 18)
        iHeightPerLine  =18;
    //3. 计算行数
    int iLineCount = _uiSendTextView.contentSize.height/iHeightPerLine;
    if(iLineCount == m_iTextLineCount)
        return;
    m_iTextLineCount = iLineCount;
    //每行15个像素
    CGRect rcTextView = _uiSendTextView.frame;

    //输入框的高度
    int iMoveHeight = 0;
    int iNewHeight = 30 +(m_iTextLineCount-1) * 18;
    iMoveHeight = iNewHeight - rcTextView.size.height;
    rcTextView.size.height = iNewHeight;
    //超过一定高度后，进行控制
    if(iMoveHeight >(_uiMessageTable.frame.size.height-40))
        return;
    //背景视图的高度
    CGRect rcBkView = _uiSendView.frame;
    rcBkView.size.height = rcTextView.size.height+10;
    rcBkView.origin.y = rcBkView.origin.y - iMoveHeight;
    //TableView视图的高度
    CGRect rcTableFrame = _uiMessageTable.frame;
    rcTableFrame.size.height = rcTableFrame.size.height - iMoveHeight;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [_uiSendView setFrame:rcBkView];
    [_uiSendTextView setFrame:rcTextView];
    [_uiMessageTable setFrame:rcTableFrame];
    
    //确保发送按钮不会上移
    int iLeftX = _uiSendTextButton.frame.origin.x;
    int iTopY = rcBkView.size.height - 35;
    _uiSendTextButton.frame = CGRectMake(iLeftX, iTopY, 60, 30);
    [UIView commitAnimations];
    
    _uiSendTextView.layer.borderWidth = 1.0f;
    _uiSendTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_uiSendTextView.layer setMasksToBounds:YES];
    _uiSendTextView.layer.cornerRadius = 5.0f;

}

//获取指定一个会话session的消息列表
-(void)getFriendSessionMsgList_Web
{
    //系统消息和公共消息只显示一条
    if(_iMessageType > 1)
    {
        m_pMsgDataSet = [[QDataSetObj alloc] init];
        [m_pMsgDataSet addDataSetRow:_pOneMessageRowSet];
        [_uiMessageTable reloadData];
        return;
    }
    if(_strSessionId == nil || _strSessionId.length < 1)
    {
        if(_strFriendId == nil || _strFriendId.length < 1)
            return;
    }
    CKHttpHelper*pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"user.getSessionMsg"]];
    
    [pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    m_iCurPageID++;
    [pHttpHelper addParam:_strSessionId forName:@"sessionId"];
    [pHttpHelper addParam:_strFriendId forName:@"oppAccount"];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",m_iCurPageID] forName:@"page"];
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         QDataSetObj* pDataSet = dataSet;
         if(pDataSet == nil)
         {
             if(m_iCurPageID == 1)
                 [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             
             return ;
         }
         if([pDataSet getOpeResult] == false)
         {
             if(m_iCurPageID == 1)
             {
                 [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",[pDataSet getErrorText]] duration:1.8];
             }
             return;
         }
         //处理收到的消息列表
         int iDealCount = [self dealReceivedSessionMsgList:pDataSet];
         if(iDealCount >= 10)
             m_isCanLoadMore = YES;
         else
             m_isCanLoadMore = NO;
         [SVProgressHUD dismiss];
         [_uiMessageTable reloadData];
         
         //第一页，默认滚动到底部
         if(m_iCurPageID == 1)
         {
             NSInteger iMaxRow = 0;
             if(m_pMsgDataSet)
                 iMaxRow = [m_pMsgDataSet getRowCount] - 1;
             if(iMaxRow > 3)
             {
                 if(m_isCanLoadMore == YES)
                     iMaxRow++;
                 NSIndexPath* nsMaxPath = [NSIndexPath indexPathForRow:iMaxRow inSection:0];
                 [_uiMessageTable scrollToRowAtIndexPath:nsMaxPath atScrollPosition:UITableViewScrollPositionBottom  animated:YES];
             }
         }
         [self downLoadFriendImageUrl];
         
     }];
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    [pHttpHelper start];
   
}

//下载好友的头像
-(void)downLoadFriendImageUrl
{
    if(_strFriendHeadImgUrl.length < 2)
        return;
    
    CKHttpImageHelper*  pImgHelper = [[CKHttpImageHelper alloc] initWithOwner:self];

    NSURL *nsImageReqUrl = [NSURL URLWithString:_strFriendHeadImgUrl];
    if(nsImageReqUrl == nil)
        return;
  
    [pImgHelper addImageUrl:nsImageReqUrl forKey:@"1"];
    //重新加载
    [_uiMessageTable reloadData];
    //
    [pImgHelper startWithReceiveBlock:^(UIImage *pImage,NSString *strKey,BOOL blFinsh)
     {
         _pFriendHeadImage = pImage;
         [_uiMessageTable reloadData];
     }];
    
    
}

//将从服务器上下载下来的短信写到本地数据库中
-(NSInteger)dealReceivedSessionMsgList:(QDataSetObj*)pDataSet
{


  //  NSString* strQryTime = [pDataSet getJsonValue:@"qryTime"];
   
    int iRowCount = [pDataSet getRowCount];
    if(iRowCount < 1)
        return 0;
    
    if(m_pMsgDataSet == nil)
    {
        m_pMsgDataSet = [[QDataSetObj alloc] init];
    }

    int iRowIndex = -1;
    NSString* strLastTime = @"";
    NSString* strFriendHeadUrl = _strFriendHeadImgUrl;
    CSjqMessageObj* pMessageObj = [[CSjqMessageObj alloc] init];
    for(int i=iRowCount-1;i>=0;i--)
    {
        SetRowObj* pNewRowObj = [[SetRowObj alloc] init];
        [pNewRowObj addFieldObj:@"flowId" andValue:[pDataSet getFeildValue:i andColumn:@"id"]];
        [pNewRowObj addFieldObj:@"userId" andValue:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName];
        [pNewRowObj addFieldObj:@"userHeadUrl" andValue:[pDataSet getFeildValue:i andColumn:@"fromHeadUrl"]];
        [pNewRowObj addFieldObj:@"to" andValue:_strFriendId];
        [pNewRowObj addFieldObj:@"toHeadUrl" andValue:[pDataSet getFeildValue:i andColumn:@"toHeadUrl"]];
        [pNewRowObj addFieldObj:@"messageInfo" andValue:[pDataSet getFeildValue:i andColumn:@"message"]];
        
        NSString* strTo = [pDataSet getFeildValue:i andColumn:@"to"];
        NSString* strMessageType = @"2";
        if([[UaConfiguration sharedInstance].m_setLoginState isLoginUser:strTo])
        {
            strMessageType = @"1";
        }
        
        if(strFriendHeadUrl.length < 1)
        {
            if([strMessageType isEqualToString:@"1"] == YES)
                strFriendHeadUrl = [pDataSet getFeildValue:i andColumn:@"fromHeadUrl"];
            else
                strFriendHeadUrl = [pDataSet getFeildValue:i andColumn:@"toHeadUrl"];
            
        }
        [pNewRowObj addFieldObj:@"messageType" andValue:strMessageType];
        
        NSString* strSendTime = [pDataSet getFeildValue:i andColumn:@"sendTime"];
        [pNewRowObj addFieldObj:@"sendTime" andValue:strSendTime];
        NSString* strShowTime = [pMessageObj getMessageShowTime:strSendTime];
        if([strShowTime isEqualToString:strLastTime] == false)
        {
            strLastTime = strShowTime;
            [pNewRowObj addFieldObj:@"showTime" andValue:strShowTime];
        }
        else
        {
            [pNewRowObj addFieldObj:@"showTime" andValue:@""];
        }
        
        if(m_iCurPageID == 1)
        {
            [m_pMsgDataSet addDataSetRow:pNewRowObj];
        }
        else
        {
            iRowIndex++;
            [m_pMsgDataSet insertDataSetRow:pNewRowObj andIndex:iRowIndex];
        }
        
    }
    _strFriendHeadImgUrl = strFriendHeadUrl;
    return [pDataSet getRowCount];
}


//测试数据
-(NSInteger)dealReceivedSessionMsgList_Test:(QDataSetObj*)pDataSet
{

    if(m_iCurPageID > 4)
        return 0;

    pDataSet = [[QDataSetObj alloc] init];
    for(int i=0;i<10;i++)
    {
        m_iTotalTestCount++;
        [pDataSet addDataSetRow_Ext:i andName:@"id" andValue:[NSString stringWithFormat:@"%d",m_iTotalTestCount+9000]];
        [pDataSet addDataSetRow_Ext:i andName:@"from" andValue:@"sjqtest"];
        [pDataSet addDataSetRow_Ext:i andName:@"to" andValue:@"mama2014"];
        [pDataSet addDataSetRow_Ext:i andName:@"msgType" andValue:@"1"];
        
        [pDataSet addDataSetRow_Ext:i andName:@"toHeadUrl" andValue:@""];
        [pDataSet addDataSetRow_Ext:i andName:@"message" andValue:[NSString stringWithFormat:@"测试的消息->%d",m_iTotalTestCount]];
        [pDataSet addDataSetRow_Ext:i andName:@"sendTime" andValue:[NSString stringWithFormat:@"2014.08.12 %d:%d",20-m_iCurPageID,60-i]];
        
    }
    
    if(m_pMsgDataSet == nil)
    {
        m_pMsgDataSet = [[QDataSetObj alloc] init];
    }
    int iRowCount = [pDataSet getRowCount];
    if(iRowCount < 1)
        return 0;
    int iRowIndex = -1;
    NSString* strLastTime = @"";
    CSjqMessageObj* pMessageObj = [[CSjqMessageObj alloc] init];
    for(int i=iRowCount-1;i>=0;i--)
    {
        SetRowObj* pNewRowObj = [[SetRowObj alloc] init];
        [pNewRowObj addFieldObj:@"flowId" andValue:[pDataSet getFeildValue:i andColumn:@"id"]];
        [pNewRowObj addFieldObj:@"userId" andValue:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName];
        [pNewRowObj addFieldObj:@"userHeadUrl" andValue:[pDataSet getFeildValue:i andColumn:@"fromHeadUrl"]];
        [pNewRowObj addFieldObj:@"to" andValue:_strFriendId];
        [pNewRowObj addFieldObj:@"toHeadUrl" andValue:[pDataSet getFeildValue:i andColumn:@"toHeadUrl"]];
        [pNewRowObj addFieldObj:@"messageInfo" andValue:[pDataSet getFeildValue:i andColumn:@"message"]];
        [pNewRowObj addFieldObj:@"messageType" andValue:@"1"];
        
        NSString* strSendTime = [pDataSet getFeildValue:i andColumn:@"sendTime"];
        
        [pNewRowObj addFieldObj:@"sendTime" andValue:strSendTime];
        

        NSString* strShowTime = [pMessageObj getMessageShowTime:strSendTime];
        
        if([strShowTime isEqualToString:strLastTime] == false)
        {
            strLastTime = strShowTime;
            [pNewRowObj addFieldObj:@"showTime" andValue:strShowTime];
        }
        else
        {
            [pNewRowObj addFieldObj:@"showTime" andValue:@""];
        }
        
        if(m_iCurPageID == 1)
        {
            [m_pMsgDataSet addDataSetRow:pNewRowObj];
        }
        else
        {
            iRowIndex++;
            [m_pMsgDataSet insertDataSetRow:pNewRowObj andIndex:iRowIndex];
        }
        
    }
    
    return [pDataSet getRowCount];
}


//从本地数据库中读取相关的聊天记录
-(void)getUserMessageLogList_Local
{
    
    CSjqMessageObj* pMessageObj = [[CSjqMessageObj alloc] init];

    QDataSetObj*  pListDataSet = [pMessageObj getFriendMessageListInfo:_strFriendId andGetFlag:0];
    if(pListDataSet == nil)
        return;
    if(m_pMsgDataSet == nil)
        m_pMsgDataSet = [[QDataSetObj alloc] init];
    int iRowCount = [pListDataSet getRowCount];
    int iNoReadCount = 0;
    NSString* strLastTime = @"";
    //对消息的时间进行排序，从而控制在一分钟内的消息，分成一组显示
    for(int i=0;i<iRowCount;i++)
    {
        SetRowObj* pRowObj = [pListDataSet getRowObj:i];
        NSString* strSendTime = [pListDataSet getFeildValue:i andColumn:@"sendTime"];
        NSString* strShowTime = [pMessageObj getMessageShowTime:strSendTime];
        
        if([strShowTime isEqualToString:strLastTime] == false)
        {
            strLastTime = strShowTime;
            [pRowObj addFieldObj:@"showTime" andValue:strShowTime];
        }
        else
        {
            [pRowObj addFieldObj:@"showTime" andValue:@""];
        }
        NSString* strIsRead = [pRowObj getFieldValue:@"isRead"];
        if([strIsRead isEqualToString:@"0"])
            iNoReadCount++;
        [pRowObj addFieldObj:@"isWrite" andValue:@"1"];
        [m_pMsgDataSet addDataSetRow:pRowObj];
    }
    //改成已读
    if(iNoReadCount > 0)
    {
        [pMessageObj setMessageStateToRead:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName andFriend:_strFriendId];
    }
    
    [_uiMessageTable reloadData];
    
   
}

//键盘显示的时候，修改视图布局，避免遮住信息输入区域
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //键盘的区域
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveTextViewWithFrame:keyboardRect withDuration:animationDuration];
}

//键盘隐藏的时候，恢复视图的原先布局
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self setDefaultMessageView:animationDuration andFlag:0];
    
}

//键盘隐藏或显示的时候，修改或恢复视图的布局
- (void)moveTextViewWithFrame:(CGRect)frame withDuration:(NSTimeInterval)animationDuration
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
/*
    //改变tableView的区域
    CGRect rcTableFrame = _uiMessageTable.frame;
    rcTableFrame.size.height = self.view.frame.size.height - frame.size.height - _uiSendView.frame.size.height;
    _uiMessageTable.frame = rcTableFrame;
    
    //发送区域
    CGRect rcSendFrame = _uiSendView.frame;
    rcSendFrame.origin.y = self.view.frame.size.height - frame.size.height - rcSendFrame.size.height;
    _uiSendView.frame = rcSendFrame;
    
    int iLeftX = _uiSendTextButton.frame.origin.x;
    int iTopY = rcSendFrame.size.height - 35;
    
    _uiSendTextButton.frame = CGRectMake(iLeftX, iTopY, 60,30);
 
*/
    
    //改变tableView的区域
    CGRect rcTableFrame = _uiMessageTable.frame;
    rcTableFrame.size.height = self.view.frame.size.height - frame.size.height - _uiSendView.frame.size.height;
    _uiMessageTable.frame = rcTableFrame;
    
    //发送视图区域
    CGRect rcSendFrame = _uiSendView.frame;
    rcSendFrame.origin.y = self.view.frame.size.height - frame.size.height - rcSendFrame.size.height;
    _uiSendView.frame = rcSendFrame;
    
    int iLeftX = _uiSendTextButton.frame.origin.x;
    int iTopY = rcSendFrame.size.height - 35;
    //发送按钮的区域
    _uiSendTextButton.frame = CGRectMake(iLeftX, iTopY, 60,30);
    
    [UIView commitAnimations];
}

//恢复默认的区域
-(void)setDefaultMessageView:(NSTimeInterval)animationDuration andFlag:(NSInteger)iFlag
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //改变tableView的区域
    int iSendViewHeight =_uiSendView.frame.size.height;
    if(iFlag == 1)
        iSendViewHeight = 40;
    
    CGRect rcTableFrame = _uiMessageTable.frame;
    rcTableFrame.size.height = self.view.frame.size.height - iSendViewHeight;
    _uiMessageTable.frame = rcTableFrame;
    //发送区域
    CGRect rcSendFrame = _uiSendView.frame;
    rcSendFrame.origin.y = self.view.frame.size.height - iSendViewHeight;
    rcSendFrame.size.height = iSendViewHeight;
    _uiSendView.frame = rcSendFrame;
    if(iFlag == 1)
    {
        CGRect rcTextView = _uiSendTextView.frame;
        rcTextView.size.height = 30;
        rcTextView.origin.y = 5;
        _uiSendTextView.frame = rcTextView;
    }
    int iLeftX = _uiSendTextButton.frame.origin.x;
    int iTopY = rcSendFrame.size.height - 35;
    
    _uiSendTextButton.frame = CGRectMake(iLeftX, iTopY, 60,30);
    [UIView commitAnimations];
}

//点击，发送消息
-(IBAction)onSendMessageBtnClicked:(id)sender
{
    NSString* strMessage = _uiSendTextView.text;
    if(strMessage.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"消息不能为空！"];
        return;
    }
    
    if([QDataSetObj isBigMaxLength:strMessage andLength:1000] == true)
    {
        [SVProgressHUD showErrorWithStatus:HINT_BIG_MAX_LENGTH duration:1.8];
        return;
    }
    CSjqMessageObj* pMessageObj = [[CSjqMessageObj alloc] init];
    NSString* strReallyTime = [pMessageObj getMessageReallyTime];

    if(m_pMsgDataSet == nil)
    {
        m_pMsgDataSet = [[QDataSetObj alloc] init];
    }
    int iRow = [m_pMsgDataSet getRowCount];
    NSString* strLastTime = @"";
    if(iRow > 1)
    {
        strLastTime = [m_pMsgDataSet getFeildValue:iRow-1 andColumn:@"showTime"];
    }
    
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"flowId" andValue:@"0"];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"userId" andValue:strUserId];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"userHeadUrl" andValue:@""];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"friendId" andValue:_strFriendId];

    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"sendTime" andValue:strReallyTime];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"messageInfo" andValue:strMessage];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"messageType" andValue:@"2"];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"isRead" andValue:@"1"];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"isWrite" andValue:@"0"];
    
    NSString* strShowTime = [pMessageObj getMessageShowTime:strReallyTime];
    if([strLastTime isEqualToString:strShowTime])
    {
        [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"showTime" andValue:@""];
    }
    else
    {
        [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"showTime" andValue:strShowTime];
    }
    
    //如果只有一条记录，那么刷新tableview，调用cell的insert操作会失败
    if([m_pMsgDataSet getRowCount] == 1)
    {
        [_uiSendTextView resignFirstResponder];
        
        _uiSendTextView.text = @"";
        [self setDefaultMessageView:1 andFlag:1];
        [_uiMessageTable reloadData];
        //新发送的消息
        SetRowObj* pRowObj = [m_pMsgDataSet getRowObj:iRow];
        //发送到服务器
        [self submitMessageToServer:pRowObj];

        return;
    }

    //更新信息的显示(TableView)
    [_uiMessageTable beginUpdates];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc]initWithCapacity:0];
    int iInsertRow = iRow;
    if(m_isCanLoadMore == YES)
    {
        iInsertRow++;
    }
    NSIndexPath *indexPathToInsert = [NSIndexPath indexPathForRow:iInsertRow inSection:0];
    [indexPaths addObject:indexPathToInsert];
    
    [_uiMessageTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_uiMessageTable endUpdates];
        [_uiSendTextView resignFirstResponder];

        _uiSendTextView.text = @"";
        [self setDefaultMessageView:1 andFlag:1];
        [_uiMessageTable scrollToRowAtIndexPath:indexPathToInsert atScrollPosition:UITableViewScrollPositionBottom  animated:NO];
        //新发送的消息
        SetRowObj* pRowObj = [m_pMsgDataSet getRowObj:iRow];
        //发送到服务器
        [self submitMessageToServer:pRowObj];
     }];
}


//将信息提交到服务器
-(bool)submitMessageToServer:(SetRowObj*)pRowObj
{

    CKHttpHelper*pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"user.sendMessage"]];
    
    [pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    [pHttpHelper addParam:[pRowObj getFieldValue:@"friendId"] forName:@"to"];
    [pHttpHelper addParam:[pRowObj getFieldValue:@"userId"] forName:@"from"];
     [pHttpHelper addParam:[pRowObj getFieldValue:@"messageInfo"] forName:@"message"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         QDataSetObj* pDataSet = dataSet;
         if(pDataSet == nil)
         {
             [self dealReceivedErrorSendResponse:pRowObj];
             return ;
         }
         if([pDataSet getOpeResult] == false)
         {
             [self dealReceivedErrorSendResponse:pRowObj];
             return ;
         }
         
     //    NSString* strMessageId = [pDataSet getJsonValue:@"messageId"];
     //    [pRowObj setFieldValue:@"flowId" andValue:strMessageId];
         CSjqMessageObj* pMessageObj = [[CSjqMessageObj alloc] init];
         [pMessageObj WriteSendLogToLocalDB:pRowObj];

     }];
    
    [pHttpHelper start];
    return  true;

}

//发送失败后，提示用户
-(void)dealReceivedErrorSendResponse:(SetRowObj*)pSendRow
{
    CSjqMessageObj* pMessageObj = [[CSjqMessageObj alloc] init];
    NSString* strReallyTime = [pMessageObj getMessageReallyTime];
    
    int iRow = [m_pMsgDataSet getRowCount];
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    
    NSString* strMessage = [NSString stringWithFormat:@"消息\"%@\"发送失败",[pSendRow getFieldValue:@"messageInfo"]];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"userId" andValue:strUserId];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"userHeadUrl" andValue:@""];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"friendId" andValue:_strFriendId];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"friendHeadUrl" andValue:@""];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"sendTime" andValue:strReallyTime];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"messageInfo" andValue:strMessage];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"messageType" andValue:@"9"];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"isRead" andValue:@"1"];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"isWrite" andValue:@"1"];
    
    NSString* strShowTime = [pMessageObj getMessageShowTime:strReallyTime];
    [m_pMsgDataSet addDataSetRow_Ext:iRow andName:@"showTime" andValue:strShowTime];
    
    
    //更新信息的显示(TableView)
    [_uiMessageTable beginUpdates];
    NSMutableArray *indexPaths = [[NSMutableArray alloc]initWithCapacity:0];
    
    NSIndexPath *indexPathToInsert = [NSIndexPath indexPathForRow:iRow inSection:0];
    [indexPaths addObject:indexPathToInsert];
    
    [_uiMessageTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_uiMessageTable endUpdates];
        [_uiMessageTable scrollToRowAtIndexPath:indexPathToInsert atScrollPosition:UITableViewScrollPositionBottom  animated:NO];
        
    }];
}

#pragma mark -about UITableView datasource and delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_uiSendTextView resignFirstResponder];
    if(m_isCanLoadMore == false)
        return;
    if(indexPath.row != 0)
        return;
    [self getFriendSessionMsgList_Web];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(m_pMsgDataSet == nil)
        return  0;
    int iMsgCellCount = [m_pMsgDataSet getRowCount];
    if(m_isCanLoadMore == YES)
    {
        iMsgCellCount++;
    }
    return iMsgCellCount;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getSectionRowHeight:indexPath.row];

}

//获取当前的TableViewCell的高度
-(CGFloat)getSectionRowHeight:(NSInteger)iRow
{
  //  if(iRow >= [m_pMsgDataSet getRowCount])
  //      return 40;
    
    //加载更多的提示
    if(m_isCanLoadMore == YES)
    {
        if(iRow == 0)
            return 30;
        iRow--;
    }
    
    NSString* strMessageType = [m_pMsgDataSet getFeildValue:iRow andColumn:@"messageType"];
    CGFloat fHeight = 0;
    int iMessageType = [QDataSetObj isPureInt:strMessageType];
    
    NSString* strTime = [m_pMsgDataSet getFeildValue:iRow andColumn:@"showTime"];
    if(iMessageType != 9 && strTime.length > 0)
    {
        fHeight = 30;
    }
    NSString* strMessage = [m_pMsgDataSet getFeildValue:iRow andColumn:@"messageInfo"];
    int iWidth = 190;
    if(iMessageType == 9)
    {
        strMessage = [NSString stringWithFormat:@"%@ 系统消息:%@",strTime,strMessage];
        iWidth = 300;
    }
    //计算消息的实际高度
    CGFloat fTitleHeight =[UILabel getFitTextHeightWithText:strMessage andWidth:iWidth andFont:[UIFont systemFontOfSize:14]];
    if(fTitleHeight < 50)
        fTitleHeight = 50;
    
    fHeight = fHeight + fTitleHeight + 20;
    return fHeight;
}

//获取有时间提示的cell
-(UITableViewCell*)getHaveTimeInfoTableCell:(UITableView *)tableView  andIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strHaveTimeInfoCellID = @"UserHaveTimeInfoCellId";
    
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strHaveTimeInfoCellID];
    
    int iTopY = 5;
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strHaveTimeInfoCellID];
        
        //时间信息
        UILabel *pLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200, 21)];
        pLabel1.font = [UIFont systemFontOfSize:14.0];
        pLabel1.textColor = COLOR_FONT_2;
        pLabel1.backgroundColor = [UIColor clearColor];
        pLabel1.tag = 1001;
        pLabel1.textAlignment = UITextAlignmentCenter;
        [pCellObj.contentView addSubview:pLabel1];
        //加一条虚线
        UIImageView * pTimeLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, 320, 1)];
        pTimeLine.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pTimeLine];
  
        iTopY = 30+5;
        //消息的背景
        UIImageView* pInfoBkView = [[UIImageView alloc] initWithFrame:CGRectMake(65, iTopY, 190, 50)];
        pInfoBkView.tag = 1004;
        pInfoBkView.backgroundColor = RGBCOLOR(238, 242, 245);
        [pCellObj.contentView addSubview:pInfoBkView];

        //头像和消息内容之间的箭头
        UIImageView* pArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(55, iTopY+3, 10, 16)];
        pArrowView.tag = 1005;
        [pCellObj.contentView addSubview:pArrowView];
        
        //实际的消息内容
        UILabel *pLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(65+5, iTopY, 180, 50)];
        pLabel2.font = [UIFont systemFontOfSize:14.0];
        pLabel2.textColor = COLOR_FONT_2;
        pLabel2.backgroundColor = [UIColor clearColor];
        pLabel2.tag = 1002;
        pLabel2.numberOfLines = 0;
        [pCellObj.contentView addSubview:pLabel2];
        
        //头像
        UIImageView*pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, iTopY, 50, 50)];
        pLogoImgView.image = [UIImage imageNamed:@"bg_default.png"];
        pLogoImgView.tag = 1003;
        [pCellObj.contentView addSubview:pLogoImgView];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    int iDataRow = indexPath.row;
    if(m_isCanLoadMore == YES)
    {
        iDataRow--;
    }
    UILabel*pLabel = (UILabel*)[pCellObj viewWithTag:1001];
    pLabel.text = [m_pMsgDataSet getFeildValue:iDataRow andColumn:@"showTime"];
    
    pLabel = (UILabel*)[pCellObj viewWithTag:1002];
    UIImageView* pInfoBkView = (UIImageView*)[pCellObj.contentView viewWithTag:1004];
    if(pLabel != nil && pInfoBkView != nil)
    {
        NSString* strMessage = [m_pMsgDataSet getFeildValue:iDataRow andColumn:@"messageInfo"];
        //计算高度
        int iHeight = [UILabel getFitTextHeightWithText:strMessage andWidth:180 andFont:[UIFont systemFontOfSize:14]];
        CGRect rcFame = pInfoBkView.frame;
        rcFame.size.height = iHeight;
        pInfoBkView.frame = rcFame;
        
        rcFame = pLabel.frame;
        rcFame.size.height = iHeight;
        pLabel.frame = rcFame;
        pLabel.text = strMessage;
        pInfoBkView.layer.borderWidth = 1.0f;
        pInfoBkView.layer.borderColor = [UIColor clearColor].CGColor;
        [pInfoBkView.layer setMasksToBounds:YES];
        pInfoBkView.layer.cornerRadius = 5.0f;
    }
 
    NSString* strType = [m_pMsgDataSet getFeildValue:iDataRow andColumn:@"messageType"];
    
    UIImageView*pImageView = (UIImageView*)[pCellObj viewWithTag:1003];
    UIImageView*pHintArrowView = (UIImageView*)[pCellObj viewWithTag:1005];
    if([strType isEqualToString:@"1"])
    {
         pImageView.image = _pFriendHeadImage;
         int iTop = pImageView.frame.origin.y;
         pImageView.frame = CGRectMake(5, iTop, 50, 50);
        
         pHintArrowView.frame  = CGRectMake(55, pImageView.frame.origin.y+3, 13, 16);
         pHintArrowView.image = [UIImage imageNamed:@"msg_left_arrow.png"];
    }
    else
    {
        int iTop = pImageView.frame.origin.y;
        pImageView.frame = CGRectMake(265, iTop, 50, 50);
        UIImage*pImage  = m_pUserHeadImage;
        pImageView.image = pImage;
        
        pHintArrowView.frame =  CGRectMake(252, iTop+3, 13, 16);
        pHintArrowView.image = [UIImage imageNamed:@"msg_right_arrow.png"];
    }
    
    return pCellObj;
}

//获取没有时间显示的tableCell
-(UITableViewCell*)getNoTimeInfoTableCell:(UITableView *)tableView  andIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strNoTimeInfoCellID = @"UserNoTimeInfoCellId";
    
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strNoTimeInfoCellID];
    
    int iTopY = 5;
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strNoTimeInfoCellID];
        
        //消息内容的背景
        UIImageView* pInfoBkView = [[UIImageView alloc] initWithFrame:CGRectMake(65, iTopY, 190, 50)];
        pInfoBkView.tag = 1004;
        pInfoBkView.backgroundColor = RGBCOLOR(238, 242, 245);
        [pCellObj.contentView addSubview:pInfoBkView];
        
        //消息内容
        UILabel *pLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(65+5, iTopY, 180, 50)];
        pLabel2.font = [UIFont systemFontOfSize:14.0];
        pLabel2.textColor = COLOR_FONT_2;
        pLabel2.backgroundColor = [UIColor clearColor];
        pLabel2.tag = 1002;
        pLabel2.numberOfLines = 0;
        [pCellObj.contentView addSubview:pLabel2];
        
        
        //头像和消息内容之间的箭头
        UIImageView* pArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(55, iTopY+3, 10, 16)];
        pArrowView.tag = 1005;
        [pCellObj.contentView addSubview:pArrowView];
        //头像
        UIImageView*pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, iTopY, 50, 50)];
        pLogoImgView.tag = 1003;
        [pCellObj.contentView addSubview:pLogoImgView];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    int iDataRow = indexPath.row;
    if(m_isCanLoadMore == YES)
    {
        iDataRow--;
    }
    UILabel* pLabel = (UILabel*)[pCellObj viewWithTag:1002];
    UIImageView* pInfoBkView = (UIImageView*)[pCellObj.contentView viewWithTag:1004];
    if(pLabel != nil && pInfoBkView !=nil)
    {
        NSString* strMessage = [m_pMsgDataSet getFeildValue:iDataRow andColumn:@"messageInfo"];
        //计算高度
        int iHeight = [UILabel getFitTextHeightWithText:strMessage andWidth:180 andFont:[UIFont systemFontOfSize:14]];
        CGRect rcFame = pLabel.frame;
        rcFame.size.height = iHeight;
        pLabel.frame = rcFame;
        pLabel.text = strMessage;
        rcFame  = pInfoBkView.frame;
        rcFame.size.height = iHeight;
        pInfoBkView.frame = rcFame;
        
        pInfoBkView.layer.borderWidth = 1.0f;
        pInfoBkView.layer.borderColor = [UIColor clearColor].CGColor;
        [pInfoBkView.layer setMasksToBounds:YES];
        pInfoBkView.layer.cornerRadius = 5.0f;
        
    }
    
    NSString* strType = [m_pMsgDataSet getFeildValue:iDataRow andColumn:@"messageType"];
    UIImageView*pImageView = (UIImageView*)[pCellObj viewWithTag:1003];
    UIImageView*pHintArrowView = (UIImageView*)[pCellObj viewWithTag:1005];
    
    if([strType isEqualToString:@"1"])
    {
        pImageView.image = _pFriendHeadImage;
        int iTop = pImageView.frame.origin.y;
        pImageView.frame = CGRectMake(5, iTop, 50, 50);
        
         pHintArrowView.frame  = CGRectMake(55, pImageView.frame.origin.y+3, 13, 16);
        pHintArrowView.image = [UIImage imageNamed:@"msg_left_arrow.png"];
    }
    else
    {
        int iTop = pImageView.frame.origin.y;
        pImageView.frame = CGRectMake(265, iTop, 50, 50);
        UIImage*pImage = m_pUserHeadImage;
        pImageView.image =pImage;
        
        pHintArrowView.frame =  CGRectMake(252, iTop+3, 13, 16);
        pHintArrowView.image = [UIImage imageNamed:@"msg_right_arrow.png"];
    }
    
    
    return pCellObj;
}

//获取系统提示消息的tableCell，主要是发送消息失败后的tableCell
-(UITableViewCell*)getSystemHintTableCell:(UITableView *)tableView  andIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strSystemHintTableCellID = @"SystemHintTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strSystemHintTableCellID];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strSystemHintTableCellID];
        
        
        UILabel *pLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 21)];
        pLabel1.font = [UIFont systemFontOfSize:14.0];
        pLabel1.textColor = [UIColor redColor];
        pLabel1.backgroundColor = [UIColor clearColor];
        pLabel1.tag = 1001;
        pLabel1.numberOfLines = 0;
        pLabel1.textAlignment = UITextAlignmentLeft;
        [pCellObj.contentView addSubview:pLabel1];
        
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }

    int iDataRow = indexPath.row;
    if(m_isCanLoadMore == YES)
    {
        iDataRow--;
    }
    UILabel* pLabel = (UILabel*)[pCellObj viewWithTag:1001];
    if(pLabel)
    {
        NSString* strShowTime = [m_pMsgDataSet getFeildValue:iDataRow andColumn:@"showTime"];
        NSString* strMessageInfo =[m_pMsgDataSet getFeildValue:iDataRow andColumn:@"messageInfo"];
        NSString* strShowMessage = [NSString stringWithFormat:@"%@ 系统消息：%@",strShowTime,strMessageInfo];
        //计算高度
  
        int iHeight = [UILabel getFitTextHeightWithText:strShowMessage andWidth:300 andFont:[UIFont systemFontOfSize:14]];
        CGRect rcFame = pLabel.frame;
        rcFame.size.height = iHeight;
        pLabel.frame = rcFame;
        pLabel.text = strShowMessage;
        
    }
    return pCellObj;
}


//加载更多的cell
-(UITableViewCell*)getLoadMoreTableCell:(UITableView *)tableView  andIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strLoadMoreTableCellID = @"LoadMoreTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strLoadMoreTableCellID];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strLoadMoreTableCellID];
        
        UIImageView* pLoadMore = [[UIImageView alloc] initWithFrame:CGRectMake(95, 5, 20, 20)];
        pLoadMore.image = [UIImage imageNamed:@"loadMore.png"];
        [pCellObj.contentView addSubview:pLoadMore];
        
        UILabel *pLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 100, 21)];
        pLabel1.font = [UIFont systemFontOfSize:16.0];
        pLabel1.textColor = COLOR_BUTTON_FONT;
        pLabel1.backgroundColor = [UIColor clearColor];
        pLabel1.tag = 1001;
        pLabel1.numberOfLines = 0;
        pLabel1.textAlignment = UITextAlignmentCenter;
        pLabel1.text = @"加载更多消息";
        [pCellObj.contentView addSubview:pLabel1];
        
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return pCellObj;
    
}

//
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    UITableViewCell *pCellObj = nil;
    int iDataRow = indexPath.row;
    if(m_isCanLoadMore == YES )
    {
        if(indexPath.row == 0)
        {
            pCellObj = [self getLoadMoreTableCell:tableView andIndexPath:indexPath];
            return pCellObj;
        }
        iDataRow--;
    }
    
    NSString*strMessageType = [m_pMsgDataSet getFeildValue:iDataRow andColumn:@"messageType"];
    if([strMessageType isEqualToString:@"9"])
    {
        pCellObj = [self getSystemHintTableCell:tableView andIndexPath:indexPath];
    }
    else
    {
    
        NSString* strTime = [m_pMsgDataSet getFeildValue:iDataRow andColumn:@"showTime"];

        if(strTime.length > 1)
            pCellObj = [self getHaveTimeInfoTableCell:tableView andIndexPath:indexPath];
        else
            pCellObj = [self getNoTimeInfoTableCell:tableView andIndexPath:indexPath];
    }
    return pCellObj;
}


//确认删除消息记录
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //取消
    if(buttonIndex == 0)
        return;
 //   NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    
    CKHttpHelper*pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"user.delMessage"]];
    [pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    
    [pHttpHelper addParam:_strFriendId forName:@"oppositeName"];
    //[pHttpHelper addParam:strUserId forName:@"recvName"];
    [pHttpHelper addParam:@"0" forName:@"messageId"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         QDataSetObj* pDataSet = dataSet;
         if(pDataSet == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         if([pDataSet getOpeResult] == false)
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"操作失败：%@",[pDataSet getErrorText]] duration:1.8];
             return ;
         }
         /*modify by lzq 2014-08-15:消息全部有服务端获取
         CSjqMessageObj* pMessageObj = [[CSjqMessageObj alloc] init];
         bool blDelete = [pMessageObj deleteMessageLogByFriend:strUserId andFriend:_strFriendId];
         if(blDelete == false)
         {
             [SVProgressHUD showErrorWithStatus:@"删除消息记录失败！" duration:1.8];
             return;
         }
         */
         [SVProgressHUD showSuccessWithStatus:@"删除成功！" duration:1.8];
         m_pMsgDataSet = nil;
         [_uiMessageTable reloadData];
         
     }];
    
    [pHttpHelper start];
    
}

@end
