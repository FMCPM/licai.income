//
//  RightNavItemView.h
//
//  自定义的视图顶部右边的视图
//
//  Created by lzq on 2012-11-15.
//

#import <UIKit/UIKit.h>

@protocol RightNavItemViewDelegate;

@interface RightNavItemView : UIView
{
    NSInteger   m_iViewType;
}

@property (strong, nonatomic) UILabel *m_uiTitleLabel;
@property (strong, nonatomic) UIButton *m_uiImageBtn;
@property (nonatomic, strong) id <RightNavItemViewDelegate> m_pNavItemDelegate;

-(id)initWithFrame:(CGRect)frame andType:(NSInteger)iViewType;

-(void)setItemTitle:(NSString*)strTitile;
-(void)setNewViewSize:(NSInteger)iWidth;

@end


@protocol RightNavItemViewDelegate <NSObject>
@optional
-(void)actionRightNavItemClicked:(id)Sender;
@end
