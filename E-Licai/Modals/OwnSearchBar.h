
//
//  OwnSearchBar.h
//
//  Created by lzq on 14-3-16.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//


@protocol OwnSearchBarDelegate <NSObject>

@optional

-(void)onEndQuickSearch:(NSString*)strQueryText;
-(void)startTextFeildEditing;

@end

@interface OwnSearchBar : UIView
{
    bool m_blHideKeyboard;
    UITapGestureRecognizer* m_ptapGesture;
    NSInteger   m_iViewType;//0_默认;1_首页上，不能输入具体的信息
}

@property (assign, nonatomic) id <OwnSearchBarDelegate> m_pSearchDelegate;
@property (strong, nonatomic) IBOutlet UITextField       *m_uiSeachTextField;
@property (strong, nonatomic) IBOutlet UIButton*       m_uiSeachButton;

- (id)initWithNavBarFrame:(CGRect)frame andViewType:(NSInteger)iViewType;

-(void)setHintText:(NSString*)strText;
-(NSString*)getKeywordText;
-(void)hidleKeyboard;
-(void)setSearchKeyword:(NSString*)strKeyword;
-(bool)isHaveHidleKeyboard;

@end


