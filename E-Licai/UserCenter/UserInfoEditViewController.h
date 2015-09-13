//
//  UserInfoEditViewController.h
//  YTSearch
//
//  Created by jiangjunchen on 12-12-2.
//
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "QDataSetObj.h"

@interface UserInfoEditViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    __weak UITextField *_fieldUserName;
    __weak UITextField *_fieldLinkNumber;
    __weak UITextField *_fieldEmail;
    NSString *_strUserName;
    NSString *_strLinkNumber;
    NSString *_strEmail;
}

@property (strong ,nonatomic) IBOutlet UITableView *m_uiEditTable;
@property (strong, nonatomic) QDataSetObj *m_setUserInfo;

//-(IBAction)actionReturnBack:(id)sender;
-(void)actionTextFieldEditingDidEnd:(id)sender;
-(void)startWebService;
@end
