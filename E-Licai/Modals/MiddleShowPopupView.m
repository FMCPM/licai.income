
//
//  MiddleComPopupView.h
//
//  Created by lzq on 14-3-16.
//  Copyright (c) 2014年
//

#import "MiddleShowPopupView.h"
#import "GlobalDefine.h"

@implementation MiddleShowPopupView

@synthesize m_uiFirstTable = _uiFirstTable;
@synthesize m_switchDelegate = _switchDelegate;
@synthesize m_iCurrentSelCellRow = _iCurrentSelCellRow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        m_iViewShowType = 0;
        [self initializeWithFrame:frame andTitle:@""];
        
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andViewType:(NSInteger)iViewType andData:(NSMutableArray*)arDataList
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        
        m_iViewShowType = iViewType;
        m_arDataList = arDataList;
        [self initializeWithFrame:frame andTitle:@""];
    }
    return self;
}


//
-(void)initializeWithFrame:(CGRect)frame andTitle:(NSString*)strTitle
{
    
    self.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 1.0f;
    int iTopY = 0;
    if(strTitle.length > 0)
    {
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
        
        iTopY = 40;
    }

    
    //第一个tableview
    CGRect firstRect = CGRectMake(0, iTopY, self.frame.size.width, self.frame.size.height-iTopY);
    
    _uiFirstTable = [[UITableView alloc]initWithFrame:firstRect style:UITableViewStylePlain];
    
    _uiFirstTable.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _uiFirstTable.separatorColor = [UIColor clearColor];
    _uiFirstTable.showsVerticalScrollIndicator = NO;
    _uiFirstTable.showsHorizontalScrollIndicator = NO;
    _uiFirstTable.dataSource = self;
    _uiFirstTable.delegate = self;
    [self addSubview:_uiFirstTable];
    
    [_uiFirstTable reloadData];
    
    
}



#pragma mark - UItableview delegate and datasource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int iCellRow = indexPath.row;
    _iCurrentSelCellRow = iCellRow;

    [self setTableCellSelectedOrNot:iCellRow andFlag:true];
    

    [self submitSelectedResult];
    
}

-(void)setTableCellSelectedOrNot:(NSInteger)iCellRow andFlag:(bool)blFlag
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iCellRow inSection:0];
    UITableViewCell* pCellObj = [_uiFirstTable cellForRowAtIndexPath:indexPath];
    if(pCellObj == nil)
        return;

    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel == nil)
        return;
    if(blFlag == true)
    {

        pLabel.textColor = COLOR_FONT_3;
    }
    else
    {

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
    if(m_iViewShowType == 2)
    {
        iRowCount++;
    }
    return iRowCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strFirstInfoTableId = @"firstInfoTableId";
    UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strFirstInfoTableId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strFirstInfoTableId];
        pCellObj.contentView.backgroundColor  = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font  = [UIFont systemFontOfSize:14];
        pLabel.textAlignment = NSTextAlignmentCenter;
        pLabel.tag = 1001;
        [pCellObj.contentView addSubview:pLabel];
        
        
        UIImageView*pLineview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.frame.size.width, 1)];
        pLineview.tag = 2001;
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
    
    //[self hideTableView];
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

-(NSInteger)getViewShowType
{
    return m_iViewShowType;
}

@end
