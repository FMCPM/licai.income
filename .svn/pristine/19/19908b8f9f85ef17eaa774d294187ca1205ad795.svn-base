//
//  SYPaginatorScrollView.h
//  SYPaginator
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIScrollViewTouchesDelegate

-(void)scrollViewTouchesEndedView:(NSSet *)touches withEvent :(UIEvent *)event whichView:(id)scrollVuew;

@end


@interface SYPaginatorScrollView : UIScrollView

@property (nonatomic, unsafe_unretained) id<UIScrollViewDelegate> privateDelegate;
@property (nonatomic,assign)id<UIScrollViewTouchesDelegate>touchesdelegate;
@end
