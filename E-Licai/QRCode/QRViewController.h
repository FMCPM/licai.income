//
//  ViewController.h
//  QR code
//
//  Created by 斌 on 12-8-2.
//  Copyright (c) 2012年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface QRViewController : UIViewController< ZBarReaderDelegate,UIAlertViewDelegate >
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *m_uiLabel;

@property (strong, nonatomic) IBOutlet UIImageView *m_uiImageView;
@property (strong, nonatomic) IBOutlet UITextField *m_uiTextField;

- (IBAction)button:(id)sender;
- (IBAction)button2:(id)sender;
- (IBAction)Responder:(id)sender;


@end
