//
//  ImageViewCell.m
//  WaterFlowViewDemo
//
//  Created by Smallsmall on 12-6-12.
//  Copyright (c) 2012年 activation group. All rights reserved.
//

#import "GoodsWaterViewCell.h"


#define TOPMARGIN 8.0f
#define LEFTMARGIN 8.0f

#define IMAGEVIEWBG [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]

@implementation GoodsWaterViewCell

@synthesize m_iCellRowIndex = _iCellRowIndex;
@synthesize m_pButton1 = _pButton1;
@synthesize m_pButton2 = _pButton2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initTableCellView];
        
    }
    return self;
}

-(void)initTableCellView
{

    //商品1按钮
    _pButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _pButton1.frame = CGRectMake(5, 10, 150, 150);
    _pButton1.tag = 2001;
    [self.contentView addSubview:_pButton1];
    
    //商品1
    m_pImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 150, 150)];
    m_pImageView1.layer.borderWidth = 1;
    m_pImageView1.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] CGColor];
    [self.contentView addSubview:m_pImageView1];
    
    UIImageView*pBkImgageView=  [[UIImageView alloc] initWithFrame:CGRectMake(5, 130, 150, 30)];
    pBkImgageView.backgroundColor = [UIColor darkGrayColor];
    pBkImgageView.alpha  =0.8;
    pBkImgageView.tag = 1001;
    [self.contentView addSubview:pBkImgageView];
    
    m_pPriceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, 150, 30)];
    m_pPriceLabel1.backgroundColor = [UIColor clearColor];
    m_pPriceLabel1.textColor = [UIColor whiteColor];
    m_pPriceLabel1.textAlignment  =UITextAlignmentCenter;
    m_pPriceLabel1.font  =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:m_pPriceLabel1];
    
    //商品2
    //商品2按钮
    _pButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _pButton2.frame = CGRectMake(165, 10, 150, 150);
    _pButton2.tag = 2002;
    [self.contentView addSubview:_pButton2];

    
    m_pImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(165, 10, 150, 150)];
    m_pImageView2.layer.borderWidth = 1;
    m_pImageView2.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] CGColor];
    [self.contentView addSubview:m_pImageView2];
    
    pBkImgageView=  [[UIImageView alloc] initWithFrame:CGRectMake(165, 130, 150, 30)];
    pBkImgageView.backgroundColor = [UIColor darkGrayColor];
    pBkImgageView.alpha  =0.8;
    pBkImgageView.tag = 1002;
    [self.contentView addSubview:pBkImgageView];
    
    m_pPriceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(165, 130, 150, 30)];
    m_pPriceLabel2.backgroundColor = [UIColor clearColor];
    m_pPriceLabel2.textColor = [UIColor whiteColor];
    m_pPriceLabel2.textAlignment  =UITextAlignmentCenter;
    m_pPriceLabel2.font  =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:m_pPriceLabel2];
    

}

//
-(void)setImage:(UIImage *)pImage andID:(NSInteger)iImageID andPrice:(NSString*)strPrice
{
    if(iImageID == 0)
    {
        
        m_pImageView1.image = pImage;
        m_pPriceLabel1.text = strPrice;
    }
    else
    {
        UIImageView*pBkImgView = (UIImageView*)[self.contentView viewWithTag:1002];
        if(pBkImgView == nil)
            return;
            
        if(pImage == nil)
        {
            [m_pImageView2 setHidden:YES];
            [m_pPriceLabel2 setHidden:YES];
            [pBkImgView setHidden:YES];
            return;
        }
        [m_pImageView2 setHidden:NO];
        [m_pPriceLabel2 setHidden:NO];
        [pBkImgView setHidden:NO];
        
        m_pImageView2.image = pImage;
        m_pPriceLabel2.text = strPrice;
    }
}

-(void)setImage:(UIImage*)pImage andKey:(NSString*)strKey
{
    if(strKey.length < 1)
        return;
    int iKey = strKey.intValue;
    
    int iImageId = iKey%2;
    if(iImageId == 0)
        m_pImageView1.image = pImage;
    else
        m_pImageView2.image = pImage;
}

@end
