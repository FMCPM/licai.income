//
//  DDCanUsedMoneyTableCell.m
//  E-Licai
//
//  Created by chaiweiwei on 15/9/17.
//  Copyright (c) 2015年 ytinfo. All rights reserved.
//

#import "DDCanUsedMoneyTableCell.h"

@implementation DDCanUsedMoneyTableCell

- (void)awakeFromNib {
    self.chongzhiButton.layer.masksToBounds = YES;
    self.chongzhiButton.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chongzhiAction:(id)sender {
    !self.chongzhiActionBlockCallBack?:self.chongzhiActionBlockCallBack();
}
@end
