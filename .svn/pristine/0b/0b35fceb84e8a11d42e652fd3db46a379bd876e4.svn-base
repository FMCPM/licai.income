//
//  DDUserSignInfoPageView.h

//  我的叮叮 - 支付身份信息确认
//
//  Created on 2014-11-20.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"

@protocol UserIdSignInfoPopupViewDelegate <NSObject>
@optional
-(void)onUserIdSignInfoClicked:(NSString*)strCardId andName:(NSString*)strUserName;
@end


@interface UserIdSignInfoPopupView : UIView <UITableViewDataSource ,UITableViewDelegate>
{
    
    NSString*       m_strUserReallyName;
    NSString*       m_strUserCardId;
    
    UITextField*    m_uiCurEditingField;    
    UITapGestureRecognizer* m_pTapGesture;
    
    float           m_offsetToMove;

}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;

@property (assign, nonatomic) id <UserIdSignInfoPopupViewDelegate> m_pSignInfoDelegate;

-(id)initWithFrame:(CGRect)rTable andName:(NSString*)strName andId:(NSString*)strCardId;

@end
