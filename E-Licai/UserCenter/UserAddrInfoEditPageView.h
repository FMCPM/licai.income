//
//  BuyGoodsFlowPopView.h

//
//  Created by lzq on 2014-03-04.
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "QDataSetObj.h"
#import "SetRowObj.h"

@protocol UserAddrInfoEditPageViewDelegate <NSObject>
@optional
-(void)actionEndUserAddrInfoEditPageView;
@end

@interface UserAddrInfoEditPageView : UIViewController <UIScrollViewDelegate,UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource,UITableViewDelegate>
{
    int               m_isDefault; //0_非默认地址，1_默认收货地址
    int               m_iEditType; //1_新增，2_修改
    bool m_bShowKeyboard;
    SetRowObj         *m_pAddrDetail;
    SetRowObj         *m_originalAddrDetail;
   // NSString          *m_iCountyId;
  //  NSString          *m_strDistrictFullName;
    float               m_offsetToMove;
    NSString *m_strContact;
    NSString *m_strAddress;
    NSString *m_strMobile;
    NSString *m_strPhone;
    NSString *m_strZipCode;
    NSString *m_addressId;
    
    UITextField*      m_pCurEditingField;
    UITextView *m_pCurTextViewField;
    UITapGestureRecognizer *m_pTapGesture;
    
    int m_iTableHeight;
}

@property (nonatomic, assign) int iEditType;
@property (nonatomic, strong) SetRowObj *pAddrDetail;
@property (nonatomic, strong) NSString *m_strCountryId;
@property (nonatomic, strong) NSString *m_strDistrictFullName; //地区全名，例如“浙江省杭州市西湖区”

@property (strong, nonatomic) IBOutlet UITableView  *m_uiAddrTableView;
//@property (strong, nonatomic) IBOutlet UIScrollView *m_uiAddrScrollView;
@property (nonatomic,strong)id <UserAddrInfoEditPageViewDelegate> m_pCellDelegate;
@property(nonatomic,assign) bool m_blEditing;

@property (assign,nonatomic)NSInteger   m_iViewShowType;

@end
