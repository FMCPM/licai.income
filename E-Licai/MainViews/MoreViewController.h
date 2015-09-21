//
//  MoreViewController.h
//
//  叮叮理财 - 更多
//
//  Created by lzq on 2014-12-24.
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "QDataSetObj.h"
#import "StartWeiXinAppPopupView.h"
#import "MultInfoSharePopView.h"

@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,StartWeiXinAppPopupViewDelegate,MultInfoSharePopViewDelegate>
{
    QDataSetObj* m_pInfoDataSet;
    
    StartWeiXinAppPopupView* m_uiWxPopupView;
}
@property (strong, nonatomic) IBOutlet UITableView *m_uiTableView;
//清除缓存：主要是图片缓存
-(void)actionWipeCache;
@end
