
//
//  MoneyTickedPopupView.h
//
//  Created by lzq on 2014-12-22.
//  Copyright (c) 2014年
//

#import "MoneyTickedPopupView.h"
#import "GlobalDefine.h"
#import "UIOwnSkin.h"

@implementation MoneyTickedPopupView

@synthesize m_uiFirstTable = _uiFirstTable;
@synthesize m_switchDelegate = _switchDelegate;
@synthesize m_iCurrentSelCellRow = _iCurrentSelCellRow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self initializeWithFrame:frame andTitle:@""];
        
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andData:(NSMutableArray*)arDataList andTitle:(NSString*)strTitle
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        
        m_arDataList = arDataList;
        [self initializeWithFrame:frame andTitle:strTitle];
    }
    return self;
}


//
-(void)initializeWithFrame:(CGRect)frame andTitle:(NSString*)strTitle
{
    self.backgroundColor = [UIColor whiteColor];
    //上面的barview（40像素）
    UIView*pBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    pBarView.backgroundColor = COLOR_BAR_BACKGROUND;
    
    //[m_pShowRectView addSubview:pBarView];
    [self addSubview:pBarView];
    
    
    UILabel*pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 21)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = COLOR_FONT_1;
    pLabel.font = [UIFont boldSystemFontOfSize:16];
    pLabel.textAlignment = NSTextAlignmentCenter;
    pLabel.text = strTitle;
    [self addSubview:pLabel];
    
    //线条
    UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, frame.size.width, 1)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [pBarView addSubview:pLineView];
    
    //第一个tableview
    CGRect firstRect = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40-50);
    _uiFirstTable = [[UITableView alloc]initWithFrame:firstRect style:UITableViewStylePlain];
    
    _uiFirstTable.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _uiFirstTable.separatorColor = [UIColor clearColor];
    _uiFirstTable.showsVerticalScrollIndicator = NO;
    _uiFirstTable.showsHorizontalScrollIndicator = NO;
    _uiFirstTable.dataSource = self;
    _uiFirstTable.delegate = self;
    [self addSubview:_uiFirstTable];
    
    [_uiFirstTable reloadData];
    
    //确认投标按钮
    UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pButton.frame = CGRectMake(10, frame.size.height-40, 260, 30);
    [UIOwnSkin setButtonBackground:pButton];
    pButton.tag = 3001;
    [pButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pButton];
    [pButton setTitle:@"选择" forState:UIControlStateNormal];
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
  //  [self submitSelectedResult];
    
}

-(void)setTableCellSelectedOrNot:(NSInteger)iCellRow andFlag:(bool)blFlag
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iCellRow inSection:0];
    UITableViewCell* pCellObj = [_uiFirstTable cellForRowAtIndexPath:indexPath];
    if(pCellObj == nil)
        return;
    UIImageView* pSelImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
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
    
    int iRowCount = m_arDataList.count;

    return iRowCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strMoneyBillTableCellId = @"MoneyBillTableCellId";
    UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strMoneyBillTableCellId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strMoneyBillTableCellId];
        pCellObj.contentView.backgroundColor  = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* pSelectedView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)];
        pSelectedView.tag = 2001;
        [pCellObj.contentView addSubview:pSelectedView];
        
        //代金券的名称
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 180, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font  = [UIFont systemFontOfSize:14];
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.tag = 1001;
        [pCellObj.contentView addSubview:pLabel];
        
        //代金券的金额
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 70, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font  = [UIFont systemFontOfSize:14];
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.tag = 1002;
        [pCellObj.contentView addSubview:pLabel];
        
        UIImageView*pLineview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 290, 1)];
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
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"%@元",(NSString*)[dictObj objectForKey:@"CellFee"]];
    }
    
    
    UIImageView* pSelImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
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
-(void)actionButtonClicked:(id)sender
{
    UIButton*pButton = (UIButton*)sender;
    int iTag = pButton.tag ;
    if(iTag == 3002)
    {
        _iCurrentSelCellRow = -1;//取消操作
    }
    
    //[self hideTableView];
    [self performSelector:@selector(submitSelectedResult) withObject:self afterDelay:0.7];
}


//启动代理，提交选择结果
-(void)submitSelectedResult
{
    
    NSString* strCellName = @"";
    NSString* strCellId = @"";
    NSString* strCellFee = @"";
    if(_iCurrentSelCellRow > -1 && _iCurrentSelCellRow < m_arDataList.count)
    {
        NSDictionary* dictObj = [m_arDataList objectAtIndex:_iCurrentSelCellRow];
        
        strCellId = [dictObj objectForKey:@"CellId"];
        strCellName = [dictObj objectForKey:@"CellName"];
        strCellFee = [dictObj objectForKey:@"CellFee"];
    }
    
    if (_switchDelegate)
    {
        
        if([_switchDelegate respondsToSelector:@selector(onEndSelectedCellInfo:andName:andFee:)])
        {
            [_switchDelegate onEndSelectedCellInfo:strCellId andName:strCellName andFee:strCellFee];
        }
        
    }
}



@end
