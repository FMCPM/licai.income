
//
//  DownToUpPopupView.h
//
//  Created by lzq on 14-3-16.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QDataSetObj.h"

@protocol DownToUpPopupViewDelegate <NSObject>
@optional
-(void)onEndSelectedCellInfo:(NSString*)strCellId andName:(NSString*)strCellName;
@end

@interface DownToUpPopupView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    
    NSInteger   m_iViewShowType;
    NSMutableArray* m_arDataList;
    UIView*     m_pShowRectView;
   
}

@property (strong, nonatomic) UITableView *m_uiFirstTable;
@property (assign, nonatomic) id <DownToUpPopupViewDelegate> m_switchDelegate;
@property (assign, nonatomic) NSInteger m_iCurrentSelCellRow;


-(id)initWithFrame:(CGRect)frame andViewType:(NSInteger)iViewType andData:(NSMutableArray*)arDataList;


@end


