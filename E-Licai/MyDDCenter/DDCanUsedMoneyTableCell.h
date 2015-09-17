//
//  DDCanUsedMoneyTableCell.h
//  E-Licai
//
//  Created by chaiweiwei on 15/9/17.
//  Copyright (c) 2015年 ytinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCanUsedMoneyTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *canUserMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tixianMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiButton;
- (IBAction)chongzhiAction:(id)sender;

@property (nonatomic,copy) void (^chongzhiActionBlockCallBack) (void);

@end
