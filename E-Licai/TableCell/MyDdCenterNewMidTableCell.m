//
//  MyDdCenterNewMidTableCell.m
//  E-Licai
//
//  Created by 求攻略 on 15/9/15.
//  Copyright (c) 2015年 ytinfo. All rights reserved.
//

#import "MyDdCenterNewMidTableCell.h"
#import "GlobalDefine.h"

@implementation MyDdCenterNewMidTableCell

- (void)awakeFromNib {
    self.contentLabel.textColor = COLOR_FONT_1;
    self.moneyLabel.textColor = COLOR_FONT_7;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
