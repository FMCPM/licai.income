//
//  SwitchCountryView.h
//  YTSearch
//
//  Created by jiang junchen on 12-11-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"

@protocol DropDownSwitchViewDelegate;

@interface DropDownSwitchView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_muFirstTableDic;
    NSMutableArray *_muSecondTableDic;
    
    NSString*     m_strCellName1;
    NSString*     m_strCellCode1;
    NSString*     m_strCellName2;
    NSString*     m_strCellCode2;
    
}

@property (strong, nonatomic) UITableView *m_uiFirstTable;
@property (strong, nonatomic) UITableView *m_uiSecondTable;


@property (assign, nonatomic) id <DropDownSwitchViewDelegate> m_switchDelegate;
@property (assign, nonatomic)  NSInteger m_iSwitchViewType;


-(id)initWithFrame:(CGRect)frame andViewType:(NSInteger)iViewType andClass:(NSMutableArray*)arClassList;


@end


@protocol DropDownSwitchViewDelegate <NSObject>
@optional
-(void)switchDropDownView:(NSInteger)iViewType andName:(NSString*)strCellname andID:(NSString*)strCellID;
@end