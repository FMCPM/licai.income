//
//  DDLeftMoneyTableCellI.m
//  E-Licai
//
//  Created by chaiweiwei on 15/9/17.
//  Copyright (c) 2015年 ytinfo. All rights reserved.
//

#import "DDLeftMoneyTableCellI.h"
#import "GlobalDefine.h"

@implementation DDLeftMoneyTableCellI

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    NSString *string = [NSString stringWithFormat:@"账户余额(元)\n%@",title];
    
    NSMutableAttributedString *attrubutedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrubutedString addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_1 range:NSMakeRange(0, 7)];
    
    [attrubutedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f ] range:NSMakeRange(0, 7)];
    
    self.leftMoneyLabel.attributedText = attrubutedString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
