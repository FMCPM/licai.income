

#import <UIKit/UIKit.h>



@interface SignMsgButton : UIButton {

    NSTimer*    m_waitTimer;
    NSInteger   m_iWaitTimeCount;

}

@property(nonatomic,strong)UILabel* m_uiTitleLabel;

-(id)initWithFrame:(CGRect)frame;
-(void)addTitleLabel;

//启动倒计时
-(void)startWait;
//完成倒计时
-(void)stopWait;
@end
