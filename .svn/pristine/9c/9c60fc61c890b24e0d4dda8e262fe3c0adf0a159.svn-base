//
//  AboutUsViewController.m
//  E-YellowPage
//
//  Created by jiangjunchen on 12-12-28.
//  Copyright (c) 2012年 ytinfo. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView  = [UIOwnSkin navibarTitleView:@"关于我们" andFrame:CGRectMake(0, 0, 100, 40)];
    
    if ([self.navigationController.viewControllers indexOfObject:self] == 0)
    {
            self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(actionReturn:)];
        /*
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(actionReturn:)];
        self.navigationItem.leftBarButtonItem = leftItem;*/
    }
    else
    {
      self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    }
    
    UILabel* pLabel = (UILabel*)[self.view viewWithTag:1001];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    pLabel = (UILabel*)[self.view viewWithTag:1002];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }

    pLabel = (UILabel*)[self.view viewWithTag:1003];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)actionReturn:(id)sender
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}

-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
