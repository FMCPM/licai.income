//
//  MultInfoSharePopView.m

//
//  Created by lzq on 2014-03-04.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//


#import "MultInfoSharePopView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Hex.h"
#import "GlobalDefine.h"
#import "UILabel+CKKit.h"
#import "InfoShareMethod.h"
#import "SVProgressHUD.h"
#import "UIOwnSkin.h"

@implementation MultInfoSharePopView

@synthesize m_pShareDelegate = _pShareDelegate;
@synthesize m_uiShareTableView = _uiShareTableView;
@synthesize m_strShareImageUrl = _strShareImageUrl;

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(UIImage*)pImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
        m_strInfoTitle = strTitle;
        m_strInfoContent = strContent;
        m_strInfoUrl = strUrl;
        m_pInfoImage = pImage;
        self.backgroundColor = [UIColor whiteColor];
        [self initializeWithFrame:frame];
        
    }
    return self;
}

-(void)initializeWithFrame:(CGRect)frame

{
    _uiShareTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _uiShareTableView.backgroundColor  = [UIColor whiteColor];
    _uiShareTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _uiShareTableView.separatorColor = [UIColor clearColor];
    
    _uiShareTableView.showsVerticalScrollIndicator = NO;
    _uiShareTableView.showsHorizontalScrollIndicator = NO;
    _uiShareTableView.dataSource = self;
    _uiShareTableView.delegate = self;
    [self addSubview:_uiShareTableView];
    
    //
    /*
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
    frame.size.height  = iHeight;
	_uiFilterTableView1.frame = frame;
    
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_uiFilterTableView1 cache:YES];
    [UIView commitAnimations];
*/
}


-(void)initInfoShareButtons:(UITableViewCell*)pCellObj
{
    

    NSArray *arTitleList = [[NSArray alloc] initWithObjects:@"qq好友",@"微信",@"微信朋友圈",@"新浪微博", nil];

    
    NSArray* arImgNameList = [[NSArray alloc] initWithObjects:@"sns_qq.png",@"sns_wx.png",@"sns_wxq.png",@"sns_sina.png",nil];
    int iTopX = 10;
    int iTopY = 10;
    
    for (int i=0; i<arTitleList.count; i++)
    {
        UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
        if(i < 4)
        {
            iTopY = 10;
        }
        else
        {
            iTopY = 120;
        }
        if(i % 4 == 0)
            iTopX = 10;
        pButton.frame = CGRectMake(iTopX , iTopY,60 , 60);
        pButton.autoresizesSubviews =YES;
        
        [pButton addTarget:self action:@selector(onInfoShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        pButton.backgroundColor = [UIColor clearColor];
        UIImage* pBgImage = [UIImage imageNamed:[arImgNameList objectAtIndex:i]];
        [pButton setImage:pBgImage forState:UIControlStateNormal];
        pButton.tag = 100+i+1;
        [pCellObj.contentView addSubview:pButton];
        
    
       // UILabel*pHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(iTopX, iTopY+66, 60, 21)];
        UILabel*pHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(iTopX-5, iTopY+66, 70, 21)];
        pHintLabel.font = [UIFont systemFontOfSize:12];
        pHintLabel.textColor = [UIColor lightGrayColor];
        pHintLabel.text = [arTitleList objectAtIndex:i];
        pHintLabel.textAlignment = UITextAlignmentCenter;
        pHintLabel.backgroundColor = [UIColor clearColor];
        [pCellObj.contentView addSubview:pHintLabel];
        
        iTopX = iTopX + 10 + 60;
        
    }
   
}

//
-(void)onInfoShareButtonClicked:(id)sender
{
    if(_pShareDelegate == nil)
        return;
    if([_pShareDelegate respondsToSelector:@selector(onShareButtonClicked:andTitile:andContent:andShareUrl:andImgUrl:)] == false)
        return;
    UIButton*pButton = (UIButton*)sender;
    if(pButton == nil)
        return;
    int iTag = pButton.tag -100;
    [_pShareDelegate onShareButtonClicked:iTag andTitile:m_strInfoTitle andContent:m_strInfoContent andShareUrl:m_strInfoUrl andImgUrl:_strShareImageUrl];
    
    
}

-(void)actionCancelShareClicked:(id)sender
{
    if(_pShareDelegate == nil)
        return;
    if([_pShareDelegate respondsToSelector:@selector(onShareButtonClicked:andTitile:andContent:andShareUrl:andImgUrl:)] == false)
        return;

    [_pShareDelegate onShareButtonClicked:0 andTitile:m_strInfoTitle andContent:m_strInfoContent andShareUrl:m_strInfoUrl andImgUrl:_strShareImageUrl];
}


#pragma UITableViewDataSource , UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
       return 40;

    if(indexPath.row == 1)
    {
        return  100;
    }
    return 50;
}

-(UITableViewCell*)getTopBarInfoTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString* strTopBarInfoTableCellId = @"TopBarInfoTableCellId";
    UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTopBarInfoTableCellId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTopBarInfoTableCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.contentView.backgroundColor = COLOR_VIEW_BK_01;
        

        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.tag = 1001;
        pLabel.numberOfLines  = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        [pCellObj.contentView addSubview:pLabel];
        
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, pCellObj.contentView.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        pLineView.tag = 2001;
        [pCellObj.contentView addSubview:pLineView];
    }
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel == nil)
        return pCellObj;
    if(indexPath.row == 0)
    {
        pLabel.text = @"转发到：";
    }

    return pCellObj;
}

/*
-(UITableViewCell*)getShareInfoCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString* strShareInfoTableCellId = @"ShareInfoTableCellId";
    UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strShareInfoTableCellId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strShareInfoTableCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        
        int iLeftX = 10;
        if(m_pInfoImage)
        {
            UIImageView* pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
            pImageView.tag = 1001;
            [pCellObj.contentView addSubview:pImageView];
            iLeftX = 100;
        }
        
        
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 10, self.frame.size.width-iLeftX-10, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.tag = 1002;
        pLabel.numberOfLines  = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        [pCellObj.contentView addSubview:pLabel];
        int iTop = 59;
        if(m_pInfoImage != nil)
            iTop = 99;
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, pCellObj.contentView.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
    }
    if(m_pInfoImage)
    {
        
        UIImageView* pImageView = (UIImageView*)[pCellObj.contentView viewWithTag:1001];
        if(pImageView)
            pImageView.image = m_pInfoImage;
    }
    
    
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        int iWidth = 0;
        if(m_pInfoImage == nil)
            iWidth = self.frame.size.width - 20;
        else
            iWidth = self.frame.size.width - 110;
        int iHeight = [UILabel getFitTextHeightWithText:m_strInfoContent andWidth:iWidth andFont:[UIFont systemFontOfSize:14]];

        CGRect rcFame = pLabel.frame;
        rcFame.size.height = iHeight;
        pLabel.frame = rcFame;
        pLabel.text = m_strInfoContent;
    }
    return pCellObj;
}
*/

-(UITableViewCell*)getInfoShareButtonsCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString* strInfoShareButtonsCellId = @"InfoShareButtonsCellId";
    UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strInfoShareButtonsCellId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strInfoShareButtonsCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        [self initInfoShareButtons:pCellObj];
    }
    return pCellObj;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iCellRow = indexPath.row;
    
    UITableViewCell* pCellObj = nil;
    
    if(iCellRow == 0 )
    {
        pCellObj = [self getTopBarInfoTableCell:tableView andIndexPath:indexPath];
        return pCellObj;
    }
    if(iCellRow == 1)
    {
        pCellObj = [self getInfoShareButtonsCell:tableView andIndexPath:indexPath];
        return  pCellObj;
    }
    
    static NSString* strShareCancelButtonCellId = @"ShareCancelButtonCellId";
    pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strShareCancelButtonCellId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strShareCancelButtonCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 7, self.frame.size.width-20, 35);
        [UIOwnSkin setButtonBackground:pButton];
        [pButton setTitle:@"取消" forState:UIControlStateNormal];
        pButton.tag = 3001;
        [pButton addTarget:self action:@selector(actionCancelShareClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        
    }
    return pCellObj;
    
}


@end
