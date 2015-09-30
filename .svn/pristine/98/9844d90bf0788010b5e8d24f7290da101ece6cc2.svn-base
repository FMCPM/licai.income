//
//  SYPageControl.m
//  SYPaginator
//
//  Created by Sam Soffes on 3/20/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import "SYPageControl.h"
#import "NSBundle+SYPaginator.h"
#import "GlobalDefine.h"

//static NSInteger const kSYPageControlMaxNumberOfDots = 12;
//默认改成20
static NSInteger const kSYPageControlMaxNumberOfDots = 20;


@interface SYPageControl ()
- (void)_updateTextLabel;
- (void)_pageControlChanged:(id)sender;
- (void)_labelTapped:(UITapGestureRecognizer *)gestureRecognizer;
@end

@implementation SYPageControl

@synthesize numberOfPages = _numberOfPages;
@synthesize currentPage = _currentPage;
@synthesize hidesForSinglePage = _hidesForSinglePage;
@synthesize pageControl = _pageControl;
@synthesize textLabel = _textLabel;

- (void)setNumberOfPages:(NSInteger)numberOfPages {
	_numberOfPages = numberOfPages;
	if (numberOfPages == 1 && _hidesForSinglePage) {
		[_pageControl removeFromSuperview];
		[_textLabel removeFromSuperview];
		return;
	}
	
	if (numberOfPages <= kSYPageControlMaxNumberOfDots) {
		_pageControl.numberOfPages = numberOfPages;
		if (!_pageControl.superview) {
			[self addSubview:_pageControl];
		}
		[_textLabel removeFromSuperview];
	} else {
		_pageControl.numberOfPages = 0;
		[_pageControl removeFromSuperview];
		
		[self _updateTextLabel];		
		if (!_textLabel.superview) {
			[self addSubview:_textLabel];
		}
	}
	
	[self setNeedsLayout];
}

- (void)setCurrentPage:(NSInteger)currentPage {
	currentPage = (NSInteger)fminf(fmaxf(0.0f, (CGFloat)currentPage), (CGFloat)_numberOfPages - 1.0f);
	if (currentPage == _currentPage) {
		return;
	}
	
	_currentPage = currentPage;
	
	if (_numberOfPages <= kSYPageControlMaxNumberOfDots) {
		_pageControl.currentPage = currentPage;
	} else {
		[self _updateTextLabel];
	}
//	[self updateDots];
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {

	if ((self = [super initWithFrame:frame])) {
		_pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
		//_pageControl.tintColor = [UIColor grayColor];
		[_pageControl addTarget:self action:@selector(_pageControlChanged:) forControlEvents:UIControlEventValueChanged];
		
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textAlignment = UITextAlignmentCenter;
		_textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
		_textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_textLabel.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_labelTapped:)];
		[_textLabel addGestureRecognizer:tap];
	}
    
    //版本大于等于7
	if(SYSTEM_VESION >= 7.0)
    {
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }

	return self;
}

- (void)layoutSubviews {
	_pageControl.frame = self.bounds;
	_textLabel.frame = self.bounds;
}


#pragma mark - Private

- (void)_updateTextLabel {
	static NSNumberFormatter *numberFormatter = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		numberFormatter = [[NSNumberFormatter alloc] init];
		numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
		numberFormatter.currencySymbol = @"";
		numberFormatter.maximumFractionDigits = 0;
	});
	
	NSString *format = SYPaginatorLocalizedString(@"PAGE_OF_TOTAL");
	if (!format) {
		NSLog(@"[SYPaginator] WARNING: SYPaginatorResources.bundle is missing. Please add it your copy resources build phase.");
		_textLabel.text = nil;
		return;
	}
	
	_textLabel.text = [NSString stringWithFormat:format,
					   [numberFormatter stringFromNumber:[NSNumber numberWithInteger:_currentPage + 1]],
					   [numberFormatter stringFromNumber:[NSNumber numberWithInteger:_numberOfPages]]];
}


- (void)_pageControlChanged:(id)sender {
	self.currentPage = _pageControl.currentPage;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}
/*
-(void)pageChanged:(UIPageControl *)_pageControl
{
	NSArray *subViews = _pageControl.subviews;
	for (int i=0; i<[subViews count]; i++) {
		UIImageView *dot =[_pageControl.subviews objectAtIndex:i];
		dot.image = (i==_pageControl.currentPage)?([UIImage imageNamed:@"Point_current_10.png"]):([UIImage imageNamed:@"Point_10.png"]);
	}

}
*/

-(void) updateDots
{
	NSArray *subViews = _pageControl.subviews;
	for (int i=0; i<[subViews count]; i++) {
		UIImageView *dot =[_pageControl.subviews objectAtIndex:i];
		if ([dot isKindOfClass:[UIImageView class]]) {
		dot.image = (i==_pageControl.currentPage)?([UIImage imageNamed:@"bg_curpagepoint.png"]):([UIImage imageNamed:@"bg_pagepoint.png"]);
		}
	}
}

- (void)_labelTapped:(UITapGestureRecognizer *)gestureRecognizer {
	BOOL increment = [gestureRecognizer locationInView:self].x >= self.bounds.size.width / 2.0f;
	self.currentPage += increment ? 1 : -1;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
