//
//  TopNavBarItemView.m

//  每个页面顶部导航栏左边和右边的自定义的视图
//
//  Created by lzq on 2014-11-28.
//

#import "TopNavBarItemView.h"
#import "UaConfiguration.h"
#import "UIColor+Hex.h"

@implementation TopNavBarItemView

@synthesize m_uiTitleLabel = _uiTitleLabel;
@synthesize m_uiImageBtn = _uiImageBtn;
@synthesize m_pNavItemDelegate = _pNavItemDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
         m_iViewType = 0;
        [self initializeWithFrame:frame];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andType:(NSInteger)iViewType
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
        [self initializeView:frame andType:iViewType];
    }
    return self;
}

//初始化
-(void)initializeWithFrame:(CGRect)frame
{

    int iTopY = (self.frame.size.height - 21)/2;
    _uiTitleLabel    =[[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, frame.size.width-10, 21)];
    _uiTitleLabel.text = @"";
    _uiTitleLabel.numberOfLines = 0;
    _uiTitleLabel.backgroundColor = [UIColor clearColor];
    _uiTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    _uiTitleLabel.textColor =[UIColor whiteColor];
    [_uiTitleLabel setShadowColor:[UIColor grayColor]];
    [_uiTitleLabel setShadowOffset:CGSizeMake(-1, 0)];
    
    _uiTitleLabel.textAlignment = UITextAlignmentRight;
    [self addSubview:_uiTitleLabel];
    
    _uiImageBtn    =[UIButton buttonWithType:UIButtonTypeCustom];
    _uiImageBtn.backgroundColor = [UIColor clearColor];
    _uiImageBtn.frame = CGRectMake(frame.size.width-10+4, iTopY+6, 10, 10);
    [_uiImageBtn addTarget:self action:@selector(actionViewClikect:) forControlEvents:UIControlEventTouchDown];
    UIImage*pImage=  [UIImage imageNamed:@"bg_downarrow.png"];
    [_uiImageBtn setImage:pImage forState:UIControlStateNormal];
    [self addSubview:_uiImageBtn];
    
  
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionViewClikect:)];
    [self addGestureRecognizer:tap];

}


//iViewType:0_图标在右，默认;1_图标在左
-(void)initializeView:(CGRect)frame andType:(NSInteger)iViewType 
{
    m_iViewType = iViewType;
    if(iViewType == 0)
    {
        [self initializeWithFrame:frame];
        return;
        
    }
    
    int iTopY = (self.frame.size.height - 21)/2;
    //先加按钮
    _uiImageBtn    =[UIButton buttonWithType:UIButtonTypeCustom];
    _uiImageBtn.backgroundColor = [UIColor clearColor];
    _uiImageBtn.frame = CGRectMake(2, iTopY+5, 10, 10);
    [_uiImageBtn addTarget:self action:@selector(actionViewClikect:) forControlEvents:UIControlEventTouchDown];
    UIImage*pImage =  nil;
    if(m_iViewType == 1)
    {
        pImage = [UIImage imageNamed:@"icon_refresh"];
    }
    
    [_uiImageBtn setImage:pImage forState:UIControlStateNormal];
    [self addSubview:_uiImageBtn];
    
    _uiTitleLabel    =[[UILabel alloc] initWithFrame:CGRectMake(20, iTopY, frame.size.width-20, 21)];
    _uiTitleLabel.text = @"";
    _uiTitleLabel.numberOfLines = 0;
    _uiTitleLabel.backgroundColor = [UIColor clearColor];
    _uiTitleLabel.font = [UIFont systemFontOfSize:14];
    _uiTitleLabel.textColor = COLOR_FONT_3;
        _uiTitleLabel.textAlignment = UITextAlignmentRight;
    [self addSubview:_uiTitleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionViewClikect:)];
    [self addGestureRecognizer:tap];
    
}

//设置title
-(void)setItemTitle:(NSString*)strTitile
{
    
    if(strTitile.length < 3)
        [self setNewViewSize:40];
    else if(strTitile.length < 4)
        [self setNewViewSize:55];
    else
    {
        [self setNewViewSize:75];
    }
    _uiTitleLabel.text = strTitile;
    
}

-(void)actionViewClikect:(id)sender
{
    if(!_pNavItemDelegate)
        return;
    if([_pNavItemDelegate respondsToSelector:@selector(actionTopNavBarItemClicked:)])
    {
        [_pNavItemDelegate actionTopNavBarItemClicked:sender];
    }
}


//设置显示区域
-(void)setNewViewSize:(NSInteger)iWidth
{
    CGRect rcBounds = self.frame;
    rcBounds.size.width = iWidth;
    self.frame = rcBounds;
    
    if(m_iViewType == 1)
    {
        rcBounds = _uiImageBtn.frame;
        rcBounds.origin.x = 2;
        _uiImageBtn.frame = rcBounds;
        
        rcBounds = _uiTitleLabel.frame;
        rcBounds.origin.x = 15;
        rcBounds.size.width = iWidth - 15;
        _uiTitleLabel.frame = rcBounds;
        _uiTitleLabel.textAlignment = UITextAlignmentLeft;
    }
    else
    {
        rcBounds = _uiTitleLabel.frame;
        rcBounds.size.width = iWidth - 10;
        _uiTitleLabel.frame = rcBounds;
        
        
        rcBounds = _uiImageBtn.frame;
        rcBounds.origin.x = iWidth - 10;
        _uiImageBtn.frame = rcBounds;
    }

}

@end
