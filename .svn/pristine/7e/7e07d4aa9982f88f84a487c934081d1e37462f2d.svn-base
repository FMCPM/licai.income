//
//  MyDdCenterMidTableCell.m
//  我的叮叮-中间部分的三个按钮对应的Cell
//
//  Created by lzq on 2014-11-22.
//
//

#import "MyDdCenterMidTableCell.h"
#import "GlobalDefine.h"


@implementation MyDdCenterMidTableCell

@synthesize m_uiDdButton1 = _uiDdButton1;
@synthesize m_uiDdButton2 = _uiDdButton2;
@synthesize m_uiDdButton3 = _uiDdButton3;
@synthesize m_pCellDelegate = _pCellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)initCellDefaultSet
{
    self.contentView.backgroundColor = COLOR_VIEW_BACKGROUND;
    
    //总资产部分
    UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 90, 20)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = COLOR_FONT_1;
    pLabel.font = [UIFont systemFontOfSize:11];
    pLabel.textAlignment = UITextAlignmentCenter;
    pLabel.text = @"总资产(元)";
    [_uiDdButton1 addSubview:pLabel];
    
    m_uiTotalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 90, 20)];
    m_uiTotalMoneyLabel.backgroundColor = [UIColor clearColor];
    m_uiTotalMoneyLabel.textColor = COLOR_FONT_1;
    m_uiTotalMoneyLabel.font = [UIFont systemFontOfSize:14];
    m_uiTotalMoneyLabel.textAlignment = UITextAlignmentCenter;
    m_uiTotalMoneyLabel.text = @"";
    [_uiDdButton1 addSubview:m_uiTotalMoneyLabel];
    
    
    //持有资产
    pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 90, 15)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = COLOR_FONT_1;
    pLabel.font = [UIFont systemFontOfSize:11];
    pLabel.textAlignment = UITextAlignmentCenter;
    pLabel.text = @"持有资产(元)";
    [_uiDdButton2 addSubview:pLabel];
    
    pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 38, 90, 15)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = COLOR_FONT_2;
    pLabel.font = [UIFont systemFontOfSize:10];
    pLabel.textAlignment = UITextAlignmentCenter;
    pLabel.text = @"含未结算收益";
    [_uiDdButton2 addSubview:pLabel];
    
    m_uiHoldMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 90, 20)];
    m_uiHoldMoneyLabel.backgroundColor = [UIColor clearColor];
    m_uiHoldMoneyLabel.textColor = COLOR_FONT_1;
    m_uiHoldMoneyLabel.font = [UIFont systemFontOfSize:14];
    m_uiHoldMoneyLabel.textAlignment = UITextAlignmentCenter;
    m_uiHoldMoneyLabel.text = @"1800.00";

    [_uiDdButton2 addSubview:m_uiHoldMoneyLabel];
    
    
    //账号余额
    pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 90, 15)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = COLOR_FONT_1;
    pLabel.font = [UIFont systemFontOfSize:11];
    pLabel.textAlignment = UITextAlignmentCenter;
    pLabel.text = @"账户余额(元)";
    [_uiDdButton3 addSubview:pLabel];
    
    pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 38, 90, 15)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = COLOR_FONT_2;
    pLabel.font = [UIFont systemFontOfSize:10];
    pLabel.textAlignment = UITextAlignmentCenter;
    pLabel.text = @"目前只支持贷款类";
    [_uiDdButton3 addSubview:pLabel];
    
    m_uiLeftMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 90, 20)];
    m_uiLeftMoneyLabel.backgroundColor = [UIColor clearColor];
    m_uiLeftMoneyLabel.textColor = COLOR_FONT_1;
    m_uiLeftMoneyLabel.font = [UIFont systemFontOfSize:14];
    m_uiLeftMoneyLabel.textAlignment = UITextAlignmentCenter;
    m_uiLeftMoneyLabel.text = @"";
    [_uiDdButton3 addSubview:m_uiLeftMoneyLabel];
    
  //  [self drowLineToLinkCircle];
}


-(void)drawRect:(CGRect)rect
{
    /*
    //获得处理的上下文
    
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    //指定直线样式
    
    CGContextSetLineCap(context,
                        kCGLineCapSquare);
    
    //直线宽度
    
    CGContextSetLineWidth(context,
                          2.0);
    
    //设置颜色
    
    CGContextSetRGBStrokeColor(context,
                               253/255.0, 167/255.0, 255.0, 1.0);
    //开始绘制
    
    CGContextBeginPath(context);
    
    //画笔移动到点(31,170)
    
    CGContextMoveToPoint(context,
                         10, 90);
    
    //下一点
  //  CGContextAddLineToPoint(context,
   //                         140, 90);
    
    CGContextAddLineToPoint(context,
                            300, 110);
    
 
    
    //绘制完成
    
    CGContextStrokePath(context);
     */
    
    UIImageView* imageView=[[UIImageView alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:imageView];
    
   // self.view.backgroundColor=[UIColor blueColor];
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
    
    //线条一
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 135, 108);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 115, 130);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    
    
    //线条二
    //CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 185, 108);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 205, 130);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

-(IBAction)actionButtonClicked:(id)sender
{
    UIButton* pButton = (UIButton*)sender;
    if(pButton == nil)
        return;
    int iTag = pButton.tag;
    if(_pCellDelegate == nil)
        return;
    if([_pCellDelegate respondsToSelector:@selector(actionDDCenterButtonClicked:)])
    {
        [_pCellDelegate actionDDCenterButtonClicked:iTag-1000];
    }
    
    
}

-(void)showMidCellInfo:(NSString*)strTotalMoney andHoldMoney:(NSString*)strHoldMoney andLeftMoney:(NSString*)strLeftMoney
{
    m_uiTotalMoneyLabel.text = strTotalMoney;
    m_uiHoldMoneyLabel.text  = strHoldMoney;
    m_uiLeftMoneyLabel.text = strLeftMoney;
    
}


@end
