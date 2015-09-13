//
//  LoginViewController.h
//  YTSearch
//
//  Created by jiangjunchen on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "ViewControllDismissDelegate.h"
#import <QuartzCore/QuartzCore.h>

@protocol LoginDelegate;

@interface LoginViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{

    UITextField*    m_uiCurEditingField;
    NSString*       m_strInputPhoneNum;
    NSString*       m_strInputPassword;
    UITapGestureRecognizer* m_pTapGesture;
    
    bool            m_blSelProtocol;
}

@property (strong ,nonatomic) IBOutlet UITableView * m_uiMainTableView;

//默认为0，1_我的叮叮这边登录;3_投标;4_更多
@property(assign,nonatomic)NSInteger m_iLoadOrigin;

@property (assign ,nonatomic) id <LoginDelegate> m_pLoginDelegate;
@end

@protocol LoginDelegate <NSObject>

@optional

-(void)onSelectedNoLoadInSystem;

@end
