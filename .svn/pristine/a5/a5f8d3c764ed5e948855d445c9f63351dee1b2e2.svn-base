//
//  ViewController.m
//  QR code
//
//  Created by 斌 on 12-8-2.
//  Copyright (c) 2012年 斌. All rights reserved.
//

#import "QRViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"

@interface QRViewController ()

@end

@implementation QRViewController

@synthesize m_uiImageView = _uiImageView;
@synthesize m_uiTextField  = _uiTextField;
@synthesize m_uiLabel = _uiLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)button:(id)sender {
    /*扫描二维码部分：
    导入ZBarSDK文件并引入一下框架
    AVFoundation.framework
    CoreMedia.framework
    CoreVideo.framework
    QuartzCore.framework
    libiconv.dylib
    引入头文件#import “ZBarSDK.h” 即可使用
    当找到条形码时，会执行代理方法
    
    - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
    
    最后读取并显示了条形码的图片和内容。*/
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];
    //[reader release];
}

- (IBAction)button2:(id)sender {
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */
	_uiImageView.image = [QRCodeGenerator qrImageForString:_uiTextField.text imageSize:_uiImageView.bounds.size.width];
    
}

- (IBAction)Responder:(id)sender {
    //键盘释放
   // [text resignFirstResponder];

}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    _uiImageView.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissModalViewControllerAnimated: YES];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    _uiLabel.text =  symbol.data ;
    
    if ([predicate evaluateWithObject:_uiLabel.text]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"It will use the browser to this URL。"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        alert.tag=1;
        [alert show];
     //   [alert release];
        
        
        
    }
    else if([ssidPre evaluateWithObject:_uiLabel.text]){

        NSArray *arr = [_uiLabel.text componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        
        
        _uiLabel.text=
        [NSString stringWithFormat:@"ssid: %@ \n password:%@",
         [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:_uiLabel.text
                                                        message:@"The password is copied to the clipboard , it will be redirected to the network settings interface"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        
        
        alert.delegate = self;
        alert.tag=2;
        [alert show];
     //   [alert release];
        
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //        然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1]; 
        
        
    }
}


@end
