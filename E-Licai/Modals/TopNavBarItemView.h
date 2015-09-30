//
//  TopNavBarItemView.h

//  每个页面顶部导航栏左边和右边的自定义的视图
//
//  Created by lzq on 2014-11-28.
//

#import <UIKit/UIKit.h>

@protocol TopNavBarItemViewDelegate;

@interface TopNavBarItemView : UIView
{
    NSInteger   m_iViewType;
}

@property (strong, nonatomic) UILabel *m_uiTitleLabel;
@property (strong, nonatomic) UIButton *m_uiImageBtn;
@property (nonatomic, strong) id <TopNavBarItemViewDelegate> m_pNavItemDelegate;

-(id)initWithFrame:(CGRect)frame andType:(NSInteger)iViewType;

-(void)setItemTitle:(NSString*)strTitile;
-(void)setNewViewSize:(NSInteger)iWidth;

@end


@protocol TopNavBarItemViewDelegate <NSObject>
@optional
-(void)actionTopNavBarItemClicked:(id)Sender;
@end
