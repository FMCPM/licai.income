//
//  SYPaginatorScrollView.m
//  SYPaginator
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import "SYPaginatorScrollView.h"

@implementation SYPaginatorScrollView
@synthesize touchesdelegate=_touchesdelegate;

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!self.dragging) {
		[self.nextResponder touchesEnded:touches withEvent:event];
		if (_touchesdelegate!=nil) {
			[_touchesdelegate scrollViewTouchesEndedView:touches withEvent:event whichView:self];
		}
		NSLog(@"UITouchScrollView nextResponder touchesEnded");
	}
	[super touchesEnded:touches withEvent:event];
}



- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
	return;
}


- (id<UIScrollViewDelegate>)privateDelegate {
	return [self delegate];
}


- (void)setPrivateDelegate:(id<UIScrollViewDelegate>)privateDelegate {
	[super setDelegate:privateDelegate];
}

@end
