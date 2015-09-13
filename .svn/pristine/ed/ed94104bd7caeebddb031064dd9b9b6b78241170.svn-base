//
//  WaterFlowViewCell.m
//  WaterFlowViewDemo
//
//  Created by Smallsmall on 12-6-11.
//  Copyright (c) 2012年 activation group. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WaterFlowViewCell.h"
#import "CKKit.h"
#define Shadow_Margin           4.0

@implementation WaterFlowViewCell
@synthesize columnCount = _columnCount;
@synthesize indexPath = _indexPath;
@synthesize strReuseIndentifier = _strReuseIndentifier;
@synthesize contentView = _contentView;
@synthesize widthMargin = _widthMargin;
@synthesize heightMargin = _heightMargin;

-(id)initWithIdentifier:(NSString *)indentifier andFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _widthMargin = 5.0;
        _heightMargin = 8.0;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [_contentView addObserver:self forKeyPath:@"frame" options:0 context:nil];
        _contentView.clipsToBounds = YES;
        [self addSubview:_contentView];
        self.strReuseIndentifier = indentifier;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(id)initWithIdentifier:(NSString *)indentifier
{
	if(self = [super init])
	{
		self.strReuseIndentifier = indentifier;
	}
	
	return self;
}

-(void)dealloc
{
    [_contentView removeObserver:self forKeyPath:@"frame"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:_contentView]) {
        [self setNeedsDisplay];
    }
}

-(void)setWidthMargin:(CGFloat)width
{
    _widthMargin = width;
    [self relayoutViews];
}

-(void)setHeightMargin:(CGFloat)height
{
    _heightMargin = height;
    [self relayoutViews];
}

-(void)relayoutViews{

    float originX = 0.0f;
    float originY = 0.0f;
    float width = 0.0f;
    float height = 0.0f;
    originY = _heightMargin;
    height = CGRectGetHeight(self.frame) - 2*_heightMargin;
    
    if (self.columnCount == 1) {
        originX = 2*_widthMargin;
        width = CGRectGetWidth(self.frame) - 4*_widthMargin;
    }
    else if (self.indexPath.column == 0) {
        
        originX = 2*_widthMargin;
        width = CGRectGetWidth(self.frame) - 3*_widthMargin;
    }else if (self.indexPath.column == self.columnCount - 1){
        
        originX = _widthMargin;
        width = CGRectGetWidth(self.frame) - 3*_widthMargin;
    }else{
        
        originX = _widthMargin;
        width = CGRectGetWidth(self.frame) - 2*_widthMargin;
    }
    self.contentView.frame = CGRectMake(originX, originY, width, height);
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect shadowrect = _contentView.frame;
    shadowrect.origin.x += 2.0;
    shadowrect.origin.y += 2.0;
    shadowrect.size.width -= 2.0*2;
    shadowrect.size.height -= 2.0*2;
    CGPathRef roundedRect = [UIBezierPath bezierPathWithRoundedRect:shadowrect cornerRadius:self.contentView.layer.cornerRadius].CGPath;
    
    CGContextAddPath(context, roundedRect);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1.5), 4, [UIColor darkGrayColor].CGColor);
    CGContextSetStrokeColorWithColor(context, self.contentView.backgroundColor.CGColor);
    CGContextStrokePath(context);
    [super drawRect:rect];
}
@end


@implementation IndexPath
@synthesize row = _row,column = _column;

+(IndexPath *)initWithRow:(int)indexRow withColumn:(int)indexColumn{

    IndexPath *indexPath = [[IndexPath alloc] init];
    indexPath.row = indexRow;
    indexPath.column = indexColumn;
    return indexPath; 
}

@end