//
//  ContactViewController.h
//  watermarker
//
//  Created by dongjunsong on 07/07/2014.
//  Copyright (c) 2014 brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactViewController : UIViewController <MFMailComposeViewControllerDelegate> 
- (IBAction)email1clicked:(id)sender;
- (IBAction)email2clicked:(id)sender;

@end
