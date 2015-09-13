//
//  GoodsBatchEditTableCell.h

//
//  Created by lzq on 2014-05-20.
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "QBImagePickerController.h"
#import "QDataSetObj.h"

@protocol GoodsMultLineImageCellDelegate <NSObject>
@optional

-(void)onActionAddOneGoodsImage:(NSInteger)iCellId;
-(void)onNeedRefreshTableViewCell:(NSInteger)iCellId;

@end

@interface GoodsMultLineImageCell : UIView<UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray* m_arPicIDList;
    NSMutableArray* m_arPicObjList;
    NSMutableArray* m_arButtonList;
    QDataSetObj*    m_pButtonDataSet;
    NSInteger       m_iCellHeight;
    NSInteger       m_iCellId;
    NSMutableDictionary*    m_dictImgIdUrlList;
}

@property (nonatomic, strong) id <GoodsMultLineImageCellDelegate> m_pCellDelegate;
@property (nonatomic, strong) UIView* m_uiSuperParentView;
@property (nonatomic, strong) UIButton* m_uiAddImageBtn;

-(id)initWithFrame:(CGRect)frame andCellId:(NSInteger)iCellId;
//点击添加按钮，新增一个图片
-(void)actionAddOneImageCliked:(id)sender;
//添加一个商品
-(void)AddOneGoodsImage:(UIImage*)pImage andId:(NSInteger)iImageId andFlag:(bool)blRefreshFlag;
//刷新显示
-(void)refreshImagesShow;
//统计cell的高度
-(void)statCellViewHeight;
//获取视图的高度
-(NSInteger)getCellViewHeight;
//收到图片后，刷新显示
-(void)setImageShow:(UIImage*)pImage andIndex:(NSInteger)iIndex;
//获取需要上传的图片的索引
-(NSInteger)getNeedUploadPicture;
//获取指定所以的图片
-(UIImage*)getImageByIndex:(NSInteger)iIndex;
//
-(bool)setImageIdByIndex:(NSInteger)iIndex andId:(NSInteger)iImageId andUrl:(NSString*)strImageUrl;
-(NSInteger)getTotalImageCount;
-(NSString*)getImageIdsList;
//获取可以直接在html页面显示的商品描述信息
-(NSString*)getGoodsMemoHtmlText:(NSString*)strGoodsMemo;
@end
