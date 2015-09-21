
//
//  DownToUpPopupView.h
//
//  Created by lzq on 14-3-16.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import "DownToUpPopupView.h"
#import "UaConfiguration.h"
#import "CustomViews.h"
#import "UIColor+Hex.h"
#import "GlobalDefine.h"
#import "UIOwnSkin.h"

@implementation DownToUpPopupView

@synthesize m_uiFirstTable = _uiFirstTable;
@synthesize m_switchDelegate = _switchDelegate;
@synthesize m_iCurrentSelCellRow = _iCurrentSelCellRow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        m_iViewShowType = 0;
        [self initializeWithFrame:frame];

    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andViewType:(NSInteger)iViewType andData:(NSMutableArray*)arDataList
{
 
    frame = [[UIScreen mainScreen] bounds];
    frame.size.height = frame.size.height - 44;
    if(IS_IPHONE_5)
    {
        frame.size.height = frame.size.height - 20;//20个像素的状态栏
    }
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView* pBkView = [[UIImageView alloc] initWithFrame:frame];
        pBkView.backgroundColor = [UIColor darkGrayColor];
        pBkView.alpha = 0.8;
        [self addSubview:pBkView];
        
        m_iViewShowType = iViewType;
        m_arDataList = arDataList;
        [self initializeWithFrame:frame ];
    }
    return self;
}


-(void)initializeWithFrame:(CGRect)frame
{
 
    //有效区域的视图220个像素的高度
    m_pShowRectView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, 320,220)];
    m_pShowRectView.backgroundColor = [UIColor whiteColor];
    m_pShowRectView.layer.borderColor = COLOR_BAR_BACKGROUND.CGColor;
    m_pShowRectView.layer.borderWidth = 1.0f;
    m_pShowRectView.layer.cornerRadius = 1.0f;
    
    //上面的barview（40像素）
    UIView*pBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    pBarView.backgroundColor = COLOR_BAR_BACKGROUND;
    [m_pShowRectView addSubview:pBarView];
    
    
    UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pButton.frame = CGRectMake(20, 5, 60, 30);
    [pButton setTitle:@"取消" forState:UIControlStateNormal];
    pButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [pButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [UIOwnSkin setButtonFontRect:pButton];
    pButton.tag = 2001;
    [pBarView addSubview:pButton];
    
    pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pButton.frame = CGRectMake(240, 5, 60, 30);
    [pButton setTitle:@"确定" forState:UIControlStateNormal];
    pButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [pButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [UIOwnSkin setButtonFontRect:pButton];
     pButton.tag = 2002;
    [pBarView addSubview:pButton];
    [m_pShowRectView addSubview:pBarView];
    
    //线条
    UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [pBarView addSubview:pLineView];
    
    //第一个tableview
    CGRect firstRect = CGRectMake(0, 40, 320, 180);
    _uiFirstTable = [[UITableView alloc]initWithFrame:firstRect style:UITableViewStylePlain];
    
    _uiFirstTable.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _uiFirstTable.separatorColor = [UIColor clearColor];
    _uiFirstTable.showsVerticalScrollIndicator = NO;
    _uiFirstTable.showsHorizontalScrollIndicator = NO;
    _uiFirstTable.dataSource = self;
    _uiFirstTable.delegate = self;
    [m_pShowRectView addSubview:_uiFirstTable];
    [self addSubview:m_pShowRectView];
    
    [_uiFirstTable reloadData];
    [self performSelector:@selector(showTableView) withObject:self afterDelay:0.1];

}

//第一个table的视图
-(void)showTableView
{
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
    //CGRect rcView = [[UIScreen mainScreen] bounds];
    CGRect rcFrame = CGRectMake(0, self.frame.size.height-220, 320, 220);
	m_pShowRectView.frame = rcFrame;
	//[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:m_pShowRectView cache:YES];
    [UIView commitAnimations];

}

-(void)hideTableView
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
    CGRect rcFrame = CGRectMake(0, self.frame.size.height, 320, 220);
	m_pShowRectView.frame = rcFrame;

	//[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:m_pShowRectView cache:YES];
    [UIView commitAnimations];
}


#pragma mark - UItableview delegate and datasource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iCellRow = indexPath.row;
    if(iCellRow == _iCurrentSelCellRow)
        return;
    if(_iCurrentSelCellRow > -1)
    {
        [self setTableCellSelectedOrNot:_iCurrentSelCellRow andFlag:false];
    }
    [self setTableCellSelectedOrNot:iCellRow andFlag:true];
    
    _iCurrentSelCellRow = iCellRow;
 
}

-(void)setTableCellSelectedOrNot:(NSInteger)iCellRow andFlag:(bool)blFlag
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iCellRow inSection:0];
    UITableViewCell* pCellObj = [_uiFirstTable cellForRowAtIndexPath:indexPath];
    if(pCellObj == nil)
        return;
    UIImageView* pSelImgView = (UIImageView*)[pCellObj.contentView viewWithTag:1002];
    if(pSelImgView == nil)
        return;
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel == nil)
        return;
    if(blFlag == true)
    {
        pSelImgView.image = [UIImage imageNamed:@"checkbox_selected.png"];
        pCellObj.contentView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        pLabel.textColor = COLOR_FONT_3;
    }
    else
    {
        pSelImgView.image = [UIImage imageNamed:@"checkbox_nil.png"];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pLabel.textColor = COLOR_FONT_1;
    }
}



-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_arDataList == nil)
        return 0;
    return m_arDataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* firstSwitchTableId = @"firstSwitchTableId";
    UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:firstSwitchTableId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstSwitchTableId];
        pCellObj.contentView.backgroundColor  = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font  = [UIFont systemFontOfSize:14];
        pLabel.textAlignment = UITextAlignmentLeft;
        pLabel.tag = 1001;
        [pCellObj.contentView addSubview:pLabel];
        
        UIImageView* pSelectedView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 12, 20, 20)];
        pSelectedView.tag = 1002;
        //pSelectedView.image =
        [pCellObj.contentView addSubview:pSelectedView];
        
        UIImageView*pLineview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
        pLineview.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineview];

    }
    
    NSDictionary *dictObj = (NSDictionary*)[m_arDataList objectAtIndex:indexPath.row];
    if (!dictObj)
        return pCellObj;
    
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = (NSString*)[dictObj objectForKey:@"CellName"];
    }
    UIImageView* pSelImgView = (UIImageView*)[pCellObj.contentView viewWithTag:1002];
    if(pSelImgView)
    {
        if(indexPath.row == _iCurrentSelCellRow)
        {
            pSelImgView.image = [UIImage imageNamed:@"checkbox_selected.png"];
            pLabel.textColor = COLOR_FONT_3;
            pCellObj.contentView.backgroundColor  = COLOR_BAR_BACKGROUND;
        }
        else
        {
            pSelImgView.image = [UIImage imageNamed:@"checkbox_nil.png"];
            pLabel.textColor = COLOR_FONT_1;
            pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    return pCellObj;
 
}

//点击确定或取消
-(void)onButtonClicked:(id)sender
{
    UIButton*pButton = (UIButton*)sender;
    int iTag = pButton.tag ;
    if(iTag == 2001)
    {
        _iCurrentSelCellRow = -1;//取消操作
    }
    
    [self hideTableView];
    [self performSelector:@selector(submitSelectedResult) withObject:self afterDelay:0.7];
}


//启动代理，提交选择结果
-(void)submitSelectedResult
{
    
    NSString* strCellName = @"";
    NSString* strCellId = @"";
    if(_iCurrentSelCellRow > -1 && _iCurrentSelCellRow < m_arDataList.count)
    {
        NSDictionary* dictObj = [m_arDataList objectAtIndex:_iCurrentSelCellRow];
        
        strCellId = [dictObj objectForKey:@"CellCode"];
        strCellName = [dictObj objectForKey:@"CellName"];
    }
    
    if (_switchDelegate)
    {
        
        if([_switchDelegate respondsToSelector:@selector(onEndSelectedCellInfo:andName:)])
        {
            [_switchDelegate onEndSelectedCellInfo:strCellId andName:strCellName];
        }
        
    }
}

@end
