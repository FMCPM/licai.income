
//
//  MiddleShowPopupView.h

//
//  Created by lzq on 14-3-16.
//  Copyright (c) 2014年
//


#import <UIKit/UIKit.h>
#import "QDataSetObj.h"

@protocol MiddleShowPopupViewDelegate <NSObject>
@optional
-(void)onEndSelectedCellInfo:(NSString*)strCellId andName:(NSString*)strCellName;
@end

@interface MiddleShowPopupView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    
    NSInteger       m_iViewShowType;
    NSMutableArray* m_arDataList;
    
}

@property (strong, nonatomic) UITableView *m_uiFirstTable;
@property (assign, nonatomic) id <MiddleShowPopupViewDelegate> m_switchDelegate;
@property (assign, nonatomic) NSInteger m_iCurrentSelCellRow;


-(id)initWithFrame:(CGRect)frame andViewType:(NSInteger)iViewType andData:(NSMutableArray*)arDataList;

-(NSInteger)getViewShowType;

@end


