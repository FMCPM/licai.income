//
//  RatingViewController.h
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RatingViewDelegate
-(void)ratingChanged:(float)newRating;
@end


@interface RatingView : UIView 
{
	UIImageView *m_uiImageView1, *m_uiImageView2, *m_uiImageView3, *m_uiImageView4, *m_uiImageView5;
    NSArray* m_arImageViewList;
	UIImage *m_unselectedImage, *m_partlySelectedImage, *m_fullySelectedImage;
	
 //   id<RatingViewDelegate> viewDelegate;

    //上一次星星的位置
    float m_fLastMarkValue;
    //星星位置的整数信息(也就是评分信息)
    NSInteger m_iMarkValue;
    //星星图片的高度和宽
    float m_fStarImgHeight,m_fStarImgWidth;
    
    bool m_blHaveCreateView;
    //标识是否可以修改星星的显示
    bool m_blCanUpdate;
    
    NSInteger   m_iSpanValue;
	//float height, width; // of each image of the star!
}

@property (nonatomic, strong) UIImageView *m_uiImageView1;
@property (nonatomic, strong) UIImageView *m_uiImageView2;
@property (nonatomic, strong) UIImageView *m_uiImageView3;
@property (nonatomic, strong) UIImageView *m_uiImageView4;
@property (nonatomic, strong) UIImageView *m_uiImageView5;
@property (nonatomic, assign) NSInteger m_iMarkValue;
//创建视图
-(void)createRatingViews:(bool)blUpdate andHeight:(NSInteger)iHeight andSpan:(NSInteger)iSpan;

//显示星星的信息
-(void)showRatingImageView:(float)fValue;
@end
