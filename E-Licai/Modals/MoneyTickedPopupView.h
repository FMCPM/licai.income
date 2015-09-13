
//
//  MoneyTickedPopupView.h
//
//  虚拟代金券弹出视图
//
//  Created by lzq on 2014-12-22.
//  Copyright (c) 2014年
//


#import <UIKit/UIKit.h>
#import "QDataSetObj.h"

@protocol MoneyTickedPopupViewDelegate <NSObject>
@optional
-(void)onEndSelectedCellInfo:(NSString*)strCellId andName:(NSString*)strCellName andFee:(NSString*)strCellFee;
@end

@interface MoneyTickedPopupView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    
    NSMutableArray* m_arDataList;
    
}

@property (strong, nonatomic) UITableView *m_uiFirstTable;
@property (assign, nonatomic) id <MoneyTickedPopupViewDelegate> m_switchDelegate;
@property (assign, nonatomic) NSInteger m_iCurrentSelCellRow;


-(id)initWithFrame:(CGRect)frame andData:(NSMutableArray*)arDataList andTitle:(NSString*)strTitle;


@end


