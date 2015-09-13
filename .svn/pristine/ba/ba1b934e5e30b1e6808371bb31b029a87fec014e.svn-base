

#import "SignMsgButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIOwnSkin.h"
#import "GlobalDefine.h"

@implementation SignMsgButton
@synthesize m_uiTitleLabel = _uiTitleLabel;


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {

    }
    
    return self;
}

-(void)addTitleLabel
{
    m_waitTimer = nil;
    m_iWaitTimeCount = 0;
    _uiTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _uiTitleLabel.textAlignment = UITextAlignmentCenter;
    _uiTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_uiTitleLabel];
}
//
-(void)startWait
{
    //默认为1秒钟
    if(m_waitTimer != nil )
    {
        return;
    }
    m_iWaitTimeCount = 0;
    NSTimeInterval  detctTime = 1;
    m_waitTimer = [NSTimer scheduledTimerWithTimeInterval:detctTime target:self selector:@selector(waitingForSignMsg:) userInfo:nil repeats:YES];
    self.enabled = NO;
    _uiTitleLabel.text = @"60秒后可重发";
    [UIOwnSkin setButtonBackground:self andColor:COLOR_BTN_BORDER_1];
}

-(void)waitingForSignMsg:(id)sender
{
    
    m_iWaitTimeCount++;
    
    if(m_iWaitTimeCount >= 60 )
    {
        // btnGetCode.enabled = YES;
        self.enabled = YES;
        _uiTitleLabel.text = @"重发短信码";
        [m_waitTimer invalidate];
        m_waitTimer = nil;
        [UIOwnSkin setButtonBackground:self andColor:COLOR_BTN_BORDER_2];
    }
    else
    {
        
        NSString* strTitle = [NSString stringWithFormat:@"%d秒后可重发",60-m_iWaitTimeCount];
        _uiTitleLabel.text = strTitle;

    }
    
}

//完成倒计时
-(void)stopWait
{
    self.enabled = YES;
    _uiTitleLabel.text = @"重发短信码";
    [m_waitTimer invalidate];
    m_waitTimer = nil;
    [UIOwnSkin setButtonBackground:self andColor:COLOR_BTN_BORDER_2];
}
@end