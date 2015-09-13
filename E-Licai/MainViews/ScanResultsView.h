//
//  ScanResultsView.h

//
//  Created by  on 14-3-16.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"


@interface ScanResultsView : UIViewController <UIWebViewDelegate,ZBarReaderDelegate>
{
	UIView *viewLine;
	NSTimer * timer;
	
}
@property (strong ,nonatomic) NSString *ScanResultsStr;
@property (strong ,nonatomic) IBOutlet  UIView *scanView;

@end
