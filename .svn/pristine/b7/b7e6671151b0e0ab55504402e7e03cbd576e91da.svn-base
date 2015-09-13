//
//  MultInfoSharePopView.h
//
//  Created by lzq on 2014-03-04.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "InfoShareMethod.h"

@protocol MultInfoSharePopViewDelegate <NSObject>

@optional
-(void)onShareButtonClicked:(NSInteger)iShareType andTitile:(NSString*)strTitle andContent:(NSString*)strContent andShareUrl:(NSString*)strShareUrl andImgUrl:(NSString*)strImgUrl  ;

@end


@interface MultInfoSharePopView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSString*   m_strInfoTitle;
    UIImage*    m_pInfoImage;
    NSString*   m_strInfoContent;
    NSString*   m_strInfoUrl;
}

@property (assign, nonatomic) id <MultInfoSharePopViewDelegate> m_pShareDelegate;
@property (strong, nonatomic)UITableView*  m_uiShareTableView;


-(id)initWithFrame:(CGRect)frame andTitle:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(UIImage*)pImage;

@property (nonatomic,strong)NSString*   m_strShareImageUrl;

@end


