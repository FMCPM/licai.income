
//
//  OwnSearchBar.h
//
//  Created by lzq on 14-3-16.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import "OwnSearchBar.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>

@implementation OwnSearchBar
@synthesize m_pSearchDelegate  = _pSearchDelegate;
@synthesize m_uiSeachButton = _uiSeachButton;
@synthesize m_uiSeachTextField = _uiSeachTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor  = [UIColor whiteColor];
        self.layer.borderColor = COLOR_BUTTON_RECT.CGColor;
        self.layer.borderWidth  = 1.0f;
        self.layer.cornerRadius = 1.0f;
        
        int iTopY = (frame.size.height- 21)/2;
        int iWidth = frame.size.width - 10-40;
        
        CGRect rcTextField = CGRectMake(10, iTopY, iWidth, 21);
        _uiSeachTextField = [[UITextField alloc] initWithFrame:rcTextField];
        _uiSeachTextField.textColor = COLOR_FONT_1;
        _uiSeachTextField.font  =[UIFont systemFontOfSize:14];
        
        _uiSeachTextField.returnKeyType  = UIReturnKeySearch;
        _uiSeachTextField.textAlignment  = UITextAlignmentCenter;
        _uiSeachTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _uiSeachTextField.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        _uiSeachTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
        [_uiSeachTextField addTarget:self action:@selector(actionTextEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [_uiSeachTextField addTarget:self action:@selector(actionTextEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        [_uiSeachTextField addTarget:self action:@selector(actionTextEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [self addSubview:_uiSeachTextField];
        
        CGRect rcButton = CGRectMake(iWidth+10, 0, 40, self.frame.size.height);
        _uiSeachButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _uiSeachButton.frame = rcButton;
        [_uiSeachButton setBackgroundColor:COLOR_BUTTON_RECT];
        
        //[_uiSeachButton setImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
        UIImageView* pBtnImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        pBtnImgView.image = [UIImage imageNamed:@"btn_search.png"] ;
        [_uiSeachButton addSubview:pBtnImgView];
        
        _uiSeachButton.layer.borderColor = COLOR_BUTTON_RECT.CGColor;
        _uiSeachButton.layer.borderWidth  = 1.0f;
        _uiSeachButton.layer.cornerRadius = 1.0f;
        [_uiSeachButton addTarget:self action:@selector(submitQuickSearch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_uiSeachButton];
        
        m_blHideKeyboard = true;
    }
    return self;
}
- (id)initWithNavBarFrame:(CGRect)frame andViewType:(NSInteger)iViewType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor  = [UIColor whiteColor];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth  = 1.0f;
        self.layer.cornerRadius = 5.0f;
        
        int iTopY = (frame.size.height- 21)/2;
        int iWidth = frame.size.width - 10- 35;
        
        CGRect rcTextField = CGRectMake(5, iTopY, iWidth, 21);
        _uiSeachTextField = [[UITextField alloc] initWithFrame:rcTextField];
        _uiSeachTextField.textColor = COLOR_FONT_1;
        _uiSeachTextField.font  =[UIFont systemFontOfSize:14];
        
        _uiSeachTextField.returnKeyType  = UIReturnKeySearch;
        _uiSeachTextField.textAlignment  = UITextAlignmentCenter;
        _uiSeachTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		
        [_uiSeachTextField addTarget:self action:@selector(actionTextEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [_uiSeachTextField addTarget:self action:@selector(actionTextEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        [_uiSeachTextField addTarget:self action:@selector(actionTextEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [self addSubview:_uiSeachTextField];
        if(iViewType == 1)
        {
            _uiSeachTextField.userInteractionEnabled = NO;
            m_ptapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTextFieldView:)];
            [self addGestureRecognizer:m_ptapGesture];
        }
        else
        {
            m_ptapGesture = nil;
        }
        
        
        CGRect rcButton = CGRectMake(iWidth+10, 0, 35, self.frame.size.height);
        _uiSeachButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _uiSeachButton.frame = rcButton;
        //[_uiSeachButton setBackgroundColor:COLOR_BUTTON_RECT];
        
        //[_uiSeachButton setImage:[UIImage imageNamed:@"btn_search_dark.png"] forState:UIControlStateNormal]
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [_uiSeachButton addSubview:pLineView];
        
        UIImageView*pSearchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 20, 20)];
        //pSearchImgView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        pSearchImgView.image = [UIImage imageNamed:@"btn_search_dark.png"];
        [_uiSeachButton addSubview:pSearchImgView];
        
        [_uiSeachButton addTarget:self action:@selector(submitQuickSearch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_uiSeachButton];
        
        m_blHideKeyboard = true;
    }
    return self;
}

-(void)setHintText:(NSString*)strText
{
    _uiSeachTextField.placeholder = strText;
}

-(NSString*)getKeywordText
{
    return _uiSeachTextField.text;
}

-(void)submitQuickSearch:(id)sender
{
    [_uiSeachTextField resignFirstResponder];
    if(_pSearchDelegate == nil)
        return;
    if([_pSearchDelegate respondsToSelector:@selector(onEndQuickSearch:)] == false)
        return;
    [_pSearchDelegate onEndQuickSearch:_uiSeachTextField.text];
}

-(void)actionTextEditingDidBegin:(id)sender
{
    m_blHideKeyboard = false;
	if (_pSearchDelegate ==nil) {
		return;
	}
	if ([_pSearchDelegate respondsToSelector:@selector(startTextFeildEditing)]==false) {
		return;
	}
	[_pSearchDelegate startTextFeildEditing];

}

-(void)actionTextEditingDidEnd:(id)sender
{
    //[_uiSeachTextField resignFirstResponder];
    [_uiSeachTextField resignFirstResponder];
    m_blHideKeyboard = true;
}

-(void)actionTextEditingDidEndExit:(id)sender
{
    
    [self submitQuickSearch:sender];
}

-(void)hidleKeyboard
{
    [_uiSeachTextField resignFirstResponder];
    m_blHideKeyboard = true;
}

-(void)setSearchKeyword:(NSString*)strKeyword
{
    _uiSeachTextField.text = strKeyword;
}

-(bool)isHaveHidleKeyboard
{
    return m_blHideKeyboard;
}

-(void)tapOnTextFieldView:(id)sender
{

	if (_pSearchDelegate ==nil) {
		return;
	}
	if ([_pSearchDelegate respondsToSelector:@selector(startTextFeildEditing)]==false) {
		return;
	}
	[_pSearchDelegate startTextFeildEditing];
}

@end
