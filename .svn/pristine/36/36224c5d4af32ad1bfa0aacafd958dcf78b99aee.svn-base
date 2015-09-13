//
//  SwitchCountryView.m
//  YTSearch
//
//  Created by jiang junchen on 12-11-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DropDownSwitchView.h"
#import "UaConfiguration.h"
#import "SQLLiteDBManager.h"
#import "CustomViews.h"
#import "UIColor+Hex.h"
#import "GlobalDefine.h"

/*
#define COLOR_DARK     [UIColor colorWithRed:202.0/255 green:202.0/255 blue:202.0/255 alpha:1.0f]
#define COLOR_LIGHT      [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1.0f]
#define COLOR_GRAYLINE  [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0f]
#define COLOR_HIGHTLINE [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0f]
*/
 
@implementation DropDownSwitchView
@synthesize m_uiFirstTable = _uiFirstTable;
@synthesize m_uiSecondTable = _uiSecondTable;

@synthesize m_switchDelegate = _switchDelegate;
@synthesize m_iSwitchViewType = _iSwitchViewType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        _iSwitchViewType = 0;
        [self initializeWithFrame:frame];

    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andViewType:(NSInteger)iViewType andClass:(NSMutableArray*)arClassList
{
    
    
    CGRect rcViewFrame = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:rcViewFrame];
    if (self)
    {
        UIControl* pBkView = [[UIControl alloc] initWithFrame:rcViewFrame];
        [pBkView addTarget:self action:@selector(closeSwitchDropDownView:) forControlEvents:UIControlEventTouchUpInside];
        
        
        pBkView.backgroundColor = [UIColor darkGrayColor];
        pBkView.alpha = 0.8;
        [self addSubview:pBkView];
        
        _iSwitchViewType  = iViewType;
        _muFirstTableDic = [[NSMutableArray alloc] init];
        for(int i=0;i<arClassList.count;i++)
        {
            [_muFirstTableDic addObject:[arClassList objectAtIndex:i]];
        }
        [self initializeWithFrame:frame];
        
    }
    return self;
}

//
-(void)initializeWithFrame:(CGRect)frame
{

    
    int iTBCount = 0;
    int iWidth = frame.size.width ;
    if(_iSwitchViewType == 1 || _iSwitchViewType == 2  ||_iSwitchViewType ==4 ||_iSwitchViewType==5)
    {
        iTBCount = 1;
    }

    if(iTBCount < 1)
        return;
    
    if(iTBCount == 2)
    {
         self.alpha = 0.8;
    }
    //第一个tableview
    CGRect firstRect =CGRectZero;
    firstRect.origin = CGPointMake(0, 0);
    firstRect.size.width = iWidth;
    firstRect.origin.x = 320-iWidth;
    firstRect.size.height = frame.size.height;
    [self initFirstTableView:firstRect];
    
    if(iTBCount < 2)
    {
        [_uiFirstTable reloadData];
        return;
    }
    CGRect seccondRect = CGRectZero;
    seccondRect.origin = CGPointMake(frame.size.width/2.0, 0);
    seccondRect.size.width = frame.size.width/2.0;
    seccondRect.size.height = frame.size.height - 40;
    [self initSecondTableView:seccondRect];
    

}

//第一个table的视图
-(void)initFirstTableView:(CGRect)frame
{
    /*
    UIView* pBarView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, 0, frame.size.width, 40)];
    pBarView.backgroundColor = COLOR_BAR_BACKGROUND;
    [self addSubview:pBarView];
    
    UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 40)];
    
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = [UIColor blackColor];
    pLabel.textAlignment = UITextAlignmentCenter;
    pLabel.font  =[UIFont systemFontOfSize:16];
    
    UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, 39, 320, 1)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [self addSubview:pLineView];
    
    if(_iSwitchViewType == 1)
        pLabel.text = @"选择商品分类";
    else if(_iSwitchViewType == 2)
        pLabel.text = @"选择订单状态";
	else if(_iSwitchViewType ==4)
		pLabel.text = @"提现状态";
	else if(_iSwitchViewType ==5)
		pLabel.text = @"收入/支出";
    [self addSubview:pLabel];*/

    int iHeight = frame.size.height;
    frame.origin.y = 0;
    frame.size.height = 0;
    _uiFirstTable = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _uiFirstTable.backgroundColor = [UIColor whiteColor];
    _uiFirstTable.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _uiFirstTable.separatorColor = [UIColor clearColor];
    _uiFirstTable.showsVerticalScrollIndicator = NO;
    _uiFirstTable.showsHorizontalScrollIndicator = NO;
    _uiFirstTable.dataSource = self;
    _uiFirstTable.delegate = self;
    [self addSubview:_uiFirstTable];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
    frame.size.height = iHeight;
	_uiFirstTable.frame = frame;
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_uiFirstTable cache:YES];
    [UIView commitAnimations];

}

-(void)initSecondTableView:(CGRect)frame
{
 //   int iHeight = frame.size.height;
 //   frame.size.height = 0;
    _uiSecondTable = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _uiSecondTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _uiSecondTable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _uiSecondTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _uiSecondTable.showsHorizontalScrollIndicator = NO;
    _uiSecondTable.showsVerticalScrollIndicator = NO;
    _uiSecondTable.backgroundColor = [UIColor whiteColor];
    _uiSecondTable.dataSource = self;
    _uiSecondTable.delegate = self;
    
     _uiSecondTable.frame = frame;
    
    [self addSubview:_uiSecondTable];
    
   /* [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
    frame.size.height = iHeight;
    _uiSecondTable.frame = frame;
	//orderTable.frame = CGRectMake(160, 0, 160, 100);
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_uiSecondTable cache:YES];
    [UIView commitAnimations];*/
    [_uiSecondTable setHidden:YES];
}


-(NSIndexPath*)setTableView:(UITableView*)table selectedRow:(NSInteger)row
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    [table selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    return path;
}


#pragma mark - UItableview delegate and datasource
-(void)didTableView:(UITableView*)tableView selectedByIndexPath:(NSIndexPath*)indexPath
{
    if ([tableView isEqual:_uiFirstTable])
    {
        NSDictionary *dic = (NSDictionary*)[_muFirstTableDic objectAtIndex:indexPath.row];
        m_strCellName1   = (NSString*)[dic objectForKey:@"CellName1"];
        m_strCellCode1   = (NSString*)[dic objectForKey:@"CellCode1"];
        //区域和分类切换视图
        if(_iSwitchViewType == 1 )
        {
           
            if (!_uiSecondTable.hidden)
                _uiSecondTable.hidden = YES;
            m_strCellCode2 = @"0";
            m_strCellName2 = @"";
            
        }
        
     }
    else if ([tableView isEqual:_uiSecondTable])
    {
        NSDictionary *dic   = (NSDictionary*)[_muSecondTableDic objectAtIndex:indexPath.row];
        if(!dic)
            return;
        m_strCellName2   = (NSString*)[dic objectForKey:@"CellName2"];
        m_strCellCode2   = (NSString*)[dic objectForKey:@"CellCode2"];
     }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didTableView:tableView selectedByIndexPath:indexPath];
    /*
    if ([tableView isEqual:_uiFirstTable])
    {
        if(_iSwitchViewType == 1 || _iSwitchViewType == 2)
        {
            if(indexPath.row != 0)
                return;
        }
    }*/
    
    if (_switchDelegate)
    {
        
        if([_switchDelegate respondsToSelector:@selector(switchDropDownView:andName:andID:)])
        {
            [_switchDelegate switchDropDownView:_iSwitchViewType andName:m_strCellName1 andID:m_strCellCode1 ];
        }

    }
}

-(void) closeSwitchDropDownView:(id)sender
{
    if (_switchDelegate)
    {
        
        if([_switchDelegate respondsToSelector:@selector(switchDropDownView:andName:andID:)])
        {
            [_switchDelegate switchDropDownView:nil andName:nil andID:nil];
        }
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_uiFirstTable])
    {
        if (_muFirstTableDic.count > 0)
        {
            return _muFirstTableDic.count;
        }
    }
    else if([tableView isEqual:_uiSecondTable])
    {
        if (_muSecondTableDic.count > 0)
        {
            return _muSecondTableDic.count;
        }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_uiFirstTable])
    {
        static NSString* firstSwitchTableId = @"firstSwitchTableId";
        UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:firstSwitchTableId];
        if (pCellObj == nil)
        {
            pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstSwitchTableId];
            pCellObj.contentView.backgroundColor  = [UIColor whiteColor];
            
            UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 140, 21)];
            pLabel.textColor = COLOR_FONT_1;
            pLabel.backgroundColor  = [UIColor clearColor];
            pLabel.font  = [UIFont systemFontOfSize:14];
            pLabel.tag  = 1001;
            pLabel.textAlignment = UITextAlignmentLeft;
            [pCellObj.contentView addSubview:pLabel];
            /*
            cell.textLabel.backgroundColor = [UIColor clearColor] ;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.textColor = COLOR_FONT_1;
            //if(_iSwitchViewType == 2)
            cell.textLabel.textAlignment  = UITextAlignmentLeft;
             */
            UIImageView*pLineview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.frame.size.width, 1)];
            pLineview.backgroundColor = COLOR_CELL_LINE_DEFAULT;
            [pCellObj.contentView addSubview:pLineview];
            
            /*
            if(_iSwitchViewType == 1 ||_iSwitchViewType == 2 || _iSwitchViewType ==4 || _iSwitchViewType ==5)
            {
                pCellObj.accessoryType = UITableViewCellAccessoryNone;
            }
            else
            {
                pCellObj.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }*/
        }

        NSDictionary *dic = (NSDictionary*)[_muFirstTableDic objectAtIndex:indexPath.row];
        if (!dic)
            return pCellObj;
        UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
        if(pLabel)
        {
            pLabel.text =  (NSString*)[dic objectForKey:@"CellName1"];
        }

        return pCellObj;
    }
    else
    {
        static NSString* secondSwitchTableId = @"secondSwitchTableId";
        UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:secondSwitchTableId];
        if (pCellObj == nil)
        {
            pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondSwitchTableId];
            
            pCellObj.contentView.backgroundColor = [UIColor whiteColor];
            pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 140, 21)];
            pLabel.textColor = COLOR_FONT_1;
            pLabel.backgroundColor  = [UIColor clearColor];
            pLabel.font  = [UIFont systemFontOfSize:14];
            pLabel.tag  = 1001;
            pLabel.textAlignment = UITextAlignmentLeft;
            [pCellObj.contentView addSubview:pLabel];
            /*
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.highlightedTextColor = [UIColor colorWithRed:255.0/255 green:113.0/255 blue:0 alpha:1.0];
            cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];*/
        }
        NSDictionary *dic = (NSDictionary*)[_muSecondTableDic objectAtIndex:indexPath.row];
        if (!dic)
            return pCellObj;
        UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
        if(pLabel)
        {
            pLabel.text =  (NSString*)[dic objectForKey:@"CellName2"];
        }
        return pCellObj;
    }
    return nil;
}

/*
-(void)setFristTableCellBackground:(UITableViewCell*)cell
{
    UILabel *grayline  = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, cell.frame.size.width, 1.0f)];
    grayline.backgroundColor = COLOR_GRAYLINE;
    UILabel *whiteline  = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1.0f)];
    whiteline.backgroundColor = COLOR_HIGHTLINE;
    [cell.contentView addSubview:grayline];
    [cell.contentView addSubview:whiteline];
    cell.contentView.backgroundColor = COLOR_DARK;
    CGRect selectframe = cell.bounds;
    selectframe.size.height -= 2.0f;
    UIView *selectbg = [[UIView alloc]initWithFrame:cell.bounds];
    UIImageView *selectimgbg = [[UIImageView alloc]initWithFrame:cell.bounds];
    selectimgbg.image = [UIImage imageNamed:@"cell_selected_bg.png"];
    UIImageView *selectimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 5, cell.frame.size.height-1)];
    selectimg.image = [UIImage imageNamed:@"cell_selected_line.png"];
    [selectbg addSubview:selectimgbg];
    [selectbg addSubview:selectimg];
    cell.selectedBackgroundView = selectbg;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:255.0/255 green:113.0/255 blue:0 alpha:1.0];
}*/

@end
