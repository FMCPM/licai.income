//
//  WaterFlowViewCell.h
//  WaterFlowViewDemo
//
//  Created by Smallsmall on 12-6-11.
//  Copyright (c) 2012年 activation group. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexPath;
@interface WaterFlowViewCell : UIView

@property (nonatomic,assign) int columnCount; 
@property (nonatomic, strong) IndexPath *indexPath;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSString *strReuseIndentifier;
@property (nonatomic, assign) CGFloat widthMargin;
@property (nonatomic, assign) CGFloat heightMargin;

-(id)initWithIdentifier:(NSString *)indentifier andFrame:(CGRect)frame;
-(id)initWithIdentifier:(NSString *)indentifier;
-(void)relayoutViews;

@end

@interface IndexPath : NSObject
{
    int _row;       //行号
    int _column;    //列号
}
@property(nonatomic,assign) int row;
@property(nonatomic,assign) int column;

+(IndexPath *)initWithRow:(int)indexRow withColumn:(int)indexColumn;

@end