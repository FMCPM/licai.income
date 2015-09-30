//
//  MyDdCenterNewBottomTableCell.m
//  E-Licai
//
//  Created by 求攻略 on 15/9/15.
//  Copyright (c) 2015年 ytinfo. All rights reserved.
//

#import "MyDdCenterNewBottomTableCell.h"
#import "GlobalDefine.h"

@implementation MyDdCenterNewBottomTableCell

- (void)awakeFromNib {
    
    self.contentLabel.textColor = COLOR_FONT_1;
    self.rightLabel.textColor = COLOR_FONT_2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
